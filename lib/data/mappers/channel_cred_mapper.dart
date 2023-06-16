


 import 'package:youtube_clicker/domain/models/channel_model_cred.dart';

import '../models/channel_cred_from_api.dart';

class ChannelCredMapper{


  static ChannelModelCred fromApi(
      {required ChannelModelCredFromApi channelModelCredFromApi}) {
    return ChannelModelCred(
        nameChannel: channelModelCredFromApi.nameChannel,
        imgBanner: channelModelCredFromApi.imgBanner,
        accountName: channelModelCredFromApi.accountName,
        idUpload: channelModelCredFromApi.idUpload,
        idChannel: channelModelCredFromApi.idChannel,
        idToken: channelModelCredFromApi.idToken,
        accessToken: channelModelCredFromApi.accessToken,
        defaultLanguage: channelModelCredFromApi.defaultLanguage,
        refreshToken: channelModelCredFromApi.refreshToken,
        keyLangCode: 0,
    typePlatformRefreshToken: channelModelCredFromApi.typePlatformRefreshToken,
    idInvitation: channelModelCredFromApi.idInvitation);
  }
}