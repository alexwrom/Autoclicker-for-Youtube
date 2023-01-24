import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../presentation/auth_screen/bloc/auth_bloc.dart';

part 'app_event.dart';

part 'app_state.dart';

enum LocalStatus { ru, en }

class AppBloc extends Bloc<AppEvent, AppState> {



  AppBloc() : super(AppState.unknown()) {
    on<AuthInitCheck>(_authInitCheck);
  }

  void _authInitCheck(event, emit) async {
    await Future.delayed(const Duration(milliseconds: 3500));

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(state.copyWith(authStatusCheck: AuthStatusCheck.unauthenticated));
    } else {
      emit(state.copyWith(authStatusCheck: AuthStatusCheck.authenticated));
    }
  }


}
