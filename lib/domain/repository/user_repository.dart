


  import '../models/user_data.dart';

abstract class UserRepository{
    Future<UserData> getDataUser({required String email});
    Future<void> updateBalance({required int balance,required String uid});
    Future<void> blockAccountUser({required bool unlock});
    Future<void> takeBonusChannel({required String idChannel,required int newBalance});
    Future<void> removeChannelFromAccount({required String idChannel});
    Future<bool> addRemoteChannel({required String idChannel});


}