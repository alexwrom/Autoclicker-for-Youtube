import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/identitytoolkit/v3.dart';
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
import '../models/config_app_model.dart';
import '../models/video_model_from_api.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

class YouTubeApiService {
  IOClient? httpClient;
  final _googleSingIn = locator.get<GoogleSignIn>();
  final _dio = locator.get<DioClientInsertCaption>();
  final _dioAuthClient = locator.get<DioAuthClient>();


  Future<void> _checkRemoteChannelsList({required String idChannel,required String refreshToken}) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('channels')
          .doc(idChannel.trim())
          .get();
      if (!doc.exists) {
        await FirebaseFirestore.instance
            .collection('channels')
            .doc(idChannel.trim()).set({
          'balance':400,
          'refreshToken':refreshToken
        });
      }else{
        await FirebaseFirestore.instance
            .collection('channels')
            .doc(idChannel.trim()).update({'refreshToken':refreshToken});
      }

    } on FirebaseException catch (e, stackTrace) {
      Error.throwWithStackTrace(Failure(e.message!), stackTrace);
    }
  }

  Future<ChannelModelCredFromApi> addRemoteChannelByRefreshToken({required String idChannel}) async {
    try {
      final dataCredChannel = await _getCredByIdChannel(idChannel: idChannel);
      final accessToken = await getAccessTokenByRefreshToken(
          refreshToken: dataCredChannel.$1,
          typePlatformRefreshToken: TypePlatformRefreshToken.desktop);
      final authHeaders = <String, String>{
        'Authorization': 'Bearer $accessToken',
        'X-Goog-AuthUser': '0',
      };

      httpClient = GoogleHttpClient(authHeaders);
      final data = YouTubeApi(httpClient!);
      final result = await data.channels
          .list(['snippet,contentDetails,statistics'], mine: true);
      if (result.items == null) {
        throw const Failure('Channel list is empty');
      }
      return ChannelModelCredFromApi.fromApi(
          channel: result.items![0],
          googleAccount: '',
          idTok: '',
          remoteChannel: true,
          bonus: dataCredChannel.$2,
          typePlatformRefreshTok: TypePlatformRefreshToken.desktop,
          refToken: dataCredChannel.$1,
          accessTok: accessToken,
          iDInvitation: '');
    } on Failure catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.message), stackTrace);
    } on PlatformException catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.message!), stackTrace);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
    }
  }

  Future<int> getBonusOfRemoteChannel({required String idChannel}) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('channels')
          .doc(idChannel.trim())
          .get();
      if (!doc.exists) {
        throw const Failure('Token is not found');
      }
      return doc.get('balance') as int;
    } on FirebaseException catch (e, stackTrace) {
      Error.throwWithStackTrace(Failure(e.message!), stackTrace);
    }
  }

  Future<(String,int)> _getCredByIdChannel({required String idChannel}) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('channels')
          .doc(idChannel.trim())
          .get();
      if (!doc.exists) {
        throw const Failure('Token is not found');
      }
      return (doc.get('refreshToken') as String,doc.get('balance') as int);
    } on FirebaseException catch (e, stackTrace) {
      Error.throwWithStackTrace(Failure(e.message!), stackTrace);
    }
  }



  Future<ChannelModelCredFromApi> addChannelByCodeInvitation(
      {required String code}) async {
    try {
      final credByInvitation = await getCredByCodeInvitation(code: code);
      final accessToken = await getAccessTokenByRefreshToken(
          refreshToken: credByInvitation.refreshToken,
          typePlatformRefreshToken: TypePlatformRefreshToken.desktop);
      final authHeaders = <String, String>{
        'Authorization': 'Bearer $accessToken',
        'X-Goog-AuthUser': '0',
      };
      httpClient = GoogleHttpClient(authHeaders);
      final data = YouTubeApi(httpClient!);
      final result = await data.channels
          .list(['snippet,contentDetails,statistics'], mine: true);
      if (result.items == null) {
        throw const Failure('Channel list is empty');
      }

      await _checkRemoteChannelsList(
          idChannel: result.items![0].id!,
          refreshToken: credByInvitation.refreshToken);

      return ChannelModelCredFromApi.fromApi(
          channel: result.items![0],
          googleAccount: credByInvitation.emailUser,
          idTok: '',
          typePlatformRefreshTok: TypePlatformRefreshToken.desktop,
          refToken: credByInvitation.refreshToken,
          accessTok: accessToken,
          remoteChannel: false,
          iDInvitation: credByInvitation.idInvitation,
          bonus: 0);
    } on Failure catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.message), stackTrace);
    } on PlatformException catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.message!), stackTrace);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
    }
  }

  Future<ChannelModelCredFromApi> addChannel() async {
    try {
      final ChannelModelCredFromApi channelModelCredFromApi;
      if (Platform.isIOS) {
        channelModelCredFromApi = await _getModelChannelIOS();
      } else {
        channelModelCredFromApi = await _getModelChannelAndroid();
      }
      await _checkRemoteChannelsList(
          idChannel: channelModelCredFromApi.idChannel,
          refreshToken: channelModelCredFromApi.refreshToken);

      return channelModelCredFromApi;
    } on Failure catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.message), stackTrace);
    } on PlatformException catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.message!), stackTrace);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
    }
  }

  Future<ChannelModelCredFromApi> _getModelChannelAndroid() async {
    try {

      await _googleSingIn.signOut();
      final googleSignInAccount = await _googleSingIn.signIn();
      if (_googleSingIn.currentUser == null) {
        throw const Failure('Process stopped...');
      }

      final email = _googleSingIn.currentUser!.email;
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication.catchError((error) {
        throw const Failure('Error google signin');
      });
      final accessToken = googleSignInAuthentication.accessToken!;
      final authHeaders = await _googleSingIn.currentUser!.authHeaders;
      httpClient = GoogleHttpClient(authHeaders);
      final data = YouTubeApi(httpClient!);
      final result = await data.channels
          .list(['snippet,contentDetails,statistics'], mine: true);

      if (result.items == null) {
        throw const Failure('Channel list is empty');
      }

      return ChannelModelCredFromApi.fromApi(
          channel: result.items![0],
          googleAccount: email,
          idTok: '',
          refToken: '',
          iDInvitation: '',
          bonus: 0,
          remoteChannel: false,
          typePlatformRefreshTok: TypePlatformRefreshToken.android,
          accessTok: accessToken);
    } on Failure catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.message), stackTrace);
    } on PlatformException catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.message!), stackTrace);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
    }
  }

  Future<ChannelModelCredFromApi> _getModelChannelIOS() async {
    try {
      final cred = await getConfigApp();
      final oauth2Helper = getOauth2Helper(cred: cred);
      var response = await oauth2Helper.fetchToken();
      final refreshToken = response.refreshToken!;
      final accessToken = response.accessToken!;
      final authHeaders = <String, String>{
        'Authorization': 'Bearer $accessToken',
        'X-Goog-AuthUser': '0',
      };
      httpClient = GoogleHttpClient(authHeaders);
      final data = YouTubeApi(httpClient!);
      final result = await data.channels
          .list(['snippet,contentDetails,statistics'], mine: true);

      if (result.items == null) {
        throw const Failure('Channel list is empty');
      }

      return ChannelModelCredFromApi.fromApi(
          channel: result.items![0],
          googleAccount: '',
          idTok: '',
          remoteChannel: false,
          typePlatformRefreshTok: TypePlatformRefreshToken.ios,
          refToken: refreshToken,
          iDInvitation: '',
          bonus: 0,
          accessTok: accessToken);
    } on Failure catch (error, stackTrace) {
      print('Error 1 ${error.message}');
      Error.throwWithStackTrace(Failure(error.message), stackTrace);
    } on PlatformException catch (error, stackTrace) {
      print('Error 2 ${error.message}');
      Error.throwWithStackTrace(Failure(error.message!), stackTrace);
    } catch (error, stackTrace) {
      print('Error 3 ${error.toString()}');
      Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
    }
  }

  Future<List<AllVideoModelFromApi>> getVideoFromAccount(
      ChannelModelCred cred) async {
    List<String> idsVideo = [];
    try {
      String accessToken = await _getAccessToken(cred);
      final authHeaders = <String, String>{
        'Authorization': 'Bearer $accessToken',
        'X-Goog-AuthUser': '0',
      };
      await PreferencesUtil.setHeadersGoogleApi(authHeaders);
      httpClient = GoogleHttpClient(authHeaders);
      final data = YouTubeApi(httpClient!);
      final result = await data.search
          .list(['snippet'], forMine: true, maxResults: 20, type: ['video']);
      for (var item in result.items!) {
        idsVideo.add(item.id!.videoId!);
      }

      final ids =
          idsVideo.toString().split('[')[1].split(']')[0].replaceAll(' ', '');
      final listVideo = await data.videos
          .list(['snippet,contentDetails,statistics,status'], id: [ids]);
      if (listVideo.items == null) {
        return [];
      }

      return listVideo.items!
          .map((e) => AllVideoModelFromApi.fromApi(video: e))
          .toList();
    } on Failure catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.message), stackTrace);
    } on PlatformException catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure('${error.message}'), stackTrace);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure('$error'), stackTrace);
    }
  }

  Future<String> _getAccessToken(ChannelModelCred cred) async {
    String accessToken = '';
    if (cred.typePlatformRefreshToken == TypePlatformRefreshToken.android) {
      accessToken = await getNewAccessToken(cred.accountName);
    } else {
      accessToken = await getAccessTokenByRefreshToken(
          refreshToken: cred.refreshToken,
          typePlatformRefreshToken: cred.typePlatformRefreshToken);
    }
    return accessToken;
  }

  Future<int> updateLocalization(
      VideoModel videoModel,
      ChannelModelCred channelModelCred,
      Map<String, VideoLocalization> map) async {
    try {

      String defLang = videoModel.defaultLanguage;
      if (defLang.isEmpty) {
        defLang = videoModel.defaultAudioLanguage;
        if (defLang.isEmpty) {
          defLang = channelModelCred.defaultLanguage;
          if (defLang.isEmpty) {
            return 3;
          }
        }
      }

      String defAudioLang = videoModel.defaultAudioLanguage;
      if (defAudioLang.isEmpty) {
        defAudioLang = videoModel.defaultLanguage;
        if (defAudioLang.isEmpty) {
          defAudioLang = channelModelCred.defaultLanguage;
          if (defAudioLang.isEmpty) {
            return 3;
          }
        }
      }
      final authHeaderString = PreferencesUtil.getHeaderApiGoogle;
      final authHeaders = json.decode(authHeaderString);
      final header = Map<String, String>.from(authHeaders);
      httpClient = GoogleHttpClient(header);
      final data = YouTubeApi(httpClient!);
      final res = await data.videos.update(
          Video(
              id: videoModel.idVideo,
              snippet: VideoSnippet(
                description: videoModel.description,
                title: videoModel.title,
                categoryId: videoModel.categoryId,
                defaultAudioLanguage: defAudioLang,
                defaultLanguage: defLang,
                tags: videoModel.tags,
              ),
              localizations: map),
          ['localizations,snippet']);

      if (res.localizations == null) {
        return 1;
      }
      if (res.localizations!.isNotEmpty) {
        return 2;
      } else {
        return 3;
      }
    } on DetailedApiRequestError catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.message!), stackTrace);
    } on Failure catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.message), stackTrace);
    } on PlatformException catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.message!), stackTrace);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
    }
  }

  Future<List<Caption>> loadCaptions(
      String idVideo, ChannelModelCred cred) async {
    try {
      String accessToken = await _getAccessToken(cred);
      final authHeaders = <String, String>{
        'Authorization': 'Bearer $accessToken',
        'X-Goog-AuthUser': '0',
      };
      // final authHeaderString = PreferencesUtil.getHeaderApiGoogle;
      // final authHeaders = json.decode(authHeaderString);
      final header = Map<String, String>.from(authHeaders);
      httpClient = GoogleHttpClient(header);
      final api = YouTubeApi(httpClient!);
      final cap = await api.captions.list(['id', 'snippet'], idVideo);
      return cap.items!;
    } on Failure catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.message), stackTrace);
    } on PlatformException catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.message!), stackTrace);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
    }
  }

  //todo void on bool
  Future<bool> removeCaptions(String idCap) async {
    try {
      final api = YouTubeApi(httpClient!);
      await api.captions.delete(idCap);
      return true;
    } on Failure catch (error) {
      print('Error Remove 1 ${error.message}');
      return false;
    } on PlatformException catch (error) {
      print('Error Remove 2 ${error.message}');
      return false;
    } catch (error) {
      print('Error Remove 3 ${error.toString()}');
      return false;
    }
  }

  Future<bool> insertCaption(
      {required String idCap,
      required String idVideo,
      required String codeLang}) async {
    try {
      final authHeaderString = PreferencesUtil.getHeaderApiGoogle;
      final authHeaders = json.decode(authHeaderString);
      final header = Map<String, String>.from(authHeaders);
      httpClient = GoogleHttpClient(header);
      final api = YouTubeApi(httpClient!);
      final caption = await _dio
          .init()
          .get('/$idCap', queryParameters: {'tlang': codeLang, 'tfmt': 'sbv'});
      String dir = (await getTemporaryDirectory()).path;
      final f1 = '$dir/captions.sbv';
      final f = await File(f1).create();
      final file = await f.writeAsString(caption.data);
      Stream<List<int>> stream = file.openRead();
      final media = Media(stream, (await file.length()));
      await api.captions.insert(
          Caption(
            snippet:
                CaptionSnippet(videoId: idVideo, language: codeLang, name: ''),
          ),
          ['snippet'],
          uploadMedia: media);
      return true;
    } on Failure catch (error) {
      print('Error Insert 1 ${error.message}');
      return false;
    } on PlatformException catch (error) {
      print('Error Insert 2 ${error.message}');
      return false;
    } on DioError catch (error) {
      print('Error Insert 3 ${error.message}');
      return false;
    } catch (error) {
      print('Error Insert 4 ${error.toString()}');
      return false;
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
    } on Failure catch (e, stackTrace) {
      Error.throwWithStackTrace(Failure(e.toString()), stackTrace);
    } // New refreshed token
  }

  Future<String> getAccessTokenByRefreshToken(
      {required String refreshToken,
      required TypePlatformRefreshToken typePlatformRefreshToken}) async {
    final cred = await getConfigApp();
    try {
      final token =
          await _dioAuthClient.init().post('/token', queryParameters: {
        'client_id':
            typePlatformRefreshToken == TypePlatformRefreshToken.desktop
                ? cred.clientId
                : cred.credAuthIOS[1],
        if (typePlatformRefreshToken == TypePlatformRefreshToken.desktop)
          'client_secret': cred.clientSecret,
        'refresh_token': refreshToken,
        'grant_type': 'refresh_token'
      });
      return token.data['access_token'];
    } on DioError catch (e, stackTrace) {
      Error.throwWithStackTrace(
          const Failure('Error refresh token'), stackTrace);
    } on FirebaseException catch (e, stackTrace) {
      Error.throwWithStackTrace(const Failure('Access error'), stackTrace);
    }
  }

  Future<ConfigAppModel> getConfigApp() async {
    final document = await FirebaseFirestore.instance
        .collection('settings')
        .doc('setting')
        .get();
    return ConfigAppModel.fromApi(document);
  }

  Future<CredByCodeInvitationModel> getCredByCodeInvitation(
      {required String code}) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('codes_invitation')
          .doc(code)
          .get();
      if (!doc.exists) {
        throw const Failure('This code is not found');
      }
      return CredByCodeInvitationModel.fromApi(doc);
    } on FirebaseException catch (e, stackTrace) {
      Error.throwWithStackTrace(Failure(e.message!), stackTrace);
    }
  }

  Future<bool> isActivatedChanelByInvitation(String code) async {
    final doc = await FirebaseFirestore.instance
        .collection('codes_invitation')
        .doc(code)
        .get();
    return doc.exists;
  }

  OAuth2Helper getOauth2Helper({required ConfigAppModel cred}) {
    final customUriScheme = Platform.isIOS?cred.credAuthIOS[0]:'my.test.app';
    final clientID = Platform.isIOS?cred.credAuthIOS[1]:cred.clientId;
    GoogleOAuth2Client client = GoogleOAuth2Client(
        customUriScheme: customUriScheme,
        redirectUri: '$customUriScheme:/oauthredirect');
    OAuth2Helper oauth2Helper = OAuth2Helper(client,
        grantType: OAuth2Helper.authorizationCode,
        clientId: clientID,
        scopes: [YouTubeApi.youtubeForceSslScope]);

    return oauth2Helper;
  }
}
