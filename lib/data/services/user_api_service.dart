


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

   Future<bool> checkShareChannel({required String idChannel}) async {
     try{
       final email = PreferencesUtil.getEmail;
       final user = await _firebaseFirestore!.collection('userpc').doc(email).get();
       final result = user.get('channels') as List<dynamic>;
       if(result.contains(idChannel)){
         return true;
       }
       return false;
     }on FirebaseException catch(error,stackTrace){
     Error.throwWithStackTrace(Failure(error.message!), stackTrace);
     } on Failure catch(error,stackTrace){
     Error.throwWithStackTrace(Failure(error.message), stackTrace);
     }on PlatformException catch(error,stackTrace){
     Error.throwWithStackTrace(Failure(error.message!), stackTrace);
     }
   }


   Future<int> addRemoteChannel({required String idChannel}) async {
     try{

       final email = PreferencesUtil.getEmail;
       final user = _firebaseFirestore!.collection('userpc').doc(email);
       final channel = _firebaseFirestore!.collection('channels').doc(idChannel);
       final update = <String,dynamic>{
         'channels': FieldValue.arrayUnion([idChannel])
       };
       final data = await channel.get();
       if(data.exists){
         await user.update(update);
         final result = data.get('balance') as int;
         return result;
       }

       return -1;


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

    Future<int> getBalance() async {
      try{
        final uid = PreferencesUtil.getEmail;
        final doc = await _firebaseFirestore!.collection('userpc').doc(uid.toLowerCase()).get();
        return doc.get('balance');

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

   Stream<DocumentSnapshot<Map<String, dynamic>>> listenerRemoteChannels()  {

     try{
       final uid = PreferencesUtil.getEmail;
       return  _firebaseFirestore!.collection('userpc').doc(uid.toLowerCase()).snapshots();
     } on Failure catch (error, stackTrace) {
       Error.throwWithStackTrace(Failure(error.message), stackTrace);
     } on PlatformException catch (error, stackTrace) {
       Error.throwWithStackTrace(Failure(error.message!), stackTrace);
     }on FirebaseException catch (error,stackTrace){
       Error.throwWithStackTrace(Failure(error.message!), stackTrace);
     } catch (error,stackTrace) {
       Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
     }

   }

   Stream<QuerySnapshot<Map<String, dynamic>>> listenerChannelsCatalog()  {

     try{
       return  _firebaseFirestore!.collection('channels').snapshots();
     } on Failure catch (error, stackTrace) {
       Error.throwWithStackTrace(Failure(error.message), stackTrace);
     } on PlatformException catch (error, stackTrace) {
       Error.throwWithStackTrace(Failure(error.message!), stackTrace);
     }on FirebaseException catch (error,stackTrace){
       Error.throwWithStackTrace(Failure(error.message!), stackTrace);
     } catch (error,stackTrace) {
       Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
     }

   }


}