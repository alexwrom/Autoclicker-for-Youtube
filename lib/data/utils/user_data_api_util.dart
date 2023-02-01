


  import 'package:youtube_clicker/di/locator.dart';

import '../../domain/models/user_data.dart';
import '../mappers/user_data_mapper.dart';
import '../services/user_api_service.dart';

class UserDataApiUtil{

    final _api=locator.get<UserApiService>();


    Future<UserData> getDataUser({required String uid})async{
      final data=await _api.getDataUser(uid: uid);
      return UserDataMapper.fromApi(userDataFromApi: data);
    }

    Future<void> updateBalance({required int balance,required String uid,required bool isActive})async{
      return await _api.updateBalance(balance: balance, uid: uid, isActive: isActive);
    }


  }