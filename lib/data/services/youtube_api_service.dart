

import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/io_client.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:path_provider/path_provider.dart';
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
      // header.addAll({
      //   'Accept': 'application/json',
      //   'Content-Type': 'application/json'
      // });
      // header.addAll({
      //   'Accept': 'application/json',
      // });
      print('Hed ${header}');
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

     //todo
     Future<void> loadCaptions(String idVideo)async{
        final  api=YouTubeApi(httpClient!);
        final cap=await api.captions.list(['id'], idVideo);
        final idCap= cap.items![0].id;

      final caption=await init().get('/$idCap',queryParameters: {
        'tlang': 'en','tfmt': 'sbv'
      });
      String dir = (await getTemporaryDirectory()).path;
          final f1 = '$dir/captions.sbv';
          final f=await File(f1).create();
         final file=await  f.writeAsString(caption.data);
         Stream<List<int>> stream = file.openRead();
         final media=Media(stream,(await file.length()));
       final res= await api.captions.insert(Caption(
          snippet: CaptionSnippet(
            videoId: idVideo,
            language: 'en',
            name: 'caption_en'
          ),
         ), ['snippet'],
         uploadMedia: media);
       print('Res ${res}');
     }


    Dio init() {
       SecurityContext? securityContext;
       final authHeaderString=PreferencesUtil.getHeaderApiGoogle;
       final authHeaders=json.decode(authHeaderString);
       final header=Map<String,String>.from(authHeaders);
       header.addAll({
         'Content-Type':'application/octet-stream'
       });
      final dio = Dio(
        BaseOptions(
          headers: header,
          baseUrl: 'https://www.googleapis.com/youtube/v3/captions/',
          connectTimeout: 15000,
          receiveTimeout: 10000,
        ),
      );

      final httpClientAdapter = dio.httpClientAdapter;
      if (httpClientAdapter is DefaultHttpClientAdapter) {
        httpClientAdapter.onHttpClientCreate = (_) => HttpClient(
          context: securityContext,
        );
      }
      return dio;
    }




}







