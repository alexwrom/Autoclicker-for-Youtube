



import 'package:hive/hive.dart';
part 'channel_lang_code.g.dart';


@HiveType(typeId: 0)
  class ChannelLangCode{
  @HiveField(0)
   final String id;
  @HiveField(1)
   final List<String> codeLanguage;

    ChannelLangCode({
    required this.id,
    required this.codeLanguage,
  });
}