

  import 'dart:async';
  import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
  import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:youtube_clicker/data/models/product_purchase_from_api.dart';
import 'package:youtube_clicker/utils/preferences_util.dart';

import '../../utils/failure.dart';

class InAppPurchaseService{

    final InAppPurchase _inAppPurchase = InAppPurchase.instance;
    final Stream<List<PurchaseDetails>> storeSubscription =
        InAppPurchase.instance.purchaseStream;

    InAppPurchase get instance => _inAppPurchase;
    FirebaseFirestore? _firebaseFirestore;




    Future<List<ProductPurchaseFromApi>> getProducts() async {
      List<ProductPurchaseFromApi> products=[];
      Set<String> idsProd={};
      _firebaseFirestore=FirebaseFirestore.instance;
      final bool isAvailable = await _inAppPurchase.isAvailable();
      if (!isAvailable) {
        return [];
      }
      CollectionReference collectionRef= _firebaseFirestore!.collection('products');
      QuerySnapshot querySnapshot = await collectionRef.get();
      final listProdFromFirebase = querySnapshot.docs.map((doc) => doc).toList();

      for(int i=0;i<listProdFromFirebase.length;i++){
        idsProd.add(listProdFromFirebase[i].id.trim());
      }

      try {
        _firebaseFirestore=FirebaseFirestore.instance;
        final bool isAvailable = await _inAppPurchase.isAvailable();
        if (!isAvailable) {
                return [];
              }
        CollectionReference collectionRef= _firebaseFirestore!.collection('products');
        QuerySnapshot querySnapshot = await collectionRef.get();
        final listProdFromFirebase = querySnapshot.docs.map((doc) => doc).toList();
         print('List ptod IDS ${listProdFromFirebase.length}');
        for(int i=0;i<listProdFromFirebase.length;i++){
          idsProd.add(listProdFromFirebase[i].id.trim());
        }
        final ProductDetailsResponse productDetailResponse =
              await _inAppPurchase.queryProductDetails(idsProd);
        if(productDetailResponse.error != null){
           throw Failure(productDetailResponse.error!.message);
        }
        print('List ptod Det ${productDetailResponse.productDetails}');
        if (productDetailResponse.productDetails.isEmpty) {
                return [];
        }

        for(int i=0;i<productDetailResponse.productDetails.length;i++){
          products.add(ProductPurchaseFromApi.fromApi(
              documentSnapshot: listProdFromFirebase.firstWhere((element) => productDetailResponse.productDetails[i].id==element.id),
              productDetails: productDetailResponse.productDetails[i]));
        }
      } on FirebaseException catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } on Failure catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      }on PlatformException catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      }on RangeError catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      }

      return products;


    }

    Future<void> buyItemInStore(ProductDetails product, String userEmail) async {

      await  clearTransactionsIos();
      var purchaseParam = PurchaseParam(
        productDetails: product,
        //applicationUserName: userEmail,
      );
      final res = await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam,autoConsume: true);
      if (!res) {
        throw const Failure(
            'purchase request was not initially sent successfully');
      }
    }

    Future<void> completePurchase(PurchaseDetails purchaseDetails,int limitTranslation) async {
      final uid=PreferencesUtil.getUid;
      await InAppPurchase.instance.completePurchase(purchaseDetails);
      await _updateBalance(uid: uid,limitTranslation: limitTranslation);
    }

    Future<void> clearTransactionsIos() async {
      if (Platform.isIOS) {
        var paymentWrapper = SKPaymentQueueWrapper();
        final transactions = await SKPaymentQueueWrapper().transactions();
        for (final transaction in transactions) {
          try {
            if (transaction.error != null && transaction.error!.domain == 'SKErrorDomain' && transaction.error!.code == 2) {
              await paymentWrapper.finishTransaction(transaction);
            }
            await SKPaymentQueueWrapper().finishTransaction(transaction);
          } catch (e) {
            print(e);
            print('clearTransactionsIos failed');
            // throw const Failure('Transactions clear failed');
          }
        }
      }
    }









    Future<void> _updateBalance({required String uid,required int limitTranslation})async{
      try {
        final ts=DateTime.now().millisecondsSinceEpoch;
        _firebaseFirestore=FirebaseFirestore.instance;
        await _firebaseFirestore!.collection('users').doc(uid).update({
          'timestampPurchase':ts,
          'balance':limitTranslation
        });
      } on FirebaseException catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } on Failure catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      }on PlatformException catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      }


    }


}