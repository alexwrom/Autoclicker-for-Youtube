


  class ProductPurchaseModel{

    final String id;
    final String title;
    final String description;
    final String price;
    final double rawPrice;
    final String currencyCode;
    final String currencySymbol;
    final bool isActive;
    final String priceOneTransfer;
    final String titlePriceOneTransfer;
    final int limitTranslation;
    final String titleLimitTranslation;
    final String  titlePrice;
    final bool isSale;

    const ProductPurchaseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rawPrice,
    required this.currencyCode,
    required this.currencySymbol,
    required this.isActive,
    required this.priceOneTransfer,
    required this.titlePriceOneTransfer,
    required this.limitTranslation,
    required this.titleLimitTranslation,
    required this.titlePrice,
    required this.isSale,
  });
}