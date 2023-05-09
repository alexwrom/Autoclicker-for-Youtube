

import 'package:hive/hive.dart';
part 'cred_channel.g.dart';

@HiveType(typeId: 1)
class CredChannel{
  @HiveField(0)
  final String idUpload;
  @HiveField(1)
  final String nameChannel;
  @HiveField(2)
  final String imgBanner;
  @HiveField(3)
  final String accountName;


  CredChannel({
    required this.nameChannel,
    required this.imgBanner,
    required this.accountName,
    required this.idUpload
  });
}