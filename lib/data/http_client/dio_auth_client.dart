



  import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import '../../resourses/constants.dart';

class DioAuthClient{

    static SecurityContext? securityContext;

    Dio init() {
      final dio = Dio(
        BaseOptions(
          baseUrl: baseUrlAuth,
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