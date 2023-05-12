


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
        return 'Server error';

      default:
        return 'Server error';
    }
  }



  static String firebaseAuthErrorToMessage(FirebaseAuthException exception){
    switch (exception.code) {
      case 'invalid-email':
        return 'Incorrect e-mail address';
      case 'user-disabled':
        return 'User is disabled';
      case 'user-not-found':
        return 'User is not found';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'This e-mail is already taken';
      case 'account-exists-with-different-credential':
        return 'Account exists with different credentials';
      case 'invalid-credential':
        return 'Invalid credentials';
      case 'operation-not-allowed':
        return 'Operation prohibited';
      case 'weak-password':
        return 'Password less than 6 characters';
      case'network-request-failed':
        return 'Network failure';

      case 'ERROR_MISSING_GOOGLE_AUTH_TOKEN':
      default:
        return 'Server error';
    }
  }



}