



import 'package:googleapis/youtube/v3.dart';

class ChannelModelCredFromApi{
   final String nameChannel;
   final String imgBanner;
   final String accountName;
   final String idUpload;
   final String idChannel;
   final String accessToken;
   final String idToken;



   ChannelModelCredFromApi.fromApi({required Channel channel,required String googleAccount,required String accessTok,required String idTok}):
       nameChannel=channel.snippet!.title!,
       imgBanner=channel.snippet!.thumbnails!.medium!.url!,
       idUpload=channel.contentDetails!.relatedPlaylists!.uploads!,
       idChannel=channel.id!,
       idToken=idTok,
       accessToken=accessTok,
        accountName=googleAccount;




 }