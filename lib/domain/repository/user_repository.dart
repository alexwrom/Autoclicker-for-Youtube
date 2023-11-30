


  import '../models/user_data.dart';

abstract class UserRepository{
    Future<UserData> getDataUser({required String email});
    Future<void> updateBalance({required int balance,required String uid});
    Future<void> blockAccountUser({required bool unlock});


  }