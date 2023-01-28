
import 'dart:io';

import 'package:youtube_clicker/utils/preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../di/locator.dart';
import '../../utils/failure.dart';
import '../http_client/dio_auth_client.dart';


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
      PreferencesUtil.clear();
      await _auth!.signOut();
      await _googleSingIn.signOut();
    } on  FirebaseAuthException catch(error,stackTrace){
      Error.throwWithStackTrace(Failure.fromAuthApiError(error), stackTrace);

    }


  }



  Future<void> singInGoogle() async {

    // final client = http.Client();
    // try {
    //  final result=  await obtainAccessCredentialsViaUserConsent(
    //      ClientId('975260836202-auh4p2otnnbf3eta2il2tms67fpdgqct.apps.googleusercontent.com'),
    //     ['https://www.googleapis.com/auth/youtube.force-ssl'],
    //     client,
    //      (url){
    //        print('URL CAllback $url');
    //      },
    //   ).then((value){
    //
    //  });
    //
    //
    // } finally {
    //   client.close();
    // }
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
      if(Platform.isIOS){
        final iosImei=await _deviceInfoPlugin.iosInfo;
         imei=iosImei.identifierForVendor!;
      }else if(Platform.isAndroid){
        final androidImei=await _deviceInfoPlugin.androidInfo;
        imei=androidImei.androidId!;
      }
      await _firebaseFirestore!.collection('users').doc(userCredential.user!.uid).set({
        'imei':imei,
        'isActive':false,
        'description':''
      });
    } on FirebaseAuthException catch(error,stackTrace){
      Error.throwWithStackTrace(Failure.fromAuthApiError(error), stackTrace);

    } on Failure catch(error,stackTrace){
      Error.throwWithStackTrace(Failure(error.message), stackTrace);
    }on PlatformException catch(error,stackTrace){
      Error.throwWithStackTrace(Failure(error.message!), stackTrace);
    }

     //todo сделать авторизацию через apple


  }


}










