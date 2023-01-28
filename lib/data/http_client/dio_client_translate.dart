


import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import '../../resourses/constants.dart';


class DioClient{

  static SecurityContext? securityContext;

  Dio init() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrlAPi,
        connectTimeout: 15000,
        receiveTimeout: 10000,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
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