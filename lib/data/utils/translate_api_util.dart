


  import '../../di/locator.dart';
import '../services/translate_api_service.dart';

class TranslateApiUtil{

     final _apiTranslate=locator.get<TranslateApiService>();

    Future<String> translate(String code, String text)async{
       return await _apiTranslate.translate(code, text);
    }

  }