


import 'package:flutter/widgets.dart';

import '../../di/locator.dart';
import '../services/auth_service.dart';

class AuthApiUtil{

  final AuthService _authApi=locator.get<AuthService>();




  Future<void> signInGoogle()async{
  return await _authApi.singInGoogle();

  }

  Future<void> logOut()async{
    await _authApi.logOut();
  }


}