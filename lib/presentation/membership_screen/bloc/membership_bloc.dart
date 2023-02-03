


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/domain/repository/in_app_purchase_repository.dart';
import 'package:youtube_clicker/utils/failure.dart';
import 'membership_event.dart';
import 'membership_state.dart';

class MemberShipBloc extends Bloc<MemberShipEvent,MemberShipState>{
  MemberShipBloc():super(MemberShipState.unknown()){
     on<GetProductEvent>(_getProduct);
  }


  final _purchaseRepository=locator.get<InAppPurchaseRepository>();



      Future<void> _getProduct(event,emit)async{
          try {
            emit(state.copyWith(memebStatus: MemberShipStatus.loading));
            final listProd=await _purchaseRepository.getProducts();
            if(listProd.isEmpty){
              emit(state.copyWith(memebStatus: MemberShipStatus.empty));
            }else{
              emit(state.copyWith(memebStatus: MemberShipStatus.loaded,listDetails: listProd));
            }

          }on Failure catch (error,stackTrace) {
            Error.throwWithStackTrace(Failure(error.message), stackTrace);
          }

      }



   }