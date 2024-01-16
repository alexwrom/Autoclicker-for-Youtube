


  import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/channel_model_cred.dart';
import '../models/user_data.dart';

abstract class UserRepository{
    Future<UserData> getDataUser({required String email});
    Future<void> updateBalance({required int balance,required String uid, required int bonusOfRemoteChannel,required ChannelModelCred channel});
    Future<void> blockAccountUser({required bool unlock});
    Future<int> getBalance();
    Future<void> removeChannelFromAccount({required String idChannel});
    Future<int> addRemoteChannel({required String idChannel});
    Stream<DocumentSnapshot<Map<String, dynamic>>> listenerRemoteChannels();
    Stream<QuerySnapshot<Map<String, dynamic>>> listenerChannelsCatalog();
    Future<bool> checkShareChannel({required String idChannel});


}