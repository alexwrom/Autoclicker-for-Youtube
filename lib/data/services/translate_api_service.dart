


import 'package:dio/dio.dart';


import '../../di/locator.dart';
import '../../utils/failure.dart';
import '../http_client/dio_client_translate.dart';
  class TranslateApiService{


    final  _dio=locator.get<DioClient>();




  Future<String> translate(String code,String text)async{
    final s=text.replaceAll('.', '@');
    final s1=s.replaceAll('\n', '*');

    try{
      final res=await _dio.init().get('/single',queryParameters: {
        'client':'gtx',
        'sl':'auto',
        'tl':code,
        'dt':'t',
        'q':s1,
      });
      final r=res.data[0][0][0].toString().replaceAll('@', '.');
      final r1=r.replaceAll('*','\n');
      return r1;
    }on DioError catch(error,stackTrace){
      Error.throwWithStackTrace(Failure.fromDioError(error), stackTrace);
    }
  }



  }