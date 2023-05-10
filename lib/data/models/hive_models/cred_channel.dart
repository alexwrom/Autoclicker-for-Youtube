

import 'package:google_sign_in/google_sign_in.dart';
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
  @HiveField(4)
  final String idChannel;
  @HiveField(5)
  final String accessToken;
  @HiveField(6)
  final String idToken;
  @HiveField(7)
  final int keyLangCode;



  CredChannel({
    required this.keyLangCode,
    required this.nameChannel,
    required this.imgBanner,
    required this.accountName,
    required this.idUpload,
    required this.idChannel,
    required this.accessToken,
    required this.idToken,

  });
}