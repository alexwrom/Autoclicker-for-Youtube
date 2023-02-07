


  import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clicker/domain/models/user_data.dart';
import 'package:youtube_clicker/presentation/main_screen/cubit/user_data_state.dart';
  import 'package:youtube_clicker/utils/preferences_util.dart';
import '../../../di/locator.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../utils/failure.dart';

class UserDataCubit extends Cubit<UserdataState>{
  UserDataCubit():super(UserdataState.unknown());

  final _repositoryUser=locator.get<UserRepository>();
  final _uid=PreferencesUtil.getUid;
   UserData? _userData;


  getDataUser()async{
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
   updateBalance(int numberTranslate)async{
    int balance=_userData!.numberOfTrans;
    if (balance>0){
     final res= balance-numberTranslate;
      await _repositoryUser.updateBalance(balance: res, uid: _uid, isActive: _userData!.isActive);
      _userData=_userData!.copyWith(numberOfTrans: res);
      emit(state.copyWith(userDataStatus: UserDataStatus.success,userData: _userData));
    }


   }

  addBalance(int limitTranslate)async{
    _userData=_userData!.copyWith(numberOfTrans: limitTranslate);
    emit(state.copyWith(userDataStatus: UserDataStatus.success,userData: _userData,isSubscribe: true));
  }



  }