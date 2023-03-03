


  import 'package:hive/hive.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/utils/preferences_util.dart';

import '../../domain/models/user_data.dart';
import '../mappers/user_data_mapper.dart';
import '../models/hive_models/video.dart';
import '../services/user_api_service.dart';

class UserDataApiUtil{

    final _api=locator.get<UserApiService>();
    final boxVideo=Hive.box('video_box');


    Future<UserData> getDataUser({required String uid})async{
      final data=await _api.getDataUser(uid: uid);
      if(boxVideo.isEmpty){
       final key= await boxVideo.add(Video(id: '', codeLanguage: []));
        await PreferencesUtil.setKeyHave(key);
      }
      return UserDataMapper.fromApi(userDataFromApi: data);
    }

    Future<void> updateBalance({required int balance,required String uid,required bool isActive})async{
      return await _api.updateBalance(balance: balance, uid: uid, isActive: isActive);
    }


  }