
import 'dart:io';



import 'package:youtube_clicker/utils/preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../di/locator.dart';
import '../../utils/failure.dart';
import '../models/config_app_model.dart';



class AuthService{

   FirebaseAuth? _auth;
   FirebaseFirestore? _firebaseFirestore;
   final _googleSingIn=locator.get<GoogleSignIn>();
  final  _deviceInfoPlugin = locator.get<DeviceInfoPlugin>();


    AuthService(){
      _auth=FirebaseAuth.instance;
      _firebaseFirestore=FirebaseFirestore.instance;
    }

   Future<ConfigAppModel> getConfigApp() async {
     final document = await FirebaseFirestore.instance
         .collection('settings')
         .doc('setting')
         .get();
     return ConfigAppModel.fromApi(document);
   }



  Future<void> logOut({required bool isDelAcc})async{
    try{
      if(isDelAcc){
        final email= PreferencesUtil.getEmail;
        await _firebaseFirestore!.collection('userpc').doc(email.toLowerCase()).delete();
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
        imei=data.id;
      }
      await PreferencesUtil.setUrlAvatar(userCredential.user!.photoURL!);
      await PreferencesUtil.setUserName(userCredential.user!.displayName!);
      await PreferencesUtil.setUserId(imei);
      await PreferencesUtil.setEmail(userCredential.user!.email!);
      final ts=DateTime.now().millisecondsSinceEpoch;
      await _firebaseFirestore!.collection('userpc').doc(imei).set({
        'balance':0,
        'timeStampAuth':ts,
        'timestampPurchase':0
      });


    } on FirebaseAuthException catch(error,stackTrace){

      Error.throwWithStackTrace(Failure.fromAuthApiError(error), stackTrace);

    } on Failure catch(error,stackTrace){

      Error.throwWithStackTrace(Failure(error.message), stackTrace);
    }on PlatformException catch(error,stackTrace){

      Error.throwWithStackTrace(Failure(error.message!), stackTrace);
    }



  }

   Future<bool> forgotPass({required String email,required String newPass}) async{
     try{
       if(email.isEmpty){
         throw  const Failure('Enter email');
       }else if(newPass.isEmpty){
         throw   const Failure('Enter a new password');
       }
       if(newPass.contains('abc')){
         await _auth!.signInAnonymously();
         DocumentSnapshot userDoc=await _firebaseFirestore!.collection('userpc').doc(email.toLowerCase()).get();
         if(!userDoc.exists){
           throw const Failure('User is not found');
         }
       }else{
         await _firebaseFirestore!.collection('userpc').doc(email.toLowerCase()).update({
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

       //await _auth!.signInAnonymously();
       await _auth!.signInWithEmailAndPassword(email: email, password: pass);
       DocumentSnapshot userDoc=await _firebaseFirestore!.collection('userpc').doc(email.toLowerCase()).get();
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
       DocumentSnapshot userDoc=await _firebaseFirestore!.collection('userpc').doc(email.toLowerCase()).get();
       if(userDoc.exists){
         throw const Failure('This user already exists');
       }else{
         await PreferencesUtil.setUserName(email);
         await _firebaseFirestore!.collection('userpc').doc(email.toLowerCase()).set({
           'balance':0,
           'password':pass,
           'isBlock' : 0,
           'isTakeBonus' : 0,
         });

       }

     } on FirebaseAuthException catch(error,stackTrace){

       Error.throwWithStackTrace(Failure.fromAuthApiError(error), stackTrace);

     } on Failure catch(error,stackTrace){

       Error.throwWithStackTrace(Failure(error.message), stackTrace);
     }on PlatformException catch(error,stackTrace){

       Error.throwWithStackTrace(Failure(error.message!), stackTrace);
     } catch (error, stackTrace){
       Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
     }




   }



}










