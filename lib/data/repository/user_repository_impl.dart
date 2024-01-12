

  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/domain/models/user_data.dart';

import '../../domain/models/channel_model_cred.dart';
import '../../domain/repository/user_repository.dart';
import '../utils/user_data_api_util.dart';

class UserRepositoryImpl extends UserRepository{
  final _util=locator.get<UserDataApiUtil>();

  @override
  Future<UserData> getDataUser({required String email}) async{
    return await _util.getDataUser(email: email);
  }

  @override
  Future<void> updateBalance({required int balance, required String uid,required int bonusOfRemoteChannel,required ChannelModelCred channel}) async {
    return await _util.updateBalance(balance: balance, uid: uid,bonusOfRemoteChannel:bonusOfRemoteChannel,channel:channel);
  }

  @override
  Future<void> blockAccountUser({required bool unlock}) async {
   await _util.blockAccountUser(unlock: unlock);
  }

  @override
  Future<int> getBalance() async {
  return await _util.getBalance();
  }

  @override
  Future<void> removeChannelFromAccount({required String idChannel}) async {
    await _util.removeChannelFromAccount(idChannel: idChannel);
  }

  @override
  Future<int> addRemoteChannel({required String idChannel}) async {
    return await _util.addRemoteChannel(idChannel: idChannel);
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> listenerRemoteChannels() {
   return _util.listenerRemoteChannels();
  }


  }