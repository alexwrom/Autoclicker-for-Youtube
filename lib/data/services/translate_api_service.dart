


import 'package:dio/dio.dart';


import '../../di/locator.dart';
import '../../utils/failure.dart';
import '../http_client/dio_client_translate.dart';
  class TranslateApiService{


    final  _dio=locator.get<DioClient>();




  Future<String> translate(String code,String text)async{

    try{
      final res=await _dio.init().get('/single',queryParameters: {
        'client':'gtx',
        'sl':'auto',
        'tl':code,
        'dt':'t',
        'q':text,
      });
      var r = '';
      var n = (res.data[0] as List).length;
      for (var i = 0; i <= n - 1; i++)
       {
         r = r + res.data[0][i][0].toString();
       }
      return r;
    }on DioError catch(error,stackTrace){
      Error.throwWithStackTrace(Failure.fromDioError(error), stackTrace);
    }
  }





  }