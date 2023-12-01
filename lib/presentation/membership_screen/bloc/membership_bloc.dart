


import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:youtube_clicker/data/services/in_app_purchase_service.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/domain/models/product_purchase_model.dart';
import 'package:youtube_clicker/domain/repository/in_app_purchase_repository.dart';
import 'package:youtube_clicker/utils/failure.dart';
import 'package:youtube_clicker/utils/preferences_util.dart';
import '../../../data/utils/handle_subscription_util.dart';
import '../../../domain/models/user_data.dart';
import '../../main_screen/cubit/user_data_cubit.dart';
import 'membership_event.dart';
import 'membership_state.dart';

class MemberShipBloc extends Bloc<MemberShipEvent,MemberShipState>{


  late final HandleSubscriptionUtil _purchasesSubscription;
  final UserDataCubit cubitUserData;
  late final inAppPurchaseService=locator.get<InAppPurchaseService>();


  MemberShipBloc({required this.cubitUserData}):super(MemberShipState.unknown()){
      _purchasesSubscription=HandleSubscriptionUtil(
        onCanceled: (){
          add(OnCanceledEvent());
        },
        onError: (){
          add(OnErrorEvent());
        },
        onComplete: (PurchaseDetails purchaseDetails)async{
          await inAppPurchaseService.completePurchase(purchaseDetails);
        },
        onPurchased: (PurchaseDetails purchaseDetails) async {
          try {
            if (purchaseDetails.status==PurchaseStatus.purchased) {
              final oldBalance=cubitUserData.state.userData.numberOfTrans;
              final isTakeBonus = cubitUserData.state.userData.isTakeBonus;
              final limitTranslate=state.listDetails.firstWhere((element) => purchaseDetails.productID==element.id).limitTranslation;
              final resultBalance=oldBalance+limitTranslate;
              await inAppPurchaseService.updateBalance(resultBalance: resultBalance,isTakeBonus:isTakeBonus);
              await cubitUserData.addBalance(resultBalance);
              _updateUser();
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

  void _updateUser() {
     UserData userData = cubitUserData.state.userData;
    userData = userData.copyWith(isTakeBonus:1);
    cubitUserData.updateUser(userData:userData);
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
            listProd.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
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
          }catch (error){
            emit(state.copyWith(memebStatus: MemberShipStatus.error,error: error.toString()));
          }

      }


  String _getOnePriceTranslate(double price,int balance){

    double r=price/balance;
    return (r*100.0).toString().substring(0,3);
  }

   Future<void> _buySubscription(BuySubscriptionEvent event,emit)async{
          final email=PreferencesUtil.getEmail;
          emit(state.copyWith(memebStatus: MemberShipStatus.loading));
        await inAppPurchaseService.buyItemInStore(ProductPurchaseModel.toApi(productPurchaseModel: event.productPurchaseModel),email);
   }



   }