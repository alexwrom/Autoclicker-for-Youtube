


 import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataFromApi{


   final int numberOfTrans;
   final int timeStampAuth;
   final  int timeStampPurchase;

  UserDataFromApi.fromApi({required DocumentSnapshot documentSnapshot}):
        numberOfTrans=documentSnapshot.get('balance'),
        timeStampAuth=documentSnapshot.get('timeStampAuth'),
        timeStampPurchase=documentSnapshot.get('timestampPurchase');
 }