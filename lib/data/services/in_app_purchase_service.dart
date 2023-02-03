

  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:youtube_clicker/data/models/product_purchase_from_api.dart';

import '../../utils/failure.dart';

class InAppPurchaseService{

    final InAppPurchase _inAppPurchase = InAppPurchase.instance;
    final Stream<List<PurchaseDetails>> _storeSubscription =
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

  }