


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
     //on<TakeBonusEvent>(_takeBonus,transformer: droppable());
     on<AddOrRemoveRemoteChannelEvent>(_addOrRemoveRemoteChannel,transformer: droppable());
     on<UpdateChannelListEvent>(_updateChannelList);
     on<UpdateBonusEvent>(_updateBonus);
     //on<UpdateBalanceEvent>(_updateBalance);
  }


  void _updateChannelList(UpdateChannelListEvent event,emit) async {
    if(event.channelModelCred.bonus>0){
      int totalBonus = 0;
      int bonusOfRemoteChannel = event.channelModelCred.bonus;
      int numberTranslate = event.translateQuantity;
      final res = bonusOfRemoteChannel - numberTranslate;
      if(res<0){
        totalBonus = 0;
      }else {
        totalBonus = res;
      }
      ChannelModelCred channel = event.channelModelCred;
      channel = channel.copyWith(bonus:totalBonus);
      _updateLocalChannels(channel);
    }
  }


  // void _updateBalance(UpdateBalanceEvent event,emit) async {
  //    print('Update Balance');
  // }

  void _updateBonus(UpdateBonusEvent event,emit) async {
    emit(state.copyWith(mainStatus: MainStatus.loading,isChannelDeactivation:true));
    if(event.channelModelCred.refreshToken.isEmpty){
      emit(state.copyWith(mainStatus: MainStatus.success));
      return;
    }
    final listNew = await _updateLocalChannels(event.channelModelCred);
    emit(state.copyWith(listCredChannels: listNew,mainStatus: MainStatus.success));

  }



  Future<void> _addOrRemoveRemoteChannel(AddOrRemoveRemoteChannelEvent event, emit) async {
    try{
      emit(state.copyWith(statusAddRemoteChannel: StatusAddRemoteChannel.loading));
      if(event.remove){
        await userRepository.removeChannelFromAccount(idChannel: event.channelModelCred.idChannel);
        ChannelModelCred channel = event.channelModelCred;
        channel = channel.copyWith(remoteChannel: false,bonus:event.channelModelCred.bonus);
        _updateLocalChannels(channel);
      }else{
       final bonus =  await userRepository.addRemoteChannel(idChannel: event.channelModelCred.idChannel);
       ChannelModelCred channel = event.channelModelCred;
       channel = channel.copyWith(remoteChannel: true, bonus: bonus);
       _updateLocalChannels(channel);
      }
      emit(state.copyWith(statusAddRemoteChannel: StatusAddRemoteChannel.success));

    }on Failure catch(e){
      emit(state.copyWith(statusAddRemoteChannel: StatusAddRemoteChannel.error,error: e.message));
    }
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

//  void _takeBonus(TakeBonusEvent event, emit) async {
//    emit(state.copyWith(mainStatus: MainStatus.loading));
//    UserData userData = _cubitUser.state.userData;
//    int transQuantity = userData.numberOfTrans + 400;
//    userData = userData.copyWith(numberOfTrans: transQuantity);
//    _cubitUser.updateUser(userData: userData);
//    await Future.delayed(const Duration(seconds: 1));
//    await userRepository.takeBonusChannel(idChannel: event.channelModelCred.idChannel,
//        newBalance:transQuantity);
//    ChannelModelCred channelModelCred = event.channelModelCred;
//    channelModelCred = channelModelCred.copyWith(bonus: 0);
//    final listChannelsUpdated = await _updateLocalChannels(channelModelCred);
//    emit(state.copyWith(mainStatus: MainStatus.success,listCredChannels: listChannelsUpdated));
// }

  Future<void> _getListCredChannel(GetChannelEvent event,emit)async{
    emit(state.copyWith(mainStatus: MainStatus.loading,isChannelDeactivation:true));
    try {
      listCredChannels.clear();
      final blockedAccount = event.user.isBlock==1;
      final name= PreferencesUtil.getUserName;
      boxCredChannel.keys.map((key) {
            CredChannel value = boxCredChannel.get(key);
            listCredChannels.add(ChannelModelCred.fromBoxHive(channel: value));
          }).toList();

      if(event.user.channels.isEmpty){
        print('Empty');
        if (listCredChannels.isEmpty) {
          emit(state.copyWith(
              mainStatus: MainStatus.empty,
              userName: name,
              urlAvatar: '',
              blockedAccount: blockedAccount));
        } else {
          await _checkListChannelByLocal();
          final listFiltered=await _checkListChanelByInvitation(listCredChannels);
          final isActivatedChannel=await _checkActivatedChanelByInvitation(listCredFiltered: listFiltered,
              listCredOld: listCredChannels);
          if(!isActivatedChannel){
            listCredChannels=listFiltered;
          }
          final listChannelsResult = await _checkBonusInRemoteChannel(channels: listCredChannels);
          emit(state.copyWith(
              mainStatus: MainStatus.success,
              listCredChannels: listChannelsResult,
              userName: name,
              urlAvatar: '',
              blockedAccount: blockedAccount,
              isChannelDeactivation: isActivatedChannel));
        }
      }else{
        print('NOtEmpty');
         List<String> idsChannels = [];
        _checkListChannelByRemote(event);
         for(var channel in listCredChannels){
            idsChannels.add(channel.idChannel);
         }
         for (String element in event.user.channels) {
           if(!idsChannels.contains(element)){
             ChannelModelCred channel = await _googleApiRepository.addRemoteChannelByRefreshToken(idChannel: element);
             int key = await _saveLocalChannel(channel);
             channel = channel.copyWith(keyLangCode: key,remoteChannel: true);
             listCredChannels.add(channel);
           }
         }

         final listFiltered=await _checkListChanelByInvitation(listCredChannels);
        final isActivatedChannel=await _checkActivatedChanelByInvitation(listCredFiltered: listFiltered,
            listCredOld: listCredChannels);
        if(!isActivatedChannel){
          listCredChannels=listFiltered;
        }

        final listChannelsResult = await _checkBonusInRemoteChannel(channels: listCredChannels);

         emit(state.copyWith(
             mainStatus: MainStatus.success,
             listCredChannels: listChannelsResult,
             userName: name,
             urlAvatar: '',
             blockedAccount: blockedAccount,
             isChannelDeactivation: isActivatedChannel));
      }


    }on Failure catch (e) {

      emit(state.copyWith(mainStatus: MainStatus.error,error: e.message));
    }


  }

  Future<void> _checkListChannelByLocal() async {
    for(var channel in listCredChannels){
         channel = channel.copyWith(remoteChannel: false);
        _updateLocalChannels(channel);

    }

  }

  Future<void> _checkListChannelByRemote(GetChannelEvent event) async {
    for(var channel in listCredChannels){
      if(event.user.channels.contains(channel.idChannel)){
        channel = channel.copyWith(remoteChannel: true);
        _updateLocalChannels(channel);
      }
    }

  }

  Future<List<ChannelModelCred>> _checkBonusInRemoteChannel(
      {required List<ChannelModelCred> channels}) async {
    List<ChannelModelCred> listResult = [];
    List<String> idsCheck = [];

    for(var channel in channels){
      if(channel.idInvitation.isEmpty){
        idsCheck.add(channel.idChannel);
      }
    }

    if(idsCheck.isEmpty){
      listResult = channels;
    }else{
      for(String id in idsCheck){
        final bonus = await _googleApiRepository.getBonusOfRemoteChannel(idChannel: id);
        if(bonus>0){
          ChannelModelCred channelUpdated = listCredChannels.firstWhere((element) => element.idChannel == id);
          channelUpdated = channelUpdated.copyWith(bonus: bonus);
          listResult = await _updateLocalChannels(channelUpdated);
        }else{
          listResult = channels;
        }

      }
    }


    return listResult;
  }

  Future<List<ChannelModelCred>> _updateLocalChannels(ChannelModelCred channel) async {
    int index = listCredChannels.indexWhere((element) => element.idChannel==channel.idChannel);
    await boxCredChannel.put(channel.keyLangCode, CredChannel(
        bonus: channel.bonus,
        typePlatformRefreshToken:  typeRefreshToken(typePlatformRefreshToken:
        channel.typePlatformRefreshToken),
        refreshToken: channel.refreshToken,
        keyLangCode: channel.keyLangCode,
        idChannel: channel.idChannel,
        nameChannel: channel.nameChannel,
        imgBanner: channel.imgBanner,
        accountName: channel.accountName,
        idUpload: channel.idUpload,
        idToken: channel.idToken,
        accessToken: channel.accessToken,
        remoteChannel: channel.remoteChannel,
        idInvitation: channel.idInvitation,
        defaultLanguage: channel.defaultLanguage));
   listCredChannels[index] = channel;
   return listCredChannels;
  }

  Future<int> _saveLocalChannel(ChannelModelCred channel) async {
     final key= await boxVideo.add(ChannelLangCode(id: channel.idChannel, codeLanguage: [])).catchError((error) {
      throw const Failure('Error while saving locally...');
    });
    await boxCredChannel
        .add(CredChannel(
        bonus: channel.bonus,
        typePlatformRefreshToken:  typeRefreshToken(typePlatformRefreshToken:
        channel.typePlatformRefreshToken),
        refreshToken: channel.refreshToken,
        keyLangCode: key,
        idChannel: channel.idChannel,
        nameChannel: channel.nameChannel,
        imgBanner: channel.imgBanner,
        accountName: channel.accountName,
        idUpload: channel.idUpload,
        idToken: channel.idToken,
        accessToken: channel.accessToken,
        remoteChannel: channel.remoteChannel,
        idInvitation: channel.idInvitation,
        defaultLanguage: channel.defaultLanguage))
        .catchError((error) {
      throw const Failure('Error while saving locally..');
    });
    return key;
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
      int key = await _saveLocalChannel(result);

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
      int key = await _saveLocalChannel(result);

      listCredChannels.add(result.copyWith(keyLangCode: key));
      emit(state.copyWith(mainStatus:MainStatus.success,addCredStatus: AddCredStatus.success,listCredChannels: listCredChannels));
    }on Failure catch (error){
      emit(state.copyWith(addCredStatus: AddCredStatus.error,error: error.message));
    }

  }


  Future<void> _removeChannel(RemoveChannelEvent event,emit)async{
   emit(state.copyWith(addCredStatus: AddCredStatus.removal));
   await Future.delayed(const Duration(seconds: 2));
   UserData userData = _cubitUser.state.userData;
   await boxCredChannel.delete(event.keyHive).catchError((e){
     emit(state.copyWith(addCredStatus: AddCredStatus.errorRemove,error: 'Сhannel delete error'));
   });
   await boxVideo.delete(event.keyHive).catchError((e){
     emit(state.copyWith(addCredStatus: AddCredStatus.errorRemove,error: 'Сhannel delete error'));
   });
   if(userData.channels.contains( listCredChannels[event.index].idChannel)){
     await userRepository.removeChannelFromAccount(idChannel: listCredChannels[event.index].idChannel);
   }

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