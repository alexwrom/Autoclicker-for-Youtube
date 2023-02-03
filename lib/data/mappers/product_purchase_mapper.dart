

 import 'package:youtube_clicker/domain/models/product_purchase_model.dart';

import '../models/product_purchase_from_api.dart';

class ProductPurchaseMapper{


   static ProductPurchaseModel fromApi({required ProductPurchaseFromApi productPurchaseFromApi}){

     return ProductPurchaseModel(id: productPurchaseFromApi.id,
         title: productPurchaseFromApi.title,
         description: productPurchaseFromApi.description,
         price: productPurchaseFromApi.price,
         rawPrice: productPurchaseFromApi.rawPrice,
         currencyCode: productPurchaseFromApi.currencyCode,
         currencySymbol: productPurchaseFromApi.currencySymbol,
         isActive: productPurchaseFromApi.isActive,
         priceOneTransfer: productPurchaseFromApi.priceOneTransfer,
         titlePriceOneTransfer: productPurchaseFromApi.titlePriceOneTransfer,
         limitTranslation: productPurchaseFromApi.limitTranslation,
         titleLimitTranslation: productPurchaseFromApi.titleLimitTranslation,
         titlePrice: productPurchaseFromApi.titlePrice,
         isSale: productPurchaseFromApi.isSale);
   }




 }