


 import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:youtube_clicker/data/services/youtube_api_service.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/domain/repository/youtube_repository.dart';
import 'package:youtube_clicker/utils/failure.dart';
import 'package:youtube_clicker/utils/preferences_util.dart';

import '../../../data/models/hive_models/cred_channel.dart';
import '../../../domain/models/channel_model_cred.dart';
import '../../../domain/models/video_model.dart';
import 'main_event.dart';
import 'main_state.dart';

class MainBloc extends Bloc<MainEvent,MainState>{

  final _googleApiRepository=locator.get<YouTubeRepository>();
  List<VideoModel> videoListNotPublished=[];
  List<VideoModel> videoListFromChannel=[];
  List<VideoModel> allListVideoAccount=[];
  List<ChannelModelCred> listCredChannels=[];
  final boxCredVideo=Hive.box('cred_video');


  MainBloc():super(MainState.unknown()){
     on<GetChannelEvent>(_getListCredChannel);
     on<GetListVideoFromChannelEvent>(_getListVideoFromChannel);
     on<AddChannelEvent>(_addChannel,transformer: droppable());
  }


  Future<void> _getListCredChannel(GetChannelEvent event,emit)async{
    emit(state.copyWith(mainStatus: MainStatus.loading));
    try {
      final name= PreferencesUtil.getUserName;
      boxCredVideo.keys.map((key) {
            CredChannel value = boxCredVideo.get(key);
            listCredChannels.add(ChannelModelCred.fromBoxHive(channel: value));
          }).toList();
      if(listCredChannels.isEmpty){
            emit(state.copyWith(mainStatus: MainStatus.empty, userName: name, urlAvatar: ''));
          }else{
            emit(state.copyWith(
                mainStatus: MainStatus.success,
                listCredChannels: listCredChannels,
                userName: name,
                urlAvatar: ''));
          }
    }on Failure catch (e) {
      emit(state.copyWith(mainStatus: MainStatus.error,error: e.message));
    }


  }



  Future<void> _addChannel(AddChannelEvent event,emit)async{
    emit(state.copyWith(addCredStatus: AddCredStatus.loading));
    try{
      final result=await _googleApiRepository.addChannel();
     final exists= listCredChannels.where((element) => element.idUpload==result.idUpload);
      if(exists.isNotEmpty){
        throw const Failure('Сhannel already added');
      }
      await boxCredVideo
          .add(CredChannel(
              idChannel: result.idChannel,
              nameChannel: result.nameChannel,
              imgBanner: result.imgBanner,
              accountName: result.accountName,
              idUpload: result.idUpload,
              idToken: result.idToken,
               accessToken: result.accessToken,
                googleSignInAcc: result.googleSignInAcc))
          .catchError((error) {
        print('Error hive $error');
        throw const Failure('Error while saving locally');
      });
      listCredChannels.add(result);
      emit(state.copyWith(mainStatus:MainStatus.success,addCredStatus: AddCredStatus.success,listCredChannels: listCredChannels));
    }on Failure catch (error){
      emit(state.copyWith(addCredStatus: AddCredStatus.error,error: error.message));
    }

  }




   Future<void> _getChannel(GetChannelEvent event,emit)async{
    // videoListNotPublished.clear();
    //   videoListFromChannel.clear();
    //   allListVideoAccount.clear();
    //  emit(state.copyWith(mainStatus: MainStatus.loading));
    //  try{
    //
    //    final result=await _googleApiRepository.getListChanel(true);
    //    final name= PreferencesUtil.getUserName;
    //    final avatar=PreferencesUtil.getUrlAvatar;
    //    if(result!.isEmpty){
    //      emit(state.copyWith(mainStatus: MainStatus.empty, userName: name, urlAvatar: avatar));
    //    }else{
    //
    //     final videos = await _googleApiRepository.getVideoFromAccount(result[0].idUpload);
    //
    //     allListVideoAccount = videos;
    //     for (var item in videos) {
    //
    //       if (!item.isPublic) {
    //         videoListNotPublished.add(item);
    //       }
    //     }
    //
    //     emit(state.copyWith(
    //         mainStatus: MainStatus.success,
    //         channelList: result,
    //         userName: name,
    //         urlAvatar: avatar,
    //         videoNotPubList: videoListNotPublished));
    //   }
    //
    // }on Failure catch(error){
    //    emit(state.copyWith(mainStatus: MainStatus.error,error: error.message));
    //  }

   }




    Future<void> _getListVideoFromChannel(GetListVideoFromChannelEvent event,emit)async{
       emit(state.copyWith(videoListStatus: VideoListStatus.loading));
       videoListFromChannel.clear();
       videoListNotPublished.clear();
       allListVideoAccount.clear();
       try {
         final videos = await _googleApiRepository.getVideoFromAccount(event.cred);
         allListVideoAccount = videos;
         for (var item in videos) {
                  if (!item.isPublic) {
                    videoListNotPublished.add(item);
                  }
                }
         for(var item in allListVideoAccount){
                 if(item.isPublic&&event.cred.idChannel==item.idChannel){
                   videoListFromChannel.add(item);
                 }
               }
         emit(state.copyWith(videoListStatus: VideoListStatus.success,videoFromChannel: videoListFromChannel));
       }on Failure catch (e) {
         emit(state.copyWith(videoListStatus: VideoListStatus.error,error: e.message));
       }
    }




 }