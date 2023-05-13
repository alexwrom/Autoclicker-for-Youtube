


 import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataFromApi{


   final int numberOfTrans;
   final int timeStampAuth;
   final  int timeStampPurchase;

  UserDataFromApi.fromApi({required DocumentSnapshot documentSnapshot,required Map<String,dynamic> configMap}):
        numberOfTrans=documentSnapshot.get('countTranslate'),
        timeStampAuth=configMap['timeStampAuth']??0,
        timeStampPurchase=configMap['timestampPurchase']??0;
 }