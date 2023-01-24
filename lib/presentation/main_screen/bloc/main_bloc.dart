


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
     emit(state.copyWith(mainStatus: MainStatus.loading));
     try{
       final result=await _googleApiRepository.getChannels(event.reload);
       final name= PreferencesUtil.getUserName;
       final avatar=PreferencesUtil.getUrlAvatar;
      final videos= await _googleApiRepository.getVideoFromAccount(result![0].idUpload);

       allListVideoAccount=videos;
       for(var item in videos){
         if(!item.isPublic){
           videoListNotPublished.add(item);
         }
       }

       emit(state.copyWith(
          mainStatus: MainStatus.success,
          channelList: result,
          userName: name,
          urlAvatar: avatar,
          videoNotPubList: videoListNotPublished));
    }on Failure catch(error){
       emit(state.copyWith(mainStatus: MainStatus.error,error: error.message));
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