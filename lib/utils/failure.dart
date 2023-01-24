


import 'package:dio/dio.dart';

import 'package:firebase_auth/firebase_auth.dart';


class Failure implements Exception{

  final String message;
  const Failure(this.message);


  @override
  String toString() => message;

  factory Failure.fromAuthApiError(FirebaseAuthException exception){
    return Failure(firebaseAuthErrorToMessage(exception));
  }



  factory Failure.fromDioError(DioError exception){
    return Failure(dioError(exception));
  }


  static String dioError(DioError error){
    switch (error.response!.statusCode) {
      case 500:
        return 'Ошибка сервера';

      default:
        return 'Ошибка сервера';
    }
  }



  static String firebaseAuthErrorToMessage(FirebaseAuthException exception){
    switch (exception.code) {
      case 'invalid-email':
        return 'Hеверный адрес электронной почты';
      case 'user-disabled':
        return 'Пользоваьель отключен';
      case 'user-not-found':
        return 'Пользователь не найден';
      case 'wrong-password':
        return 'Неправильный пароль';
      case 'email-already-in-use':
        return 'Этот электронный адрес уже занят';
      case 'account-exists-with-different-credential':
        return 'Учетная запись существует с другими учетными данными';
      case 'invalid-credential':
        return 'Недействительные учетные данные';
      case 'operation-not-allowed':
        return 'Операция запрещена';
      case 'weak-password':
        return 'Пароль менее 6 символов';
      case'network-request-failed':
        return 'Сбой сетевого запроса, проверь соединение';

      case 'ERROR_MISSING_GOOGLE_AUTH_TOKEN':
      default:
        return 'Ошибка сервера';
    }
  }



}