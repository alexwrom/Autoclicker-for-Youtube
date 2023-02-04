

  import 'package:equatable/equatable.dart';

import '../../../domain/models/product_purchase_model.dart';

class MemberShipEvent extends Equatable{
  @override
  List<Object?> get props => [];

}

class GetProductEvent extends MemberShipEvent {}
  class OnErrorEvent extends MemberShipEvent{}
  class OnCanceledEvent extends MemberShipEvent{}
  class OnPurchasedEvent extends MemberShipEvent{}
  class BuySubscriptionEvent extends MemberShipEvent{
     final ProductPurchaseModel productPurchaseModel;
     BuySubscriptionEvent({
    required this.productPurchaseModel,
  });
}