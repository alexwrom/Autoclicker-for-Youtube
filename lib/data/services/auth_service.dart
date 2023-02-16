
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
import 'package:youtube_clicker/utils/preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../di/locator.dart';
import '../../utils/failure.dart';
import '../http_client/dio_auth_client.dart';
import 'package:http/http.dart' as http;


class AuthService{

   FirebaseAuth? _auth;
   FirebaseFirestore? _firebaseFirestore;
   final  _dio=locator.get<DioAuthClient>();
   final _googleSingIn=locator.get<GoogleSignIn>();
  final  _deviceInfoPlugin = locator.get<DeviceInfoPlugin>();


    AuthService(){
      _auth=FirebaseAuth.instance;
      _firebaseFirestore=FirebaseFirestore.instance;
    }



  Future<void> logOut()async{
    try{
      await _auth!.signOut();
      await _googleSingIn.signOut();
      print('SING OUT');
    } on  FirebaseAuthException catch(error,stackTrace){
      Error.throwWithStackTrace(Failure.fromAuthApiError(error), stackTrace);

    }


  }



  Future<void> singInGoogle() async {

      try{
      String imei='';
      final googleSignInAccount= await _googleSingIn.signIn();

      if(_googleSingIn.currentUser==null){
        throw const Failure('Error auth');
      }
      final authHeaders =await googleSignInAccount!.authHeaders;
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      await PreferencesUtil.setHeadersGoogleApi(authHeaders);
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
      await _auth!.signInWithCredential(credential);

       await PreferencesUtil.setUrlAvatar(userCredential.user!.photoURL!);
       await PreferencesUtil.setUserNAmer(userCredential.user!.displayName!);
       await PreferencesUtil.setUserId(userCredential.user!.uid);
       await PreferencesUtil.setEmail(userCredential.user!.email!);

      if(Platform.isIOS){
        final iosImei=await _deviceInfoPlugin.iosInfo;
         imei=iosImei.identifierForVendor!;
      }else if(Platform.isAndroid){
        final androidImei=await _deviceInfoPlugin.androidInfo;
        imei=androidImei.androidId!;
      }
      DocumentSnapshot userDoc=await _firebaseFirestore!.collection('users').doc(userCredential.user!.uid).get();
      if(userDoc.exists){
        await _firebaseFirestore!.collection('users').doc(userCredential.user!.uid).update({
          'imei':imei
        });
      }else{
        final ts=DateTime.now().millisecondsSinceEpoch;
        await _firebaseFirestore!.collection('users').doc(userCredential.user!.uid).set({
          'imei':imei,
          'isActive':false,
          'description':userCredential.user!.displayName!.isNotEmpty?userCredential.user!.displayName!:'',
          'balance':6,
          'balanceActive':1000,
          'timeStampAuth':ts,
          'timestampPurchase':0
        });
      }

    } on FirebaseAuthException catch(error,stackTrace){
        print('Error Auth ${error.message}');
      Error.throwWithStackTrace(Failure.fromAuthApiError(error), stackTrace);

    } on Failure catch(error,stackTrace){
        print('Error 2 Auth ${error.message}');
      Error.throwWithStackTrace(Failure(error.message), stackTrace);
    }on PlatformException catch(error,stackTrace){
        print('Error 3 Auth ${error.message}');
      Error.throwWithStackTrace(Failure(error.message!), stackTrace);
    }

     //todo сделать авторизацию через apple


  }


}










