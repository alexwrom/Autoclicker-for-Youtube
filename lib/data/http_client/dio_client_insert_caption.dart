

 import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import '../../utils/preferences_util.dart';

class DioClientInsertCaption{

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