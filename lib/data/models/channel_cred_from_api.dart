


import 'package:googleapis/youtube/v3.dart';

class ChannelModelCredFromApi{
   final String nameChannel;
   final String imgBanner;
   final String accountName;
   final String idUpload;


   ChannelModelCredFromApi.fromApi({required Channel channel,required String googleAccount}):
       nameChannel=channel.snippet!.title!,
       imgBanner=channel.snippet!.thumbnails!.medium!.url!,
       idUpload=channel.contentDetails!.relatedPlaylists!.uploads!,
        accountName=googleAccount;




 }