


  import '../models/channel_model_cred.dart';
import '../models/user_data.dart';

abstract class UserRepository{
    Future<UserData> getDataUser({required String email});
    Future<void> updateBalance({required int balance,required String uid, required int bonusOfRemoteChannel,required ChannelModelCred channel});
    Future<void> blockAccountUser({required bool unlock});
    Future<void> takeBonusChannel({required String idChannel,required int newBalance});
    Future<void> removeChannelFromAccount({required String idChannel});
    Future<int> addRemoteChannel({required String idChannel});


}