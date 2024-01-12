


  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/utils/preferences_util.dart';

import '../../domain/models/channel_model_cred.dart';
import '../../domain/models/user_data.dart';
import '../mappers/user_data_mapper.dart';
import '../models/hive_models/channel_lang_code.dart';
import '../services/user_api_service.dart';

class UserDataApiUtil{

    final _api=locator.get<UserApiService>();



    Future<UserData> getDataUser({required String email})async{
      final data=await _api.getDataUser(email: email);
      return UserDataMapper.fromApi(userDataFromApi: data);
    }

    Future<void> updateBalance({required int balance,required String uid,required int bonusOfRemoteChannel,required ChannelModelCred channel})async{
      return await _api.updateBalance(balance: balance, uid: uid,bonusOfRemoteChannel: bonusOfRemoteChannel,channel:channel);
    }

    Future<void> blockAccountUser({required bool unlock}) async {
      await _api.blockAccountUser(unlock: unlock);
    }

    Future<int> getBalance() async {
      return await _api.getBalance();
    }

    Future<void> removeChannelFromAccount({required String idChannel}) async {
      await _api.removeChannelFromAccount(idChannel: idChannel);
    }

    Future<int> addRemoteChannel({required String idChannel}) async {
     return await _api.addRemoteChannel(idChannel: idChannel);
    }

    Stream<DocumentSnapshot<Map<String, dynamic>>> listenerRemoteChannels(){
      return _api.listenerRemoteChannels();
    }


}