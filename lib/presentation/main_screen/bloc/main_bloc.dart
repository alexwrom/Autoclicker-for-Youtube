


import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:hive/hive.dart';
import 'package:youtube_clicker/data/models/channel_cred_from_api.dart';
import 'package:youtube_clicker/data/models/hive_models/channel_lang_code.dart';
import 'package:youtube_clicker/data/services/youtube_api_service.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/domain/models/user_data.dart';
import 'package:youtube_clicker/domain/repository/user_repository.dart';
import 'package:youtube_clicker/domain/repository/youtube_repository.dart';
import 'package:youtube_clicker/resourses/constants.dart';
import 'package:youtube_clicker/utils/failure.dart';
import 'package:youtube_clicker/utils/preferences_util.dart';

import '../../../data/models/hive_models/cred_channel.dart';
import '../../../domain/models/channel_model_cred.dart';
import '../../../domain/models/video_model.dart';
import '../cubit/user_data_cubit.dart';
import 'main_event.dart';
import 'main_state.dart';

class MainBloc extends Bloc<MainEvent,MainState>{

  final _googleApiRepository=locator.get<YouTubeRepository>();
  final userRepository = locator.get<UserRepository>();
  final UserDataCubit _cubitUser ;
  List<VideoModel> videoListNotPublished=[];
  List<VideoModel> videoListFromChannel=[];
  List<VideoModel> allListVideoAccount=[];
  List<ChannelModelCred> listCredChannels=[];
  final boxCredChannel=Hive.box('cred_video');
  final boxVideo=Hive.box('video_box');


  MainBloc(this._cubitUser):super(MainState.unknown()){
     on<GetChannelEvent>(_getListCredChannel);
     on<GetListVideoFromChannelEvent>(_getListVideoFromChannel);
     on<AddChannelWithGoogleEvent>(_addChannel,transformer: droppable());
     on<AddChannelByInvitationEvent>(_addChannelByCodeInvitation,transformer: droppable());
     on<RemoveChannelEvent>(_removeChannel,transformer: droppable());
     on<BlockAccountEvent>(_blockAccountUser);
  }



  Future<void> _blockAccountUser(BlockAccountEvent event,emit) async {

    try{
      emit(state.copyWith(statusBlockAccount: StatusBlockAccount.loading));
      await userRepository.blockAccountUser(unlock: event.unlock);
      _updateUser(event);
      emit(state.copyWith(statusBlockAccount: StatusBlockAccount.success,blockedAccount: !event.unlock));

    }on Failure catch(e){
      emit(state.copyWith(statusBlockAccount: StatusBlockAccount.error,error: e.message));
    }
  }

  void _updateUser(BlockAccountEvent event) {
     UserData userData = _cubitUser.state.userData;
    userData = userData.copyWith(isBlock:event.unlock?0:1);
    _cubitUser.updateUser(userData: userData);
  }



  Future<void> _getListCredChannel(GetChannelEvent event,emit)async{
    emit(state.copyWith(mainStatus: MainStatus.loading));
    try {
      listCredChannels.clear();
      final blockedAccount = event.user.isBlock==1;
      final name= PreferencesUtil.getUserName;
      boxCredChannel.keys.map((key) {
            CredChannel value = boxCredChannel.get(key);
            listCredChannels.add(ChannelModelCred.fromBoxHive(channel: value));
          }).toList();
      if (listCredChannels.isEmpty) {
        emit(state.copyWith(
            mainStatus: MainStatus.empty, userName: name, urlAvatar: '',blockedAccount: blockedAccount));
      } else {
        final listFiltered=await _checkListChanelByInvitation(listCredChannels);
       final isActivatedChannel=await _checkActivatedChanelByInvitation(listCredFiltered: listFiltered,
       listCredOld: listCredChannels);
       if(!isActivatedChannel){
         listCredChannels=listFiltered;
       }
       emit(state.copyWith(
            mainStatus: MainStatus.success,
            listCredChannels: listCredChannels,
            userName: name,
            urlAvatar: '',
           blockedAccount: blockedAccount,
            isChannelDeactivation:isActivatedChannel));
          }
    }on Failure catch (e) {
      emit(state.copyWith(mainStatus: MainStatus.error,error: e.message));
    }


  }

