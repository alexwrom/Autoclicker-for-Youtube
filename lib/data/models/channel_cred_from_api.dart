



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
   final int bonus;
   final bool remoteChannel;
   final TypePlatformRefreshToken typePlatformRefreshToken;


   ChannelModelCredFromApi(
      this.nameChannel,
      this.imgBanner,
      this.accountName,
      this.idUpload,
      this.idChannel,
      this.accessToken,
      this.idToken,
      this.defaultLanguage,
      this.refreshToken,
      this.idInvitation,
      this.bonus,
       this.remoteChannel,
      this.typePlatformRefreshToken);

  ChannelModelCredFromApi copyWith({int? bonus}){
      return ChannelModelCredFromApi(
          nameChannel,
          imgBanner,
          accountName,
          idUpload,
          idChannel,
          accessToken,
          idToken,
          defaultLanguage,
          refreshToken,
          idInvitation,
          bonus??this.bonus,
          remoteChannel,
          typePlatformRefreshToken

      );
   }


   ChannelModelCredFromApi.fromApi(
      {required Channel channel,
      required String googleAccount,
      required String accessTok,
      required String idTok,
      required String refToken,
      required String iDInvitation,
         required this.bonus,
         required this.remoteChannel,
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