


  import 'package:hive/hive.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/utils/preferences_util.dart';

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

    Future<void> updateBalance({required int balance,required String uid})async{
      return await _api.updateBalance(balance: balance, uid: uid);
    }


  }