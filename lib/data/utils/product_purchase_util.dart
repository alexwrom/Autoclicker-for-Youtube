

 import 'package:youtube_clicker/data/mappers/product_purchase_mapper.dart';

import '../../di/locator.dart';
import '../../domain/models/product_purchase_model.dart';
import '../services/in_app_purchase_service.dart';

class ProductPurchaseUtil{


    final _api=locator.get<InAppPurchaseService>();



   Future<List<ProductPurchaseModel>> getProducts() async{
     List<ProductPurchaseModel> prod=[];
     final res=await _api.getProducts();
     for (var element in res) {
        prod.add(ProductPurchaseMapper.fromApi(productPurchaseFromApi: element));
     }
     return  prod;

   }

 }