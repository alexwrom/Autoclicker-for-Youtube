

import 'package:equatable/equatable.dart';

import '../../../domain/models/channel_model.dart';
import '../../../domain/models/video_model.dart';

enum MainStatus{
  unknown,
  error,
  loading,
  success
}

  extension AuthStatusExt on MainStatus{
     bool get isUnknown=>this==MainStatus.unknown;
     bool get isError=>this==MainStatus.error;
     bool get isLoading=>this==MainStatus.loading;
     bool get isSuccess=>this==MainStatus.success;

  }

 class MainState extends Equatable{

   final MainStatus mainStatus;
   final List<ChannelModel> channelList;
   final List<VideoModel> videoNotPubList;
   final List<VideoModel> videoFromChannel;
   final String error;
   final String userName;
   final String urlAvatar;


   const MainState(this.mainStatus, this.channelList,this.error,this.userName,this.urlAvatar,this.videoNotPubList,this.videoFromChannel);


   factory MainState.unknown(){
     return const MainState(MainStatus.unknown, [],'','','',[],[]);
   }



  @override

  List<Object?> get props => [mainStatus,channelList,error,userName,urlAvatar,videoNotPubList,videoFromChannel];

   MainState copyWith({
    MainStatus? mainStatus,
    List<ChannelModel>? channelList,
    String? error,
      String? userName,
      String? urlAvatar,
     List<VideoModel>? videoNotPubList,
     List<VideoModel>? videoFromChannel
  }) {
    return MainState(
      mainStatus?? this.mainStatus,
      channelList ?? this.channelList,
      error?? this.error,
      userName??this.userName,
      urlAvatar??this.urlAvatar,
      videoNotPubList??this.videoNotPubList,
      videoFromChannel??this.videoFromChannel
    );
  }
}