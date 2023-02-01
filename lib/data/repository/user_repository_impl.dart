

  import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/domain/models/user_data.dart';

import '../../domain/repository/user_repository.dart';
import '../utils/user_data_api_util.dart';

class UserRepositoryImpl extends UserRepository{
  final _util=locator.get<UserDataApiUtil>();

  @override
  Future<UserData> getDataUser({required String uid}) async{
    return await _util.getDataUser(uid: uid);
  }

  @override
  Future<void> updateBalance({required int balance, required String uid, required bool isActive}) async {
    return await _util.updateBalance(balance: balance, uid: uid, isActive: isActive);
  }


  }