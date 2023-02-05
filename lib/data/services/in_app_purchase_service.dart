

  import 'dart:async';
  import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
  import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:youtube_clicker/data/models/product_purchase_from_api.dart';

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
      try {
        _firebaseFirestore=FirebaseFirestore.instance;
        final bool isAvailable = await _inAppPurchase.isAvailable();
        if (!isAvailable) {
                return [];
              }
        CollectionReference collectionRef= _firebaseFirestore!.collection('products');
        QuerySnapshot querySnapshot = await collectionRef.get();
        final listProdFromFirebase = querySnapshot.docs.map((doc) => doc).toList();
        for(int i=0;i<listProdFromFirebase.length;i++){
          idsProd.add(listProdFromFirebase[i].id);
        }
        final ProductDetailsResponse productDetailResponse =
              await _inAppPurchase.queryProductDetails(idsProd);
        if(productDetailResponse.error != null){
           throw Failure(productDetailResponse.error!.message);
        }
        if (productDetailResponse.productDetails.isEmpty) {
                return [];
        }
        for(int i=0;i<listProdFromFirebase.length;i++){
          products.add(ProductPurchaseFromApi.fromApi(
              documentSnapshot: listProdFromFirebase[i],
              productDetails: productDetailResponse.productDetails[i]));
        }
      } on FirebaseException catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } on Failure catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      }on PlatformException catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      }

      return products;


    }

    Future<void> buyItemInStore(ProductDetails product) async {

      await  clearTransactionsIos();
      var purchaseParam = PurchaseParam(
        productDetails: product,
        applicationUserName: 'mr.borodachsanya@gmail.com',
      );
      if (Platform.isAndroid) {
        final androidPurchaseParam =
        await _getAndroidSubscriptionUpdatePurchaseParam(
            product, product.id);
        purchaseParam = androidPurchaseParam ?? purchaseParam;
      }
      final res = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      if (!res) {
        throw const Failure(
            'purchase request was not initially sent successfully');
      }
      // final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      // return InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
    }

    Future<void> completePurchase(PurchaseDetails purchaseDetails) async {
      await InAppPurchase.instance.completePurchase(purchaseDetails);
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


    Future<PurchaseParam?> _getAndroidSubscriptionUpdatePurchaseParam(
        ProductDetails productDetails,
        String? currentSubId,
        ) async {
      if (!Platform.isAndroid) return null;

      final oldPurchaseDetails = await _getOldSubscriptionPurchaseDetails(currentSubId);
      if (oldPurchaseDetails == null) return null;

      return GooglePlayPurchaseParam(
        productDetails: productDetails,
        changeSubscriptionParam: ChangeSubscriptionParam(
          oldPurchaseDetails: oldPurchaseDetails,
          prorationMode: ProrationMode.immediateWithoutProration,
        ),
      );
    }

    Future<GooglePlayPurchaseDetails?> _getOldSubscriptionPurchaseDetails(
        String? currentSubId,
        ) async {
      if (!Platform.isAndroid) return null;
      GooglePlayPurchaseDetails? oldPurchaseDetails;
      final androidAddition =
      _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final oldPurchaseDetailsQuery = await androidAddition.queryPastPurchases();
      print('past purchases old ${oldPurchaseDetailsQuery.pastPurchases}');
      for (GooglePlayPurchaseDetails purchase in oldPurchaseDetailsQuery.pastPurchases) {
        //TODO: subscribe in account create new account. got 2 active subs. can't switch between subs.
        print('===Current subs===');
        print(currentSubId);
        print(purchase.productID);
        print(purchase.status);
        print('===Current subs===');
        if (currentSubId == purchase.productID) {
          oldPurchaseDetails = purchase;
        }
      }
      return oldPurchaseDetails;
    }


}