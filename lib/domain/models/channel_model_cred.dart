

 import '../../data/models/hive_models/cred_channel.dart';

class ChannelModelCred{

  final String nameChannel;
  final String imgBanner;
  final String accountName;
  final String idUpload;

  const ChannelModelCred({
    required this.nameChannel,
    required this.imgBanner,
    required this.accountName,
    required this.idUpload
  });


  static ChannelModelCred fromBoxHive({required CredChannel channel}){
    return ChannelModelCred(nameChannel: channel.nameChannel, imgBanner: channel.imgBanner, accountName: channel.accountName, idUpload: channel.idUpload);
  }
}