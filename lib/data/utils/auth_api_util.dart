


import 'package:flutter/widgets.dart';

import '../../di/locator.dart';
import '../services/auth_service.dart';

class AuthApiUtil{

  final AuthService _authApi=locator.get<AuthService>();




  Future<void> signInGoogle()async{
  return await _authApi.singInGoogle();

  }

  Future<void> logOut({required bool isDelAcc})async{
    await _authApi.logOut(isDelAcc:isDelAcc);
  }

  Future<bool> logIn({required String pass,required String email})async{
    return await _authApi.logIn(pass: pass, email: email);

  }

  Future<void> singIn({required String pass,required String repPass,required String email})async{
    return await _authApi.singIn(pass: pass, email: email,repPass: repPass);

  }
  Future<bool> forgotPass({required String email,required String newPass})async{
    return await _authApi.forgotPass(email: email,newPass: newPass);

  }


}