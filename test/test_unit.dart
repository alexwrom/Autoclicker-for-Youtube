


import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_clicker/data/models/list_translate_api.dart';

void main() {
  test('unit',(){

     String text='''Много людей, стараемся работать в быстром темпе. Вызываю заявителя, подходит девушка: Здравствуйте, мне надо заменить паспорт.
     Вместо того, чтобы как нормальный человек уточнить, я пытаюсь угадать причину (Мамкин Шерлок, блин): Добрый день, в связи с достижением 45 лет?
    Её лицо становится таким, о котором мечтали бы все игроки в покер. Эмоции не читаются. Ледяной голос отвечает:
    В связи с заключением брака. Мне 27.''';
    final t= text.replaceAll('\n','*');
     print("Translate 1 $t");

    final t1=t.replaceAll('*', '\n');

     print("Translate 2 $t1");

  });



}
String _getOnePriceTranslate(String price,int countTranslate){
  double p=double.parse(price);
  double r=p/countTranslate;
  return r.toString().substring(0,4);
}

String getProgress(int op,int allOp){
  return '${((op*100)~/allOp).toString()}%';
}

   format(Duration d) => d.toString().split('.').first.padLeft(8, "0");


  Duration toDuration(String isoString) {
  if (!RegExp(
      r"^(-|\+)?P(?:([-+]?[0-9,.]*)Y)?(?:([-+]?[0-9,.]*)M)?(?:([-+]?[0-9,.]*)W)?(?:([-+]?[0-9,.]*)D)?(?:T(?:([-+]?[0-9,.]*)H)?(?:([-+]?[0-9,.]*)M)?(?:([-+]?[0-9,.]*)S)?)?$")
      .hasMatch(isoString)) {
    throw ArgumentError("String does not follow correct format");
  }

  final weeks = _parseTime(isoString, "W");
  final days = _parseTime(isoString, "D");
  final hours = _parseTime(isoString, "H");
  final minutes = _parseTime(isoString, "M");
  final seconds = _parseTime(isoString, "S");

  return Duration(
    days: days + (weeks * 7),
    hours: hours,
    minutes: minutes,
    seconds: seconds,
  );
}
int _parseTime(String duration, String timeUnit) {
  final timeMatch = RegExp(r"\d+" + timeUnit).firstMatch(duration);

  if (timeMatch == null) {
    return 0;
  }
  final timeString = timeMatch.group(0);
  return int.parse(timeString!.substring(0, timeString.length - 1));
}