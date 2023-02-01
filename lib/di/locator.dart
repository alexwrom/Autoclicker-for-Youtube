
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/youtube/v3.dart';

import '../data/http_client/dio_auth_client.dart';
import '../data/http_client/dio_client_insert_caption.dart';
import '../data/http_client/dio_client_translate.dart';
import '../data/repository/auth_repository_impl.dart';
import '../data/repository/translate_repository_impl.dart';
import '../data/repository/user_repository_impl.dart';
import '../data/repository/youtube_reposotory_impl.dart';
import '../data/services/auth_service.dart';
import '../data/services/translate_api_service.dart';
import '../data/services/user_api_service.dart';
import '../data/services/youtube_api_service.dart';
import '../data/utils/auth_api_util.dart';
import '../data/utils/translate_api_util.dart';
import '../data/utils/user_data_api_util.dart';
import '../data/utils/youtube_api_util.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/repository/translate_repository.dart';
import '../domain/repository/user_repository.dart';
import '../domain/repository/youtube_repository.dart';
import '../presentation/main_screen/cubit/user_data_cubit.dart';
  final locator=GetIt.instance;



  void setup(){

    //auth
      locator.registerLazySingleton(() => GoogleSignIn(
          //clientId: '975260836202-auh4p2otnnbf3eta2il2tms67fpdgqct.apps.googleusercontent.com',
          scopes: [YouTubeApi.youtubeForceSslScope]
      ));
      locator.registerLazySingleton(() => AuthService());
      locator.registerLazySingleton(() => AuthApiUtil());
      locator.registerFactory<AuthRepository>(() => AuthRepositoryImpl());

      //emei
    locator.registerLazySingleton(() => DeviceInfoPlugin());

      //dio
      locator.registerLazySingleton(()=>DioClient());
      locator.registerLazySingleton(()=>DioAuthClient());
      locator.registerLazySingleton(()=>DioClientInsertCaption());


      //api google youtube
    locator.registerLazySingleton(() =>YouTubeApiService());
    locator.registerLazySingleton(() => YouTubeApiUtil());
    locator.registerFactory<YouTubeRepository>(() => YouTubeRepositoryImpl());

    //api google translate
     locator.registerLazySingleton(() => TranslateApiService());
     locator.registerLazySingleton(() => TranslateApiUtil());
     locator.registerFactory<TranslateRepository>(() => TranslateRepositoryImpl());

     //User
    locator.registerLazySingleton(() => UserApiService());
    locator.registerLazySingleton(() => UserDataApiUtil());
    locator.registerFactory<UserRepository>(() => UserRepositoryImpl());
    locator.registerLazySingleton(() => UserDataCubit());


  }