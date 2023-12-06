import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/domain/models/config_app_entity.dart';
import 'package:youtube_clicker/domain/repository/auth_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:youtube_clicker/utils/failure.dart';


import '../presentation/auth_screen/bloc/auth_bloc.dart';
import '../utils/preferences_util.dart';

part 'app_event.dart';

part 'app_state.dart';

enum LocalStatus { ru, en }

class AppBloc extends Bloc<AppEvent, AppState> {


  final _authRepository = locator.get<AuthRepository>();


  AppBloc() : super(AppState.unknown()) {
    on<AuthInitCheck>(_authInitCheck);
    on<CloseSplashEvent>(_closeSplash);
    on<CheckAppUpdateEvent>(_checkUpdateApp);
  }




  void _closeSplash(CloseSplashEvent event,emit) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    final userEmail = PreferencesUtil.getEmail;
    if (userEmail.isEmpty) {
      emit(state.copyWith(authStatusCheck: AuthStatusCheck.unauthenticated));
    }else{
      emit(state.copyWith(authStatusCheck: AuthStatusCheck.authenticated));
    }
  }


  void _checkUpdateApp(CheckAppUpdateEvent event,emit) async {
    try{
      emit(state.copyWith(checkUpdateStatus: CheckUpdateStatus.unknown));
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final versionApp = packageInfo.version;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        await FirebaseAuth.instance.signInAnonymously();
        final config = await _authRepository.getConfigApp();
        await FirebaseAuth.instance.signOut();
        if(config.mobileVersion.isNotEmpty&&versionApp!=config.mobileVersion){
          emit(state.copyWith(checkUpdateStatus: CheckUpdateStatus.showMenuUpdate,configAppEntity: config));
          await Future.delayed(const Duration(milliseconds: 200));
          emit(state.copyWith(checkUpdateStatus: CheckUpdateStatus.unknown));
        }
      } else {
        final config = await _authRepository.getConfigApp();
        if(config.mobileVersion.isNotEmpty&&versionApp!=config.mobileVersion){
          emit(state.copyWith(checkUpdateStatus: CheckUpdateStatus.showMenuUpdate,configAppEntity: config));
          await Future.delayed(const Duration(milliseconds: 200));
          emit(state.copyWith(checkUpdateStatus: CheckUpdateStatus.unknown));
        }

      }

    }on Failure catch(error){
      print('Error app check update');
    }
  }

  void _authInitCheck(event, emit) async {
    await Future.delayed(const Duration(milliseconds: 2500));
    emit(state.copyWith(authStatusCheck: AuthStatusCheck.unknown));
    final code=PreferencesUtil.getCOdeVerificationEmail[0];
    if(code.isNotEmpty){
       final timeNow=  DateTime.now().millisecondsSinceEpoch;
       final tsString=PreferencesUtil.getCOdeVerificationEmail[1];
       final timeStamp= int.parse(tsString);
       const int lifetimeCode=60000;
       final int timeCheck=timeNow-timeStamp;
       if(lifetimeCode<timeCheck){
          PreferencesUtil.setPassword('');
          PreferencesUtil.setCodeVerificationEmail(['','']);
       }else{
         emit(state.copyWith(authStatusCheck: AuthStatusCheck.verificationCodeExist));
         return;
       }
    }
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final versionApp = packageInfo.version;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      await FirebaseAuth.instance.signInAnonymously();
      final config = await _authRepository.getConfigApp();
      await FirebaseAuth.instance.signOut();
      if(config.mobileVersion.isNotEmpty&&versionApp!=config.mobileVersion){
        emit(state.copyWith(checkUpdateStatus: CheckUpdateStatus.showMenuUpdate,configAppEntity: config));
        await Future.delayed(const Duration(milliseconds: 200));
        emit(state.copyWith(checkUpdateStatus: CheckUpdateStatus.unknown));
      }else{
        emit(state.copyWith(authStatusCheck: AuthStatusCheck.unauthenticated));
      }
    } else {
      final config = await _authRepository.getConfigApp();
      if(config.mobileVersion.isNotEmpty&&versionApp!=config.mobileVersion){
        emit(state.copyWith(checkUpdateStatus: CheckUpdateStatus.showMenuUpdate,configAppEntity: config));
        await Future.delayed(const Duration(milliseconds: 200));
        emit(state.copyWith(checkUpdateStatus: CheckUpdateStatus.unknown));
      }else{
        emit(state.copyWith(authStatusCheck: AuthStatusCheck.authenticated));
      }

    }
  }







}
