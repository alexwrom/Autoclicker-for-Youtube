

 import 'package:google_sign_in/google_sign_in.dart';

import '../../data/models/hive_models/cred_channel.dart';

class ChannelModelCred{

  final String nameChannel;
  final String imgBanner;
  final String accountName;
  final String idUpload;
  final String idChannel;
  final String accessToken;
  final String idToken;
  final int keyLangCode;


  const ChannelModelCred({
    required this.nameChannel,
    required this.imgBanner,
    required this.accountName,
    required this.idUpload,
    required this.idChannel,
    required this.accessToken,
    required this.idToken,
    required this.keyLangCode
  });


  static ChannelModelCred fromBoxHive({required CredChannel channel}){
    return ChannelModelCred(
        nameChannel: channel.nameChannel,
        imgBanner: channel.imgBanner,
        accountName: channel.accountName,
        idUpload: channel.idUpload,
        idChannel: channel.idChannel,
        accessToken: channel.accessToken,
        idToken: channel.idToken,
        keyLangCode:channel.keyLangCode);
  }

  ChannelModelCred copyWith({
    String? nameChannel,
    String? imgBanner,
    String? accountName,
    String? idUpload,
    String? idChannel,
    String? accessToken,
    String? idToken,
    int? keyLangCode,
  }) {
    return ChannelModelCred(
      nameChannel: nameChannel ?? this.nameChannel,
      imgBanner: imgBanner ?? this.imgBanner,
      accountName: accountName ?? this.accountName,
      idUpload: idUpload ?? this.idUpload,
      idChannel: idChannel ?? this.idChannel,
      accessToken: accessToken ?? this.accessToken,
      idToken: idToken ?? this.idToken,
      keyLangCode: keyLangCode ?? this.keyLangCode,
    );
  }
}