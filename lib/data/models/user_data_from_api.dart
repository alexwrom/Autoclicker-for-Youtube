


 import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataFromApi{

   final bool isActive;
   final int numberOfTrans;
   final int numberOfTransActive;
   final int timeStamp;
   final bool isSubscribe;

  UserDataFromApi.fromApi({required DocumentSnapshot documentSnapshot,required bool isSub}):
        isActive=documentSnapshot.get('isActive'),
        numberOfTrans=documentSnapshot.get('balance'),
        numberOfTransActive=documentSnapshot.get('balanceActive'),
        timeStamp=documentSnapshot.get('timeStamp'),
        isSubscribe=isSub;
 }