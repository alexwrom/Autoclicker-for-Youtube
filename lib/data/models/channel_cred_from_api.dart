


import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/youtube/v3.dart';

class ChannelModelCredFromApi{
   final String nameChannel;
   final String imgBanner;
   final String accountName;
   final String idUpload;
   final String idChannel;
   final String accessToken;
   final String idToken;
   final GoogleSignInAccount googleSignInAcc;


   ChannelModelCredFromApi.fromApi({required Channel channel,required String googleAccount,required String accessTok,required String idTok,required GoogleSignInAccount googleSignInAccount}):
       nameChannel=channel.snippet!.title!,
       imgBanner=channel.snippet!.thumbnails!.medium!.url!,
       idUpload=channel.contentDetails!.relatedPlaylists!.uploads!,
       idChannel=channel.id!,
       idToken=idTok,
       accessToken=accessTok,
       googleSignInAcc= googleSignInAccount,
        accountName=googleAccount;




 }