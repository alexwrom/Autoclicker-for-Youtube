


  import 'package:in_app_purchase/in_app_purchase.dart';

class ProductPurchaseModel{

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

    const ProductPurchaseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rawPrice,
    required this.currencyCode,
    required this.currencySymbol,
    required this.isActive,
    required this.titlePriceOneTransfer,
    required this.limitTranslation,
    required this.titleLimitTranslation,
    required this.titlePrice,
    required this.isSale,
      required this.priceSale
  });

    static ProductDetails toApi({required ProductPurchaseModel productPurchaseModel}){
      return ProductDetails(id: productPurchaseModel.id,
          title: productPurchaseModel.title,
          description: productPurchaseModel.description,
          price: productPurchaseModel.price,
          rawPrice: productPurchaseModel.rawPrice,
          currencyCode: productPurchaseModel.currencyCode);
    }
}