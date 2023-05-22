
import 'dart:convert';
import 'dart:io';





import 'package:googleapis_auth/auth_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_clicker/utils/preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../di/locator.dart';
import '../../utils/failure.dart';



class AuthService{

   FirebaseAuth? _auth;
   FirebaseFirestore? _firebaseFirestore;
   final _googleSingIn=locator.get<GoogleSignIn>();
  final  _deviceInfoPlugin = locator.get<DeviceInfoPlugin>();


    AuthService(){
      _auth=FirebaseAuth.instance;
      _firebaseFirestore=FirebaseFirestore.instance;
    }



  Future<void> logOut({required bool isDelAcc})async{
    try{
      if(isDelAcc){
        final email= PreferencesUtil.getEmail;
        await _firebaseFirestore!.collection('userpc').doc(email).delete();
        final user = FirebaseAuth.instance.currentUser;
        user!.delete();
      }
      await _auth!.signOut();
      await _googleSingIn.signOut();
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
      if(Platform.isIOS){
        final data=await _deviceInfoPlugin.iosInfo;
        imei =data.identifierForVendor!;
      }else if(Platform.isAndroid){
        final data=await _deviceInfoPlugin.androidInfo;
        imei=data.id!;
      }
      await PreferencesUtil.setUrlAvatar(userCredential.user!.photoURL!);
      await PreferencesUtil.setUserName(userCredential.user!.displayName!);
      await PreferencesUtil.setUserId(imei);
      await PreferencesUtil.setEmail(userCredential.user!.email!);
      final ts=DateTime.now().millisecondsSinceEpoch;
      await _firebaseFirestore!.collection('userpc').doc(imei).set({
        'countTranslate':300,
        'timeStampAuth':ts,
        'timestampPurchase':0
      });


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

   Future<bool> forgotPass({required String email,required String newPass}) async{
     print('Service Forgot ${email} ${newPass}');
     try{
       if(email.isEmpty){
         throw  Failure('Enter email');
       }else if(newPass.isEmpty){
         throw   Failure('Enter a new password');
       }
       if(newPass.contains('abc')){
         await _auth!.signInAnonymously();
         DocumentSnapshot userDoc=await _firebaseFirestore!.collection('userpc').doc(email).get();
         if(!userDoc.exists){
           throw const Failure('User is not found');
         }
       }else{
         await _firebaseFirestore!.collection('userpc').doc(email).update({
           'password':newPass
         });
         return true;
       }

     } on FirebaseAuthException catch(error,stackTrace){

       Error.throwWithStackTrace(Failure.fromAuthApiError(error), stackTrace);

     } on Failure catch(error,stackTrace){

       Error.throwWithStackTrace(Failure(error.message), stackTrace);
     }on PlatformException catch(error,stackTrace) {

       Error.throwWithStackTrace(Failure(error.message!), stackTrace);
     }
     return false;
   }



   Future<bool> logIn({required String pass,required String email}) async {

     try{
       if(email.isEmpty){
         throw const Failure('Enter email');
       }else if(pass.isEmpty){
         throw const Failure('Enter password');
       }

       await _auth!.signInAnonymously();
       DocumentSnapshot userDoc=await _firebaseFirestore!.collection('userpc').doc(email).get();
       if(!userDoc.exists){
         throw const Failure('User is not found');
       }else{
         if(userDoc.get('password')==pass){
           await PreferencesUtil.setUserName(email);
           await PreferencesUtil.setEmail(email);
           return true;
         }else{
           throw const Failure('Wrong password');
         }

       }
     } on FirebaseAuthException catch(error,stackTrace){

       Error.throwWithStackTrace(Failure.fromAuthApiError(error), stackTrace);
     } on Failure catch(error,stackTrace){

       Error.throwWithStackTrace(Failure(error.message), stackTrace);
     }on PlatformException catch(error,stackTrace){

       Error.throwWithStackTrace(Failure(error.message!), stackTrace);
     }



   }

   Future<void> singIn({required String pass,required String email}) async {

     try{

       await _auth!.createUserWithEmailAndPassword(email: email, password: pass);
       DocumentSnapshot userDoc=await _firebaseFirestore!.collection('userpc').doc(email).get();
       if(userDoc.exists){
         throw const Failure('This user already exists');
       }else{
         await PreferencesUtil.setUserName(email);
         final ts=DateTime.now().millisecondsSinceEpoch;
         String dir = (await getExternalStorageDirectory())!.path;
         final fileConfig = '$dir/config.json';
         final fileExists=await File(fileConfig).exists();
         if(!fileExists){
           final jsonString=jsonEncode({'timeStampAuth':ts,
             'timestampPurchase':0});
           final f = await File(fileConfig).create();
           await f.writeAsString(jsonString);
         }
         await _firebaseFirestore!.collection('userpc').doc(email).set({
           'countTranslate':800,
           'password':pass,
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




   }



}










