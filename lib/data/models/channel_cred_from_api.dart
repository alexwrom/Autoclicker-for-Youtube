



import 'package:googleapis/youtube/v3.dart';

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



   ChannelModelCredFromApi.fromApi(
       {required Channel channel,
          required String googleAccount,
          required String accessTok,
          required String idTok,
       required String refToken}):
       nameChannel=channel.snippet!.title!,
       imgBanner=channel.snippet!.thumbnails!.medium!.url!,
       idUpload=channel.contentDetails!.relatedPlaylists!.uploads!,
        defaultLanguage=channel.snippet!.defaultLanguage??'',
       idChannel=channel.id!,
       idToken=idTok,
       accessToken=accessTok,
       refreshToken=refToken,
        accountName=googleAccount;




 }