


 import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:hive/hive.dart';
import 'package:youtube_clicker/data/models/hive_models/channel_lang_code.dart';
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
  final boxCredChannel=Hive.box('cred_video');
  final boxVideo=Hive.box('video_box');


  MainBloc():super(MainState.unknown()){
     on<GetChannelEvent>(_getListCredChannel);
     on<GetListVideoFromChannelEvent>(_getListVideoFromChannel);
     on<AddChannelEvent>(_addChannel,transformer: droppable());
     on<RemoveChannelEvent>(_removeChannel,transformer: droppable());
  }


  Future<void> _getListCredChannel(GetChannelEvent event,emit)async{
    emit(state.copyWith(mainStatus: MainStatus.loading));
    try {
      listCredChannels.clear();
      final name= PreferencesUtil.getUserName;
      boxCredChannel.keys.map((key) {
            CredChannel value = boxCredChannel.get(key);
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
      final key= await boxVideo.add(ChannelLangCode(id: result.idChannel, codeLanguage: [])).catchError((error) {
        throw const Failure('Error while saving locally...');
      });
      await boxCredChannel
          .add(CredChannel(
               keyLangCode: key,
              idChannel: result.idChannel,
              nameChannel: result.nameChannel,
              imgBanner: result.imgBanner,
              accountName: result.accountName,
              idUpload: result.idUpload,
              idToken: result.idToken,
               accessToken: result.accessToken,
              defaultLanguage: result.defaultLanguage))
          .catchError((error) {
        throw const Failure('Error while saving locally..');
      });

      listCredChannels.add(result.copyWith(keyLangCode: key));
      emit(state.copyWith(mainStatus:MainStatus.success,addCredStatus: AddCredStatus.success,listCredChannels: listCredChannels));
    }on Failure catch (error){
      emit(state.copyWith(addCredStatus: AddCredStatus.error,error: error.message));
    }

  }

  Future<void> _removeChannel(RemoveChannelEvent event,emit)async{
   emit(state.copyWith(addCredStatus: AddCredStatus.removal));
   await Future.delayed(const Duration(seconds: 2));
   await boxCredChannel.delete(event.keyHint).catchError((e){
     emit(state.copyWith(addCredStatus: AddCredStatus.errorRemove,error: 'Сhannel delete error'));
   });
   await boxVideo.delete(event.keyHint).catchError((e){
     emit(state.copyWith(addCredStatus: AddCredStatus.errorRemove,error: 'Сhannel delete error'));
   });
   listCredChannels.removeAt(event.index);
   if(listCredChannels.isEmpty){
     emit(state.copyWith(addCredStatus: AddCredStatus.removed,mainStatus:MainStatus.empty,listCredChannels: listCredChannels));
     return;
   }
   emit(state.copyWith(addCredStatus: AddCredStatus.removed,listCredChannels: listCredChannels));




  }






    Future<void> _getListVideoFromChannel(GetListVideoFromChannelEvent event,emit)async{
       emit(state.copyWith(videoListStatus: VideoListStatus.loading,addCredStatus: AddCredStatus.unknown));
       videoListFromChannel.clear();
       videoListNotPublished.clear();
       allListVideoAccount.clear();
       try {
         final videos = await _googleApiRepository.getVideoFromAccount(event.cred);
         allListVideoAccount = videos;
         if(videos.isEmpty){
           emit(state.copyWith(videoListStatus: VideoListStatus.empty));
           return;
         }
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
         emit(state.copyWith(videoListStatus: VideoListStatus.success,addCredStatus: AddCredStatus.unknown,videoFromChannel: videoListFromChannel));
       }on Failure catch (e) {
         emit(state.copyWith(videoListStatus: VideoListStatus.error,error: e.message));
       }
    }




 }