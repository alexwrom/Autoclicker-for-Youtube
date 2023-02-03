


  import '../models/product_purchase_model.dart';

abstract class InAppPurchaseRepository{

    Future<List<ProductPurchaseModel>> getProducts();

  }