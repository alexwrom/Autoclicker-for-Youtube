


import 'package:dio/dio.dart';
import 'package:youtube_clicker/data/dio_client/dio_client.dart';

import '../../di/locator.dart';
import '../../utils/failure.dart';
  class TranslateApiService{


    final  _dio=locator.get<DioClient>();




  Future<String> translate(String code,String text)async{
    final s=text.replaceAll('.', '@');

    try{
      final res=await _dio.init().get('/single',queryParameters: {
        'client':'gtx',
        'sl':'auto',
        'tl':code,
        'dt':'t',
        'q':s,
      });
      final r=res.data[0][0][0].toString().replaceAll('@', '.');
      return r;
    }on DioError catch(error,stackTrace){
      Error.throwWithStackTrace(Failure.fromDioError(error), stackTrace);
    }
  }



  }