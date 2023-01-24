



import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/domain/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

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
    on<SingInEvent>(_singInGoogle);
    on<LogOutEvent>(_logOut);

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
      await _authRepository.logOut();
      await boxVideo.clear();
      emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
    }on Failure catch(error){
      emit(state.copyWith(authStatus: AuthStatus.error,error: error.message));
    }
  }







  }

