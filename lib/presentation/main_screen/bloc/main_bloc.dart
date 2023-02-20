


 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clicker/data/services/youtube_api_service.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/domain/repository/youtube_repository.dart';
import 'package:youtube_clicker/utils/failure.dart';
import 'package:youtube_clicker/utils/preferences_util.dart';

import '../../../domain/models/video_model.dart';
import 'main_event.dart';
import 'main_state.dart';

class MainBloc extends Bloc<MainEvent,MainState>{

  final _googleApiRepository=locator.get<YouTubeRepository>();
  List<VideoModel> videoListNotPublished=[];
  List<VideoModel> videoListFromChannel=[];
  List<VideoModel> allListVideoAccount=[];

  MainBloc():super(MainState.unknown()){
     on<GetChannelEvent>(_getChannel);
     on<GetListVideoFromChannelEvent>(_getListVideoFromChannel);
  }




   Future<void> _getChannel(GetChannelEvent event,emit)async{
     String position='Init';
      videoListNotPublished.clear();
      videoListFromChannel.clear();
      allListVideoAccount.clear();
     emit(state.copyWith(mainStatus: MainStatus.loading));
     try{
       position='P1';
       final result=await _googleApiRepository.getChannels(event.reload);
       position='P2';
       final name= PreferencesUtil.getUserName;
       position='P3';
       final avatar=PreferencesUtil.getUrlAvatar;
       position='P4';
       if(result!.isEmpty){
         position='P5';
         emit(state.copyWith(mainStatus: MainStatus.empty, userName: name, urlAvatar: avatar));
       }else{
         position='P6';
        final videos = await _googleApiRepository.getVideoFromAccount(result[0].idUpload);
         position='P7';
        allListVideoAccount = videos;
        for (var item in videos) {
          position='P8';
          if (!item.isPublic) {
            position='P9';
            videoListNotPublished.add(item);
          }
        }
         position='P10';
        emit(state.copyWith(
            mainStatus: MainStatus.success,
            channelList: result,
            userName: name,
            urlAvatar: avatar,
            videoNotPubList: videoListNotPublished));
      }

    }on Failure catch(error){
       emit(state.copyWith(mainStatus: MainStatus.error,error: "${error.message} point $position"));
     }

   }

    Future<void> _getListVideoFromChannel(GetListVideoFromChannelEvent event,emit)async{
      emit(state.copyWith(mainStatus: MainStatus.loading));
      videoListFromChannel.clear();
      for(var item in allListVideoAccount){
        if(item.isPublic&&event.idChannel==item.idChannel){
          videoListFromChannel.add(item);
        }
      }
      emit(state.copyWith(mainStatus: MainStatus.success,videoFromChannel: videoListFromChannel));
    }




 }