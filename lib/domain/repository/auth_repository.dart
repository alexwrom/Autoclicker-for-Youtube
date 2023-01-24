




import 'package:flutter/widgets.dart';

abstract class AuthRepository{

  Future<void> singInGoogle();
  Future<void> logOut();

}