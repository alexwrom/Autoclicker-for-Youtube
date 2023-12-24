

  import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/domain/models/user_data.dart';

import '../../domain/repository/user_repository.dart';
import '../utils/user_data_api_util.dart';

class UserRepositoryImpl extends UserRepository{
  final _util=locator.get<UserDataApiUtil>();

  @override
  Future<UserData> getDataUser({required String email}) async{
    return await _util.getDataUser(email: email);
  }

  @override
  Future<void> updateBalance({required int balance, required String uid}) async {
    return await _util.updateBalance(balance: balance, uid: uid);
  }

  @override
  Future<void> blockAccountUser({required bool unlock}) async {
   await _util.blockAccountUser(unlock: unlock);
  }

  @override
  Future<void> takeBonusChannel({required String idChannel,required int newBalance}) async {
   await _util.takeBonusChannel(idChannel: idChannel,newBalance: newBalance);
  }

  @override
  Future<void> removeChannelFromAccount({required String idChannel}) async {
    await _util.removeChannelFromAccount(idChannel: idChannel);
  }

  @override
  Future<bool> addRemoteChannel({required String idChannel}) async {
    return await _util.addRemoteChannel(idChannel: idChannel);
  }


  }