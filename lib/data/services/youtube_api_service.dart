

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/io_client.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:youtube_clicker/data/models/channel_model_from_api.dart';
import 'package:youtube_clicker/utils/failure.dart';
import '../../di/locator.dart';
import '../../domain/models/video_model.dart';
import '../../utils/preferences_util.dart';
import '../http_clien/http_client.dart';
import '../models/video_model_from_api.dart';

  class YouTubeApiService{

    IOClient? httpClient;
    final _googleSingIn=locator.get<GoogleSignIn>();

    YouTubeApiService(){
      final authHeaderString=PreferencesUtil.getHeaderApiGoogle;
      final authHeaders=json.decode(authHeaderString);
      final header=Map<String,String>.from(authHeaders);
      header.addAll({
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });
      header.addAll({
        'Accept': 'application/json',
      });
      httpClient = GoogleHttpClient(header);
    }



    Future<List<ChannelModelFromApi>> getListChanel(bool reload) async{
      try{
        if(reload){
          await _googleSingIn.signIn();
          if(_googleSingIn.currentUser==null){
            throw const Failure('Error auth');
          }
          final authHeaders =await _googleSingIn.currentUser!.authHeaders;
          await PreferencesUtil.setHeadersGoogleApi(authHeaders);
          httpClient = GoogleHttpClient(authHeaders);
        }
        final data= YouTubeApi(httpClient!);
        final result=await data.channels.list(['snippet,contentDetails,statistics'],mine: true);
        return result.items!.map((e) => ChannelModelFromApi.fromApi(channel: e)).toList();
      } on Failure catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      } on PlatformException catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
      }






    }



     Future<List<AllVideoModelFromApi>> getVideoFromAccount(String idUpload)async{
        List<String> idsVideo=[];
      try{
         final data= YouTubeApi(httpClient!);
         final result =await data.search.list(['snippet'],forMine: true,maxResults: 20,type: ['video']);
         for(var item in result.items!){
           idsVideo.add(item.id!.videoId!);
         }
         final ids=idsVideo.toString().split('[')[1].split(']')[0].replaceAll(' ', '');
         final listVideo=await data.videos.list(['snippet,contentDetails,statistics,status'],id: [ids]);
         return listVideo.items!.map((e) => AllVideoModelFromApi.fromApi(video: e)).toList();
       } on Failure catch(error,stackTrace){
         Error.throwWithStackTrace(Failure(error.message), stackTrace);
       } on PlatformException catch(error,stackTrace){
         Error.throwWithStackTrace(Failure(error.message!), stackTrace);
       } catch(error,stackTrace){
         Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
       }


     }
     
     

     Future<void> updateLocalization(VideoModel videoModel,Map<String,VideoLocalization> map)async{
      try{
         final data= YouTubeApi(httpClient!);
         final res=await data.videos.update(Video(
             id: videoModel.idVideo,
             snippet: VideoSnippet(
                 description: videoModel.description,
                 title: videoModel.title,
                 categoryId: videoModel.categoryId,
                 defaultLanguage: videoModel.defaultLanguage
             ),
             localizations: map
         ), ['localizations,snippet,status']);
         print('Response ${res.localizations}');
       } on Failure catch(error,stackTrace){
         Error.throwWithStackTrace(Failure(error.message), stackTrace);
       } on PlatformException catch(error,stackTrace){
         Error.throwWithStackTrace(Failure(error.message!), stackTrace);
       } catch(error,stackTrace){
         Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
       }

     }


     Future<void> loadCaptions(String idVideo)async{
      print('ID Video $idVideo');
        final  api=YouTubeApi(httpClient!);
         //final caption= await api.captions.download('AUieDaYwoeBgoIO8hV8KeIpOUgpAP6tTCqt7iWxtoVuj');
         await api.captions.insert(Caption(), ['snippet']);
     }







}







