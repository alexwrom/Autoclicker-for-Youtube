


 import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_clicker/utils/preferences_util.dart';

import '../../domain/models/channel_model_cred.dart';
import '../../utils/failure.dart';
import '../models/user_data_from_api.dart';

class UserApiService{


   FirebaseFirestore? _firebaseFirestore;

   UserApiService(){
     _firebaseFirestore=FirebaseFirestore.instance;
   }


   Future<int> addRemoteChannel({required String idChannel}) async {
     try{

       final email = PreferencesUtil.getEmail;
       final user = _firebaseFirestore!.collection('userpc').doc(email);
       final channel = _firebaseFirestore!.collection('channels').doc(idChannel);
       final update = <String,dynamic>{
         'channels': FieldValue.arrayUnion([idChannel])
       };
       await user.update(update);
       final data = await channel.get();
       final result = data.get('balance') as int;
       return result;
     }on FirebaseException catch(error,stackTrace){
       Error.throwWithStackTrace(Failure(error.message!), stackTrace);
     } on Failure catch(error,stackTrace){
       Error.throwWithStackTrace(Failure(error.message), stackTrace);
     }on PlatformException catch(error,stackTrace){
       Error.throwWithStackTrace(Failure(error.message!), stackTrace);
     }
   }







   Future<void> blockAccountUser({required bool unlock}) async {
     try{
       final email = PreferencesUtil.getEmail;
       int lockIndicator = 1;
       if(unlock){
         lockIndicator = 0;
       }
     await _firebaseFirestore!.collection('userpc').doc(email).update({
       'isBlock': lockIndicator
     });
     }on FirebaseException catch(error,stackTrace){
       Error.throwWithStackTrace(Failure(error.message!), stackTrace);
     } on Failure catch(error,stackTrace){
       Error.throwWithStackTrace(Failure(error.message), stackTrace);
     }on PlatformException catch(error,stackTrace){
       Error.throwWithStackTrace(Failure(error.message!), stackTrace);
     }
   }



    Future<UserDataFromApi> getDataUser({required String email})async{
     try{
       print('UID ${email}');
     DocumentSnapshot documentSnapshot = await _firebaseFirestore!
          .collection('userpc')
          .doc(email.toLowerCase())
          .get();
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

    Future<void> updateBalance({required int balance,required String uid,required int bonusOfRemoteChannel,
      required ChannelModelCred channel})async{
      Map<String,dynamic> map={};
      map.addAll({'balance':balance});
      try{
        await _firebaseFirestore!.collection('userpc').doc(uid.toLowerCase()).update(map);
        final docBonus = await _firebaseFirestore!.collection('channels').doc(channel.idChannel).get();
        if(docBonus.exists&&channel.idInvitation.isEmpty){
          await _firebaseFirestore!.collection('channels').doc(channel.idChannel).update({
            'balance':bonusOfRemoteChannel
          });
        }


      }on FirebaseException catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } on Failure catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      }on PlatformException catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      }
    }

    Future<void> takeBonusChannel({required String idChannel,required int newBalance}) async {
      try{
        final uid = PreferencesUtil.getEmail;
        await _firebaseFirestore!.collection('channels').doc(idChannel).update({
          'balance':newBalance
        });
        // await _firebaseFirestore!.collection('userpc').doc(uid.toLowerCase()).update({
        //   'balance':newBalance
        // });

      }on FirebaseException catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } on Failure catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      }on PlatformException catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      }
    }


    Future<void> removeChannelFromAccount({required String idChannel}) async {
      try{
        final uid = PreferencesUtil.getEmail;
      final doc =  _firebaseFirestore!.collection('userpc').doc(uid.toLowerCase());
      final update = <String, dynamic>{'channels':FieldValue.arrayRemove([idChannel])};
      await doc.update(update);
      }on FirebaseException catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } on Failure catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      }on PlatformException catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      }
    }
}