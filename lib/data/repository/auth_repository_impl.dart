


import 'package:flutter/widgets.dart';
import 'package:youtube_clicker/data/models/config_app_model.dart';
import 'package:youtube_clicker/domain/models/config_app_entity.dart';

import '../../di/locator.dart';
import '../../domain/repository/auth_repository.dart';
import '../utils/auth_api_util.dart';

class AuthRepositoryImpl extends AuthRepository{

  final AuthApiUtil _apiUtil=locator.get<AuthApiUtil>();


  @override
  Future<void> logOut({required bool isDelAcc})async {
    await _apiUtil.logOut(isDelAcc:isDelAcc);
  }

  @override
  Future<void> singInGoogle() async{
    return await _apiUtil.signInGoogle();
  }

  Future<void> singIn({required String pass,required String email})async{
    return await _apiUtil.singIn(pass: pass, email: email);

  }


  @override
  Future<bool> logIn({required String pass,required String email}) async{
    return await _apiUtil.logIn(pass: pass, email: email);
  }

  @override
  Future<bool> forgotPass({required String email,required String newPass}) async{
    return await _apiUtil.forgotPass(email: email,newPass: newPass);
  }

  @override
  Future<ConfigAppEntity> getConfigApp() {
   return _apiUtil.getConfigApp();
  }





}