  Future<void> _addChannelByCodeInvitation(AddChannelByInvitationEvent event,emit)async{
    emit(state.copyWith(addCredStatus: AddCredStatus.loading));
    try{
      if(event.codeInvitation.isEmpty){
        throw const Failure('Enter the invitation code');

      }
      final result=await _googleApiRepository.addChannelByCodeInvitation(code: event.codeInvitation);
      final exists= listCredChannels.where((element) => element.idUpload==result.idUpload);
      if(exists.isNotEmpty){
        throw const Failure('Сhannel already added');
      }
      final key= await boxVideo.add(ChannelLangCode(id: result.idChannel, codeLanguage: [])).catchError((error) {
        throw const Failure('Error while saving locally...');
      });
      await boxCredChannel
          .add(CredChannel(
          typePlatformRefreshToken: typeRefreshToken(
                  typePlatformRefreshToken: result.typePlatformRefreshToken),
              refreshToken: result.refreshToken,
          keyLangCode: key,
          idChannel: result.idChannel,
          nameChannel: result.nameChannel,
          imgBanner: result.imgBanner,
          accountName: result.accountName,
          idUpload: result.idUpload,
          idToken: result.idToken,
          accessToken: result.accessToken,
          idInvitation: result.idInvitation,
          defaultLanguage: result.defaultLanguage))
          .catchError((error) {
        throw const Failure('Error while saving locally..');
      });

      listCredChannels.add(result.copyWith(keyLangCode: key));
      emit(state.copyWith(
          mainStatus: MainStatus.success,
          addCredStatus: AddCredStatus.success,
          listCredChannels: listCredChannels));
    }on Failure catch (error){
      emit(state.copyWith(addCredStatus: AddCredStatus.error,error: error.message));
    }

  }

  String typeRefreshToken(
      {required TypePlatformRefreshToken typePlatformRefreshToken}) {
    switch (typePlatformRefreshToken) {
      case TypePlatformRefreshToken.ios:
        return iosPlatform;
      case TypePlatformRefreshToken.android:
        return androidPlatform;
      case TypePlatformRefreshToken.desktop:
        return desktopPlatform;
    }
  }



  Future<void> _addChannel(AddChannelWithGoogleEvent event,emit)async{
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
        typePlatformRefreshToken:  typeRefreshToken(typePlatformRefreshToken:
        result.typePlatformRefreshToken),
               refreshToken: result.refreshToken,
               keyLangCode: key,
              idChannel: result.idChannel,
              nameChannel: result.nameChannel,
              imgBanner: result.imgBanner,
              accountName: result.accountName,
              idUpload: result.idUpload,
              idToken: result.idToken,
               accessToken: result.accessToken,
              idInvitation: result.idInvitation,
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
   await boxCredChannel.delete(event.keyHive).catchError((e){
     emit(state.copyWith(addCredStatus: AddCredStatus.errorRemove,error: 'Сhannel delete error'));
   });
   await boxVideo.delete(event.keyHive).catchError((e){
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
       try {
         final videos = await _googleApiRepository.getVideoFromAccount(event.cred);
         if(videos.isEmpty){
           emit(state.copyWith(videoListStatus: VideoListStatus.empty));
           return;
         }
         //getVideosIsNotPublished(videos);
         //final listVideo=getVideosFromChannel(videos, event);
         emit(state.copyWith(videoListStatus: VideoListStatus.success,addCredStatus: AddCredStatus.unknown,videoFromChannel: videos));
       }on Failure catch (e) {
         emit(state.copyWith(videoListStatus: VideoListStatus.error,error: e.message));
       }
    }



  List<VideoModel> getVideosFromChannel(List<VideoModel> videos, GetListVideoFromChannelEvent event) {
      List<VideoModel> list=[];
      for(var item in videos){
              if(item.isPublic&&event.cred.idChannel==item.idChannel){
                list.add(item);
              }
            }
      return list;
    }

  List<VideoModel> getVideosIsNotPublished(List<VideoModel> videos) {
    List<VideoModel> list=[];
      for (var item in videos) {
               if (!item.isPublic) {
                 list.add(item);
               }
             }
      return list;
    }

  Future<List<ChannelModelCred>> _checkListChanelByInvitation(List<ChannelModelCred> listCred)async{
    try {

      for(int i=0;i<listCred.length;i++){
            if (listCred[i].idInvitation.isNotEmpty) {
              final result=await _googleApiRepository.isActivatedChanelByInvitation(listCred[i].idInvitation);
              if(!result){
                await boxCredChannel.delete(listCred[i].keyLangCode).catchError((e){
                     throw const Failure('Сhannel delete error');
                });
                await boxVideo.delete(listCred[i].keyLangCode).catchError((e){
                  throw const Failure('Сhannel delete error');
                });
                listCred.remove(listCred[i]);
              }
            }
          }
      return listCred;
    } on Failure catch (e) {
      throw Failure(e.message);
    }


  }

  Future<bool> _checkActivatedChanelByInvitation(
      {required List<ChannelModelCred> listCredOld,
      required List<ChannelModelCred> listCredFiltered}) async {
    return listCredOld.length == listCredFiltered.length;
  }
}