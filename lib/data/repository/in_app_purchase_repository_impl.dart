



 import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/domain/models/product_purchase_model.dart';
import 'package:youtube_clicker/domain/repository/in_app_purchase_repository.dart';

import '../utils/product_purchase_util.dart';

class InAppPurchaseRepositoryImpl extends InAppPurchaseRepository{

  final _util=locator.get<ProductPurchaseUtil>();

  @override
  Future<List<ProductPurchaseModel>> getProducts()async {
    return _util.getProducts();
  }


}