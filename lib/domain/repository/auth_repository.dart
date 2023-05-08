




import 'package:flutter/widgets.dart';

abstract class AuthRepository{

  Future<void> singInGoogle();
  Future<void> logOut();
  Future<bool> logIn({required String pass,required String email});
  Future<void> singIn({required String pass,required String repPass,required String email});
  Future<bool> forgotPass({required String email,required String newPass});

}