



import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/domain/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:youtube_clicker/utils/preferences_util.dart';

import '../../../utils/failure.dart';






part 'auth_event.dart';
part 'auth_state.dart';



enum LocalStatus{
  ru,
  en
}







class AuthBloc extends Bloc<AuthEvent, AuthState> {


   final _authRepository=locator.get<AuthRepository>();
   final boxVideo=Hive.box('video_box');


  AuthBloc()
      : super(AuthState.unknown()) {
    on<LogOutEvent>(_logOut);
    on<SingInEvent>(_singIn);
    on<LogInEvent>(_logIn);
    on<Unknown>(_resetState);

  }

   void _resetState(Unknown event,emit)async{
     emit(state.copyWith(authStatus: AuthStatus.unknown));
   }

   void _singIn(SingInEvent event,emit)async{
     emit(state.copyWith(authStatus: AuthStatus.processSingIn));
     try{
       await _authRepository.singIn(pass: event.password, repPass: event.repPass, email: event.email);
       emit(state.copyWith(authStatus: AuthStatus.authenticated));
     }on Failure catch(error){
       emit(state.copyWith(authStatus: AuthStatus.error,error: error.message));
     }


   }

   void _logIn(LogInEvent event,emit)async{
     emit(state.copyWith(authStatus: AuthStatus.processLogIn));
     try{
       final result= await _authRepository.logIn(pass: event.password,email: event.email);
       if(result){
         emit(state.copyWith(authStatus: AuthStatus.authenticated));
       }
     }on Failure catch(error){
       emit(state.copyWith(authStatus: AuthStatus.error,error: error.message));
     }


   }





  void _singInGoogle(SingInEvent event,emit)async{
    emit(state.copyWith(authStatus: AuthStatus.processSingIn));
    try{
     await _authRepository.singInGoogle();
     emit(state.copyWith(authStatus: AuthStatus.authenticated));
    }on Failure catch(error){
      emit(state.copyWith(authStatus: AuthStatus.error,error: error.message));
    }


  }
  void _logOut(event,emit) async{
    emit(state.copyWith(authStatus: AuthStatus.processLogOut));
    try{
      await PreferencesUtil.clear();
      await _authRepository.logOut();
      emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
    }on Failure catch(error){
      emit(state.copyWith(authStatus: AuthStatus.error,error: error.message));
    }
  }







  }

