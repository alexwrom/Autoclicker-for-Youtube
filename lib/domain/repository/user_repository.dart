


  import '../models/user_data.dart';

abstract class UserRepository{
    Future<UserData> getDataUser({required String uid});
    Future<void> updateBalance({required int balance,required String uid,required bool isActive});


  }