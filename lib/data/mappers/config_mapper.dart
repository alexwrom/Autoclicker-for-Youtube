
  import 'package:youtube_clicker/data/models/config_app_model.dart';
import 'package:youtube_clicker/domain/models/config_app_entity.dart';

class ConfigMapper{

    static ConfigAppEntity fromApi({required ConfigAppModel configAppModel}){
      return ConfigAppEntity(
        mobileVersion: configAppModel.mobileVersion,
          requiredUpdate: configAppModel.requiredUpdate,
          clientId: configAppModel.clientId,
          clientSecret: configAppModel.clientSecret,
          credAuthIOS: configAppModel.credAuthIOS);
    }


  }