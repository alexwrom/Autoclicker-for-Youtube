


 import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/failure.dart';
import '../models/user_data_from_api.dart';

class UserApiService{


   FirebaseFirestore? _firebaseFirestore;

   UserApiService(){
     _firebaseFirestore=FirebaseFirestore.instance;
   }



    Future<UserDataFromApi> getDataUser({required String email})async{
   //Map<String,dynamic> jsonConfig={};
   try{
     DocumentSnapshot documentSnapshot=await _firebaseFirestore!.collection('userpc').doc(email.toLowerCase()).get();
     if(!documentSnapshot.exists){
         throw const Failure('User is not found');
     }
     //jsonConfig = await _checkConfigFile(jsonConfig);
     return UserDataFromApi.fromApi(documentSnapshot: documentSnapshot);
   }on FirebaseException catch(error,stackTrace){
     Error.throwWithStackTrace(Failure(error.message!), stackTrace);
   } on Failure catch(error,stackTrace){
     Error.throwWithStackTrace(Failure(error.message), stackTrace);
   }on PlatformException catch(error,stackTrace){
     Error.throwWithStackTrace(Failure(error.message!), stackTrace);
   }

    }

    ///method of check a file configuration for free trial period
    Future<Map<String, dynamic>> _checkConfigFile(Map<String, dynamic> jsonConfig) async {
       String dir = (await getExternalStorageDirectory())!.path;
      final fileConfig = '$dir/config.json';
      final fileExists=await File(fileConfig).exists();
      if(fileExists){
        final jsonString=await File(fileConfig).readAsString();
         jsonConfig=jsonDecode(jsonString);
      }else{
        final ts=DateTime.now().millisecondsSinceEpoch;
        jsonConfig={'timeStampAuth':ts,
          'timestampPurchase':0};
        final jsonString=jsonEncode(jsonConfig);
        final f = await File(fileConfig).create();
        await f.writeAsString(jsonString);
      }
      return jsonConfig;
    }

    Future<void> updateBalance({required int balance,required String uid})async{
      Map<String,dynamic> map={};
      map.addAll({'balance':balance});
      try{
        await _firebaseFirestore!.collection('userpc').doc(uid.toLowerCase()).update(map);

      }on FirebaseException catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } on Failure catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      }on PlatformException catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      }
    }
}