

import 'package:equatable/equatable.dart';

import '../../../domain/models/channel_model.dart';
import '../../../domain/models/channel_model_cred.dart';
import '../../../domain/models/video_model.dart';

enum MainStatus{
  unknown,
  error,
  loading,
  success,
  empty
}

enum VideoListStatus{
  unknown,
  error,
  loading,
  success,
  empty
}



enum AddCredStatus{
  unknown,
  error,
  loading,
  success,
  empty,
  removed,
  removal,
  errorRemove
}


extension AddCredStatusExt on AddCredStatus{
  bool get isUnknown=>this==AddCredStatus.unknown;
  bool get isError=>this==AddCredStatus.error;
  bool get isLoading=>this==AddCredStatus.loading;
  bool get isSuccess=>this==AddCredStatus.success;
  bool get isEmpty=>this==AddCredStatus.empty;
  bool get isErrorRemove=>this==AddCredStatus.errorRemove;
  bool get isRemoval=>this==AddCredStatus.removal;
  bool get isRemoved=>this==AddCredStatus.removed;

}

extension VideoListStatusExt on VideoListStatus{
  bool get isUnknown=>this==VideoListStatus.unknown;
  bool get isError=>this==VideoListStatus.error;
  bool get isLoading=>this==VideoListStatus.loading;
  bool get isSuccess=>this==VideoListStatus.success;
  bool get isEmpty=>this==VideoListStatus.empty;

}

  extension AuthStatusExt on MainStatus{
     bool get isUnknown=>this==MainStatus.unknown;
     bool get isError=>this==MainStatus.error;
     bool get isLoading=>this==MainStatus.loading;
     bool get isSuccess=>this==MainStatus.success;
     bool get isEmpty=>this==MainStatus.empty;

  }

 class MainState extends Equatable{

   final MainStatus mainStatus;
   final AddCredStatus addCredStatus;
   final VideoListStatus videoListStatus;
   final List<ChannelModel> channelList;
   final List<VideoModel> videoNotPubList;
   final List<VideoModel> videoFromChannel;
   final List<ChannelModelCred> listCredChannels;
   final String error;
   final String userName;
   final String urlAvatar;
   final bool isChannelDeactivation;


   const MainState(
      this.videoListStatus,
      this.listCredChannels,
      this.mainStatus,
      this.addCredStatus,
      this.channelList,
      this.error,
      this.userName,
      this.urlAvatar,
      this.videoNotPubList,
      this.videoFromChannel,
       this.isChannelDeactivation);

  factory MainState.unknown(){
     return const MainState(VideoListStatus.unknown,[],MainStatus.unknown,AddCredStatus.unknown, [],'','','',[],[],true);
   }



  @override

  List<Object?> get props =>
      [
        videoListStatus,
        listCredChannels,
        mainStatus,
        addCredStatus,
        channelList,
        error,
        userName,
        urlAvatar,
        videoNotPubList,
        videoFromChannel,
        isChannelDeactivation
      ];

  MainState copyWith({
     VideoListStatus? videoListStatus,
     List<ChannelModelCred>? listCredChannels,
    MainStatus? mainStatus,
     AddCredStatus? addCredStatus,
    List<ChannelModel>? channelList,
    String? error,
      String? userName,
      String? urlAvatar,
     List<VideoModel>? videoNotPubList,
     List<VideoModel>? videoFromChannel,
    bool? isChannelDeactivation
  }) {
    return MainState(
      videoListStatus??this.videoListStatus,
      listCredChannels??this.listCredChannels,
      mainStatus?? this.mainStatus,
      addCredStatus??this.addCredStatus,
      channelList ?? this.channelList,
      error?? this.error,
      userName??this.userName,
      urlAvatar??this.urlAvatar,
      videoNotPubList??this.videoNotPubList,
      videoFromChannel??this.videoFromChannel,
        isChannelDeactivation??this.isChannelDeactivation
    );
  }
}