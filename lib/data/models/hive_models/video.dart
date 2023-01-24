



import 'package:hive/hive.dart';
part 'video.g.dart';


@HiveType(typeId: 0)
  class Video{
  @HiveField(0)
   final String id;
  @HiveField(1)
   final List<String> codeLanguage;

   const Video({
    required this.id,
    required this.codeLanguage,
  });
}