


  import '../models/user_data.dart';

abstract class UserRepository{
    Future<UserData> getDataUser({required String uid});


  }