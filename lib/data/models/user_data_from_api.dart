


 import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataFromApi{

   final bool isActive;
   final int numberOfTrans;
   final int timeStamp;

  UserDataFromApi.fromApi({required DocumentSnapshot documentSnapshot}):
        isActive=documentSnapshot.get('isActive'),
        numberOfTrans=documentSnapshot.get('balance'),
        timeStamp=documentSnapshot.get('timeStamp');
 }