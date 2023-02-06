


  import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clicker/domain/models/user_data.dart';
import 'package:youtube_clicker/presentation/main_screen/cubit/user_data_state.dart';
  import 'package:youtube_clicker/utils/preferences_util.dart';
import '../../../data/services/in_app_purchase_service.dart';
import '../../../di/locator.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../utils/failure.dart';

class UserDataCubit extends Cubit<UserdataState>{
  UserDataCubit():super(UserdataState.unknown());

  final _repositoryUser=locator.get<UserRepository>();
  late final _inAppPurchaseService=locator.get<InAppPurchaseService>();
  final _uid=PreferencesUtil.getUid;
   UserData? _userData;


  getDataUser()async{
    final tsNow=DateTime.now().millisecondsSinceEpoch;
    bool isSubscribe=false;
    bool isFreeTrial=true;
    emit(state.copyWith(userDataStatus: UserDataStatus.loading));
    try {
       _userData=await _repositoryUser.getDataUser(uid: _uid);

       if(_userData!.isActive){
         _userData=_userData!.copyWith(numberOfTrans: _userData!.numberOfTransActive);
       }else{
         if(_userData!.timeStampPurchase>0){
            isFreeTrial=false;
         }
         _inAppPurchaseService.checkSubStatus(currentSubId: 'gold');
         //todo проверить наличие подписки из стора
         if(_userData!.timeStampPurchase<tsNow){
           //todo нужно проверить продление подписки
           isSubscribe=false;
           clearBalance();
         }else{
           isSubscribe=true;
         }
       }
       emit(state.copyWith(userDataStatus: UserDataStatus.success,userData: _userData,isSubscribe: isSubscribe,isFreeTrial:isFreeTrial));
    }on Failure catch (e) {
      emit(state.copyWith(userDataStatus: UserDataStatus.error,error: e.message));
    }
  }



   //todo error
   clearBalance()async{
    _userData=_userData!.copyWith(numberOfTrans: 0);
    await _repositoryUser.updateBalance(balance: _userData!.numberOfTrans, uid: _uid, isActive: _userData!.isActive);
     emit(state.copyWith(userDataStatus: UserDataStatus.success,userData: _userData));
   }


   //todo error
   updateBalance()async{
    int balance=_userData!.numberOfTrans;
    if (balance>0){
      balance--;
      await _repositoryUser.updateBalance(balance: balance, uid: _uid, isActive: _userData!.isActive);
      _userData=_userData!.copyWith(numberOfTrans: balance);
      emit(state.copyWith(userDataStatus: UserDataStatus.success,userData: _userData));
    }


   }

  addBalance(int limitTranslate)async{
    _userData=_userData!.copyWith(numberOfTrans: limitTranslate);
    emit(state.copyWith(userDataStatus: UserDataStatus.success,userData: _userData,isSubscribe: true));
  }



  }