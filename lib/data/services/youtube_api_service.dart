

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/notebooks/v1.dart';
import 'package:http/io_client.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_clicker/data/models/cred_by_code_invitation_model.dart';
import 'package:youtube_clicker/utils/failure.dart';
import '../../di/locator.dart';
import '../../domain/models/channel_model_cred.dart';
import '../../domain/models/video_model.dart';
import '../../utils/preferences_util.dart';
import '../http_client/dio_auth_client.dart';
import '../http_client/dio_client_insert_caption.dart';
import '../http_client/http_client.dart';
import '../models/channel_cred_from_api.dart';
import '../models/cred_token_model.dart';
import '../models/video_model_from_api.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';



  class YouTubeApiService {

    IOClient? httpClient;
     final _googleSingIn = locator.get<GoogleSignIn>();
    final _dio = locator.get<DioClientInsertCaption>();
    final _dioAuthClient=locator.get<DioAuthClient>();




    
    Future<ChannelModelCredFromApi> addChannelByCodeInvitation({required String code})async{
      try{
        final credByInvitation=await getCredByCodeInvitation(code: code);
        final accessToken=await getAccessTokenByRefreshToken(
            refreshToken: credByInvitation.refreshToken,
        typePlatformRefreshToken: TypePlatformRefreshToken.desktop);
        final authHeaders=<String, String>{
          'Authorization': 'Bearer $accessToken',
          'X-Goog-AuthUser': '0',
        };
        httpClient = GoogleHttpClient(authHeaders);
        final data = YouTubeApi(httpClient!);
        final result = await data.channels.list(
            ['snippet,contentDetails,statistics'], mine: true);
        if(result.items==null){
          throw const Failure('Channel list is empty');
        }

        return ChannelModelCredFromApi.fromApi(
            channel: result.items![0],
            googleAccount: credByInvitation.emailUser,
            idTok: '',
            typePlatformRefreshTok: TypePlatformRefreshToken.desktop,
            refToken: credByInvitation.refreshToken,
            accessTok: accessToken,
            iDInvitation: credByInvitation.idInvitation
        );



      }on Failure catch (error,stackTrace){
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      } on PlatformException catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
      }
    }

    
    Future<ChannelModelCredFromApi> addChannel()async{

      try {
        final ChannelModelCredFromApi channelModelCredFromApi;
        if(Platform.isIOS){
          channelModelCredFromApi=await getModelChannelIOS();
        }else{
          channelModelCredFromApi=await getModelChannelAndroid();
        }

      return channelModelCredFromApi;
      } on Failure catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      } on PlatformException catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
      }
    }


    Future<ChannelModelCredFromApi> getModelChannelAndroid()async{
      try {

          await _googleSingIn.signOut();
          final googleSignInAccount=  await _googleSingIn.signIn();
          if (_googleSingIn.currentUser == null) {
            throw const Failure('Process stopped...');
          }

          final email=_googleSingIn.currentUser!.email;
          final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication.catchError((error){
            throw const Failure('Error google signin');
          });
          final accessToken=googleSignInAuthentication.accessToken!;
          final  authHeaders = await _googleSingIn.currentUser!.authHeaders;
          httpClient = GoogleHttpClient(authHeaders);
          final data = YouTubeApi(httpClient!);
          final result = await data.channels.list(
              ['snippet,contentDetails,statistics'], mine: true);

          if(result.items==null){
            throw const Failure('Channel list is empty');
          }

          return ChannelModelCredFromApi.fromApi(
              channel: result.items![0],
              googleAccount: email,
              idTok: '',
              refToken: '',
              iDInvitation: '',
              typePlatformRefreshTok: TypePlatformRefreshToken.android,
              accessTok: accessToken
          );



      } on Failure catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      } on PlatformException catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
      }
    }



    Future<ChannelModelCredFromApi> getModelChannelIOS()async{

      try {
          final cred=await getCredsForGetToken();
          final oauth2Helper=getOauth2Helper(cred: cred);
          var response = await oauth2Helper.getToken();
          print('REsponse ${response!.expirationDate}');
          final refreshToken=response!.refreshToken!;
          final accessToken=response.accessToken!;
          final authHeaders=<String, String>{
            'Authorization': 'Bearer $accessToken',
            'X-Goog-AuthUser': '0',
          };
          httpClient = GoogleHttpClient(authHeaders);
          final data = YouTubeApi(httpClient!);
          final result = await data.channels.list(
              ['snippet,contentDetails,statistics'], mine: true);

          if(result.items==null){
            throw const Failure('Channel list is empty');
          }
          await oauth2Helper.disconnect();
          return ChannelModelCredFromApi.fromApi(
              channel:result.items![0],
              googleAccount: '....',
              idTok: '',
              typePlatformRefreshTok:  TypePlatformRefreshToken.ios,
              refToken: refreshToken,
              iDInvitation: '',
              accessTok: accessToken
          );

      } on Failure catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.message), stackTrace);
      } on PlatformException catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.message!), stackTrace);
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
      }
    }


    Future<List<AllVideoModelFromApi>> getVideoFromAccount(
        ChannelModelCred cred) async {
      List<String> idsVideo = [];
      try {
        String accessToken='';
        if(cred.typePlatformRefreshToken==TypePlatformRefreshToken.android){
           accessToken=await getNewAccessToken(cred.accountName);
        }else{
           accessToken=await getAccessTokenByRefreshToken(refreshToken: cred.refreshToken,
           typePlatformRefreshToken: cred.typePlatformRefreshToken);

        }

        final authHeaders=<String, String>{
          'Authorization': 'Bearer $accessToken',
          'X-Goog-AuthUser': '0',
        };
        await PreferencesUtil.setHeadersGoogleApi(authHeaders);
        httpClient = GoogleHttpClient(authHeaders);
        final data = YouTubeApi(httpClient!);
        final result = await data.search.list(['snippet'],
            forMine: true, maxResults: 20, type: ['video']);
        for (var item in result.items!) {
          idsVideo.add(item.id!.videoId!);
        }
        print('Main videos ${result.items!.length}');
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
        ChannelModelCred channelModelCred,
        Map<String, VideoLocalization> map) async {
      try {
        String defLang='en';
        if(videoModel.defaultLanguage.isEmpty){
            defLang=channelModelCred.defaultLanguage;
        }
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
                defaultLanguage: defLang
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

    ///Only for Android
    Future<String> getNewAccessToken(String email) async {
      try {
       await _googleSingIn.signInSilently();
        final GoogleSignInTokenData response =
              await GoogleSignInPlatform.instance.getTokens(
                email: email,
                shouldRecoverAuth: true,
              );

        return response.accessToken!;
      }on Failure catch (e,stackTrace) {
        Error.throwWithStackTrace(Failure(e.toString()), stackTrace);
      } // New refreshed token
    }


    Future<String> getAccessTokenByRefreshToken(
        {required String refreshToken,
      required TypePlatformRefreshToken typePlatformRefreshToken})async{
      final cred=await getCredsForGetToken();
      print('Platform $typePlatformRefreshToken Refresh $refreshToken Client ID ${cred.credAuthIOS[1]}');
       try {
           final token=await _dioAuthClient.init().post('/token',
               queryParameters: {
                 'client_id': typePlatformRefreshToken==TypePlatformRefreshToken.desktop?
                 cred.clientId:cred.credAuthIOS[1],
                 //'client_secret':cred.clientSecret,
                 'refresh_token':refreshToken,
                 'grant_type':'refresh_token'
               });
           return token.data['access_token'];

       }on DioError catch (e,stackTrace) {
         print('ERROR REFRESH TOKEN ${e}');
         Error.throwWithStackTrace(const Failure('Error refresh token'), stackTrace);

       }on FirebaseException catch(e,stackTrace){
         Error.throwWithStackTrace(const Failure('Access error'), stackTrace);
       }

    }





    Future<CredTokenModel> getCredsForGetToken()async{
       final document=await FirebaseFirestore.instance
           .collection('settings')
           .doc('setting').get();
       return CredTokenModel.fromApi(document);
    }
    
    Future<CredByCodeInvitationModel> getCredByCodeInvitation({required String code})async{
       try{
         final doc=await FirebaseFirestore.instance.collection('codes_invitation').doc(code).get();
         if(!doc.exists){
           throw const Failure('This code is not found');
         }
         return CredByCodeInvitationModel.fromApi(doc);
       }on FirebaseException catch(e,stackTrace){
         Error.throwWithStackTrace( Failure(e.message!), stackTrace);
       }
    }



    Future<bool> isActivatedChanelByInvitation(String code)async{
      final doc=await FirebaseFirestore.instance.collection('codes_invitation').doc(code).get();
      return doc.exists;
    }


    OAuth2Helper getOauth2Helper({required CredTokenModel cred}){
       GoogleOAuth2Client client = GoogleOAuth2Client(
         customUriScheme: cred.credAuthIOS[0],
         redirectUri: '${cred.credAuthIOS[0]}:/oauthredirect'
       );
       OAuth2Helper oauth2Helper = OAuth2Helper(client,
           accessTokenParams: {
           'access_type':'offline',
           'prompt':'consent'},
           grantType: OAuth2Helper.authorizationCode,
           clientId: cred.credAuthIOS[1],
           scopes: [YouTubeApi.youtubeForceSslScope]);
       return oauth2Helper;

     }





  }







