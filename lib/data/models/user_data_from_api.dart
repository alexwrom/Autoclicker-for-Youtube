


 import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataFromApi{


   final int numberOfTrans;
   final int isBlock;
   final int isTakeBonus;
   final List<dynamic> channels;


  UserDataFromApi.fromApi({required DocumentSnapshot documentSnapshot}):
        numberOfTrans=documentSnapshot.get('balance'),
         isTakeBonus=documentSnapshot.get('isTakeBonus'),
        isBlock= documentSnapshot.get('isBlock'),
        channels = documentSnapshot.data().toString().contains('channels')?
        documentSnapshot.get('channels'):[];

 }