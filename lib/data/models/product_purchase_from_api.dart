



  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class ProductPurchaseFromApi{


    final String id;
    final String title;
    final String description;
    final String price;
    final double rawPrice;
    final String currencyCode;
    final String currencySymbol;
    final bool isActive;
    final String titlePriceOneTransfer;
    final int limitTranslation;
    final String titleLimitTranslation;
    final String  titlePrice;
    final bool isSale;
    final int priceSale;

    ProductPurchaseFromApi.fromApi({required QueryDocumentSnapshot documentSnapshot,required ProductDetails productDetails}):
     id=productDetails.id,
     title=productDetails.title,
     description=productDetails.description,
     price=productDetails.price,
     rawPrice=productDetails.rawPrice,
     currencyCode=productDetails.currencyCode,
     currencySymbol=productDetails.currencySymbol,
     isActive=false,
     titlePriceOneTransfer=documentSnapshot.get('titlePriceOneTransfer'),
     limitTranslation=documentSnapshot.get('limitTranslation'),
     titleLimitTranslation=documentSnapshot.get('titleLimitTranslation'),
      titlePrice=documentSnapshot.get('titlePrice'),
     isSale=documentSnapshot.get('isSale'),
     priceSale=documentSnapshot.get('priceSale');
}