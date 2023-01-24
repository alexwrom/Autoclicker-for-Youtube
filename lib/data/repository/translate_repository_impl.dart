


  import '../../di/locator.dart';
import '../../domain/repository/translate_repository.dart';
import '../utils/translate_api_util.dart';

class TranslateRepositoryImpl extends TranslateRepository{

    final _translateUtil=locator.get<TranslateApiUtil>();


  @override
  Future<String> translate(String code, String text)async {
    return await _translateUtil.translate(code, text);
  }



  }