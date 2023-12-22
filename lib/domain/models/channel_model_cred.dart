

 import 'package:google_sign_in/google_sign_in.dart';

import '../../data/models/channel_cred_from_api.dart';
import '../../data/models/hive_models/cred_channel.dart';
import '../../resourses/constants.dart';

class ChannelModelCred{

  final String nameChannel;
  final String imgBanner;
  final String accountName;
  final String idUpload;
  final String idChannel;
  final String accessToken;
  final String idToken;
  final int keyLangCode;
  final String refreshToken;
  final String defaultLanguage;
  final String idInvitation;
  final int isTakeBonus;
  final bool remoteChannel;
  final TypePlatformRefreshToken typePlatformRefreshToken;



  const ChannelModelCred({
    required this.nameChannel,
    required this.imgBanner,
    required this.accountName,
    required this.idUpload,
    required this.idChannel,
    required this.accessToken,
    required this.idToken,
    required this.keyLangCode,
    required this.refreshToken,
    required this.defaultLanguage,
    required this.idInvitation,
    required this.isTakeBonus,
    required this.remoteChannel,
    required this.typePlatformRefreshToken
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
        keyLangCode:channel.keyLangCode,
        refreshToken:  channel.refreshToken,
        idInvitation: channel.idInvitation,
        isTakeBonus: channel.isTakeBonus,
        remoteChannel: channel.remoteChannel,
        defaultLanguage:  channel.defaultLanguage,
    typePlatformRefreshToken: channel.typePlatformRefreshToken==androidPlatform?
    TypePlatformRefreshToken.android:
    channel.typePlatformRefreshToken==iosPlatform?
    TypePlatformRefreshToken.ios:channel.typePlatformRefreshToken==desktopPlatform?
    TypePlatformRefreshToken.desktop:TypePlatformRefreshToken.desktop);
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
    String? refreshToken,
    String? idInvitation,
    String? defaultLanguage,
    int? isTakeBonus,
    bool? remoteChannel,
    TypePlatformRefreshToken? typePlatformRefreshToken
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
      refreshToken: refreshToken??this.refreshToken,
      idInvitation: idInvitation??this.idInvitation,
        isTakeBonus: isTakeBonus??this.isTakeBonus,
      remoteChannel: remoteChannel??this.remoteChannel,
      defaultLanguage: defaultLanguage??this.defaultLanguage,
      typePlatformRefreshToken: typePlatformRefreshToken??this.typePlatformRefreshToken
    );
  }
}