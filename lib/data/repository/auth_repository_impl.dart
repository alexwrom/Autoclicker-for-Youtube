


import 'package:flutter/widgets.dart';

import '../../di/locator.dart';
import '../../domain/repository/auth_repository.dart';
import '../utils/auth_api_util.dart';

class AuthRepositoryImpl extends AuthRepository{

  final AuthApiUtil _apiUtil=locator.get<AuthApiUtil>();


  @override
  Future<void> logOut()async {
    await _apiUtil.logOut();
  }

  @override
  Future<void> singInGoogle() async{
    return await _apiUtil.signInGoogle();
  }




}