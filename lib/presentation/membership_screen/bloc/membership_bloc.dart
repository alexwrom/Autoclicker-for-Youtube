


import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:youtube_clicker/data/services/in_app_purchase_service.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/domain/models/product_purchase_model.dart';
import 'package:youtube_clicker/domain/repository/in_app_purchase_repository.dart';
import 'package:youtube_clicker/utils/failure.dart';
import '../../../data/utils/handle_subscription_util.dart';
import 'membership_event.dart';
import 'membership_state.dart';

class MemberShipBloc extends Bloc<MemberShipEvent,MemberShipState>{


  late final HandleSubscriptionUtil _purchasesSubscription;
  late final inAppPurchaseService=locator.get<InAppPurchaseService>();


  MemberShipBloc():super(MemberShipState.unknown()){
      _purchasesSubscription=HandleSubscriptionUtil(
        onCanceled: (){
          add(OnCanceledEvent());
        },
        onError: (){
          add(OnErrorEvent());
        },
        onPurchased: (PurchaseDetails purchaseDetails) async {
          try {
            // тут мы проверяем наш платеж на стороне сервера передав данные о платеже ,
            // и если все ок завершаем  покупку
            //final bool res = await transactionRepository.createTransaction(purchaseDetails.verificationData.serverVerificationData);
            if (purchaseDetails.status==PurchaseStatus.purchased) {
              await inAppPurchaseService.completePurchase(purchaseDetails);
              add(OnPurchasedEvent());
            }
          } catch (_, __) {
               add(OnErrorEvent());
          }
        },
      )..init();
     on<GetProductEvent>(_getProduct);
     on<BuySubscriptionEvent>(_buySubscription);
     on<OnErrorEvent>(_onPurchaseError);
     on<OnCanceledEvent>(_onCanceled);
     on<OnPurchasedEvent>(_onPurchased);
  }


  @override
  Future<void> close()async {
    super.close();
    _purchasesSubscription.close();
  }

  void _onPurchaseError(event,emit){
     emit(state.copyWith(memebStatus: MemberShipStatus.error,error: 'An unknown error has occurred'));
  }
  void _onCanceled(event,emit){
    emit(state.copyWith(memebStatus: MemberShipStatus.canceled));
  }

  void _onPurchased(event,emit){
    emit(state.copyWith(memebStatus: MemberShipStatus.purchased));
  }

  final _purchaseRepository=locator.get<InAppPurchaseRepository>();
        Future<void> _getProduct(event,emit)async{
          try {
            List<String> listPriceOneTranslate=[];
            emit(state.copyWith(memebStatus: MemberShipStatus.loading));
            final listProd=await _purchaseRepository.getProducts();
            if(listProd.isEmpty){
              emit(state.copyWith(memebStatus: MemberShipStatus.empty));
            }else{
              for (var element in listProd) {
                 listPriceOneTranslate.add(_getOnePriceTranslate(element.rawPrice,element.limitTranslation));
              }
              emit(state.copyWith(memebStatus: MemberShipStatus.loaded,listDetails: listProd,priceOneTranslate: listPriceOneTranslate));
            }

          }on Failure catch (error) {
            emit(state.copyWith(memebStatus: MemberShipStatus.error,error: error.message));
          }

      }


  String _getOnePriceTranslate(double price,int countTranslate){

    double r=price/countTranslate;
    return r.toString().substring(0,3);
  }

   Future<void> _buySubscription(BuySubscriptionEvent event,emit)async{
          emit(state.copyWith(memebStatus: MemberShipStatus.loading));
        final result= await inAppPurchaseService.buyItemInStore(ProductPurchaseModel.toApi(productPurchaseModel: event.productPurchaseModel));
   }



   }