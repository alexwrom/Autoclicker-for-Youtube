



import 'package:googleapis/youtube/v3.dart';

enum TypePlatformRefreshToken{
   android,
   ios,
   desktop

}

class ChannelModelCredFromApi{
   final String nameChannel;
   final String imgBanner;
   final String accountName;
   final String idUpload;
   final String idChannel;
   final String accessToken;
   final String idToken;
   final String defaultLanguage;
   final String refreshToken;
   final String idInvitation;
   final TypePlatformRefreshToken typePlatformRefreshToken;


   ChannelModelCredFromApi.fromApi(
      {required Channel channel,
      required String googleAccount,
      required String accessTok,
      required String idTok,
      required String refToken,
      required String iDInvitation,
      required TypePlatformRefreshToken typePlatformRefreshTok})
      : nameChannel = channel.snippet!.title!,
        imgBanner = channel.snippet!.thumbnails!.medium!.url!,
        idUpload = channel.contentDetails!.relatedPlaylists!.uploads!,
        defaultLanguage = channel.snippet!.defaultLanguage ?? '',
        idChannel = channel.id!,
        idToken = idTok,
        accessToken = accessTok,
        refreshToken = refToken,
        idInvitation = iDInvitation,
        typePlatformRefreshToken=typePlatformRefreshTok,
        accountName = googleAccount;
}