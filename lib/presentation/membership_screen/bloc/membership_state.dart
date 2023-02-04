


    import 'package:equatable/equatable.dart';

import '../../../domain/models/product_purchase_model.dart';


 enum MemberShipStatus{
    loading,
   error,
   canceled,
   restored,
   pending,
   purchased,
   unknown,
   loaded,
   empty,
    }

    extension MemberShipStatusExt on MemberShipStatus{
     bool get isLoading=>this==MemberShipStatus.loading;
     bool get isError=>this==MemberShipStatus.error;
     bool get isCanceled=>this==MemberShipStatus.canceled;
     bool get isRestored=>this==MemberShipStatus.restored;
     bool get isPending=>this==MemberShipStatus.pending;
     bool get isPurchased=>this==MemberShipStatus.purchased;
     bool get isUnknown=>this==MemberShipStatus.unknown;
     bool get isLoaded=>this==MemberShipStatus.loaded;
     bool get isEmpty=>this==MemberShipStatus.empty;
    }

class MemberShipState extends Equatable{


   final List<ProductPurchaseModel> listDetails;
   final MemberShipStatus memebStatus;
   final String error;
   final List<String> priceOneTranslate;


   const MemberShipState(this.listDetails, this.memebStatus, this.error,this.priceOneTranslate);


  factory MemberShipState.unknown(){
    return const MemberShipState([], MemberShipStatus.unknown, '',[]);
  }




  @override
  List<Object?> get props => [listDetails,memebStatus,error,priceOneTranslate];

   MemberShipState copyWith({
    List<ProductPurchaseModel>? listDetails,
     MemberShipStatus? memebStatus,
    String? error,
     List<String>? priceOneTranslate
  }) {
    return MemberShipState(
      listDetails ?? this.listDetails,
       memebStatus ?? this.memebStatus,
      error ?? this.error,
      priceOneTranslate??this.priceOneTranslate
    );
  }
}