


 import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataFromApi{


   final int numberOfTrans;
   final int isBlock;
   final int isTakeBonus;


  UserDataFromApi.fromApi({required DocumentSnapshot documentSnapshot}):
        numberOfTrans=documentSnapshot.get('balance'),
         isTakeBonus=documentSnapshot.get('isTakeBonus'),
        isBlock= documentSnapshot.get('isBlock');

 }