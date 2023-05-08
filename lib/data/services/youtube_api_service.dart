

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import '../http_client/dio_client_insert_caption.dart';
import '../http_client/http_client.dart';
import '../models/video_model_from_api.dart';

  class YouTubeApiService {

    IOClient? httpClient;
    final _googleSingIn = locator.get<GoogleSignIn>();
    final _dio = locator.get<DioClientInsertCaption>();
    FirebaseAuth? _auth;

    YouTubeApiService(){
      _auth=FirebaseAuth.instance;
    }




    Future<List<ChannelModelFromApi>> getListChanel(bool reload) async {
      try {
        if (reload) {
        final googleSignInAccount=  await _googleSingIn.signIn();
          if (_googleSingIn.currentUser == null) {
            throw const Failure('Error auth');
          }
          final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );
          final UserCredential userCredential =
          await _auth!.signInWithCredential(credential);
          await PreferencesUtil.setUrlAvatar(userCredential.user!.photoURL!);
          await PreferencesUtil.setUserName(userCredential.user!.displayName!);
          await PreferencesUtil.setEmail(userCredential.user!.email!);
          final  authHeaders = await _googleSingIn.currentUser!.authHeaders;
          await PreferencesUtil.setHeadersGoogleApi(authHeaders);
          httpClient = GoogleHttpClient(authHeaders);
        }else{
          final authHeaderString = PreferencesUtil.getHeaderApiGoogle;
          final authHeaders = json.decode(authHeaderString);
          final header = Map<String, String>.from(authHeaders);
          httpClient = GoogleHttpClient(header);
        }
        final data = YouTubeApi(httpClient!);
        final result = await data.channels.list(
            ['snippet,contentDetails,statistics'], mine: true);
        if(result.items==null){
          return [];
        }
        return result.items!.map((e) => ChannelModelFromApi.fromApi(channel: e))
            .toList();
      } on Failure catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      } on PlatformException catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
      }
    }


    Future<List<AllVideoModelFromApi>> getVideoFromAccount(
        String idUpload) async {
      List<String> idsVideo = [];

      try {
        final data = YouTubeApi(httpClient!);
        final result = await data.search.list(['snippet'], forMine: true, maxResults: 20, type: ['video']);
        for (var item in result.items!) {
          idsVideo.add(item.id!.videoId!);
        }
        final ids = idsVideo.toString().split('[')[1].split(']')[0].replaceAll(' ', '');
        final listVideo = await data.videos.list(['snippet,contentDetails,statistics,status'], id: [ids]);
         if(listVideo.items==null){
           return [];
         }
         return listVideo.items!.map((e) => AllVideoModelFromApi.fromApi(video: e)).toList();
      } on Failure catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      } on PlatformException catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure('${error.message}'), stackTrace);
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure('$error'), stackTrace);
      }
    }


    Future<int> updateLocalization(VideoModel videoModel,
        Map<String, VideoLocalization> map) async {
      try {
        final authHeaderString = PreferencesUtil.getHeaderApiGoogle;
        final authHeaders = json.decode(authHeaderString);
        final header = Map<String, String>.from(authHeaders);
        httpClient = GoogleHttpClient(header);
        final data = YouTubeApi(httpClient!);
        final res = await data.videos.update(Video(
            id: videoModel.idVideo,
            snippet: VideoSnippet(
                description: videoModel.description,
                title: videoModel.title,
                categoryId: videoModel.categoryId,
                defaultLanguage: videoModel.defaultLanguage
            ),
            localizations: map
        ), ['localizations,snippet,status']);

        if(res.localizations==null){
          return 1;
        }
        if(res.localizations!.isNotEmpty){
          return 2;
        }else{
          return 3;
        }
      } on  DetailedApiRequestError catch(error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message!),stackTrace);
      }on Failure catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      } on PlatformException catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
      }

    }


    Future<List<Caption>> loadCaptions(String idVideo) async {

      try {
        final authHeaderString = PreferencesUtil.getHeaderApiGoogle;
        final authHeaders = json.decode(authHeaderString);
        final header = Map<String, String>.from(authHeaders);
        httpClient = GoogleHttpClient(header);
        final api = YouTubeApi(httpClient!);
        final cap = await api.captions.list(['id','snippet'], idVideo);
        return cap.items!;
      } on Failure catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      } on PlatformException catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
      }
    }

    Future<void> removeCaptions(String idCap) async {

      try {
        final api = YouTubeApi(httpClient!);
         await api.captions.delete(idCap);

      } on Failure catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      } on PlatformException catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
      }
    }



    Future<void> insertCaption({required String idCap, required String idVideo, required String codeLang}) async {
      try {
        final authHeaderString = PreferencesUtil.getHeaderApiGoogle;
        final authHeaders = json.decode(authHeaderString);
        final header = Map<String, String>.from(authHeaders);
        httpClient = GoogleHttpClient(header);
        final api = YouTubeApi(httpClient!);
        final caption = await _dio.init().get('/$idCap', queryParameters: {
          'tlang': codeLang, 'tfmt': 'sbv'
        });

        String dir = (await getTemporaryDirectory()).path;
        final f1 = '$dir/captions.sbv';
        final f = await File(f1).create();
        final file = await f.writeAsString(caption.data);
        Stream<List<int>> stream = file.openRead();
        final media = Media(stream, (await file.length()));
        await api.captions.insert(Caption(
          snippet: CaptionSnippet(
              videoId: idVideo,
              language: codeLang,
              name: ''
          ),
        ), ['snippet'],
            uploadMedia: media);

      } on Failure catch (error, stackTrace) {

        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      } on PlatformException catch (error, stackTrace) {

        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } on DioError catch (error, stackTrace) {

        Error.throwWithStackTrace(Failure.fromDioError(error), stackTrace);
      } catch (error, stackTrace) {

        Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
      }
    }

  }







