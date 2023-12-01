


  import 'dart:io';


import 'package:device_info_plus/device_info_plus.dart';
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
   UserData? _userData;


  getDataUser()async{
    bool isSubscribe=false;
    bool isFreeTrial=false;
    String uid='';
    emit(state.copyWith(userDataStatus: UserDataStatus.loading));
    try {
       uid=PreferencesUtil.getEmail;
       _userData=await _repositoryUser.getDataUser(email: uid);
       // if(_userData!.timeStampPurchase>0){
       //   isFreeTrial=false;
       // }
       emit(state.copyWith(userDataStatus: UserDataStatus.success,userData: _userData,isSubscribe: isSubscribe,isFreeTrial:isFreeTrial));
    }on Failure catch (e) {
      emit(state.copyWith(userDataStatus: UserDataStatus.error,error: e.message));
    }
  }

  void updateUser({required UserData userData}){
    _userData = userData;
    emit(state.copyWith(userData: _userData));
  }


  setListCodeLanguage(List<String> list)async{
    emit(state.copyWith(choiceCodeLanguageList: list));
  }




   clearBalance()async{
     String uid='';
      uid=PreferencesUtil.getEmail;
    _userData=_userData!.copyWith(numberOfTrans: 0);
    await _repositoryUser.updateBalance(balance: _userData!.numberOfTrans, uid: uid);
     emit(state.copyWith(userDataStatus: UserDataStatus.success,userData: _userData));
   }



   updateBalance(int numberTranslate)async{
     String uid='';
      uid=PreferencesUtil.getEmail;
    int balance=_userData!.numberOfTrans;
    if (balance>0){
     final res= balance-numberTranslate;
      await _repositoryUser.updateBalance(balance: res, uid: uid);
      _userData=_userData!.copyWith(numberOfTrans: res);
      emit(state.copyWith(userDataStatus: UserDataStatus.success,userData: _userData));
    }


   }

  addBalance(int limitTranslate)async{
    _userData=_userData!.copyWith(numberOfTrans: limitTranslate);
    emit(state.copyWith(userDataStatus: UserDataStatus.success,userData: _userData,isSubscribe: true));
  }



  }