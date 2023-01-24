


import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_clicker/data/models/list_translate_api.dart';

void main() {
  test('unit',(){

    final i=ListTranslate.langName(1, Local.ru);
    final c=ListTranslate.langCode(1);
    expect('50%', getProgress(20,40));
  });



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