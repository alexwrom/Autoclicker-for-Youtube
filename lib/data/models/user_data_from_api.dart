


 import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataFromApi{

   final bool isActive;
   final int numberOfTrans;
   final int numberOfTransActive;
   final int timeStampAuth;
   final  int timeStampPurchase;

  UserDataFromApi.fromApi({required DocumentSnapshot documentSnapshot}):
        isActive=documentSnapshot.get('isActive'),
        numberOfTrans=documentSnapshot.get('balance'),
        numberOfTransActive=documentSnapshot.get('balanceActive'),
        timeStampAuth=documentSnapshot.get('timeStampAuth'),
        timeStampPurchase=documentSnapshot.get('timestampPurchase');
 }