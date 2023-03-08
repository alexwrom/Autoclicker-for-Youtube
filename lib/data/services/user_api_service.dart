


 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../../utils/failure.dart';
import '../models/user_data_from_api.dart';

class UserApiService{


   FirebaseFirestore? _firebaseFirestore;

   UserApiService(){
     _firebaseFirestore=FirebaseFirestore.instance;
   }



    Future<UserDataFromApi> getDataUser({required String uid})async{

   try{
     DocumentSnapshot documentSnapshot=await _firebaseFirestore!.collection('users').doc(uid).get();
     if(!documentSnapshot.exists){
         throw const Failure('User is not found');
     }
     return UserDataFromApi.fromApi(documentSnapshot: documentSnapshot);
   }on FirebaseException catch(error,stackTrace){
     Error.throwWithStackTrace(Failure(error.message!), stackTrace);
   } on Failure catch(error,stackTrace){
     Error.throwWithStackTrace(Failure(error.message), stackTrace);
   }on PlatformException catch(error,stackTrace){
     Error.throwWithStackTrace(Failure(error.message!), stackTrace);
   }

    }

    Future<void> updateBalance({required int balance,required String uid,required bool isActive})async{
      Map<String,dynamic> map={};
      if(!isActive){
        map.addAll({'balance':balance});
      }else{
        map.addAll({'balanceActive':balance});
      }
      try{
        await _firebaseFirestore!.collection('users').doc(uid).update(map);

      }on FirebaseException catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } on Failure catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      }on PlatformException catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      }
    }
}