



  import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:youtube_clicker/domain/models/channel_model.dart';
import 'package:youtube_clicker/domain/repository/youtube_repository.dart';
import 'package:youtube_clicker/presentation/translate_screen/bloc/translate_event.dart';

import '../../di/locator.dart';
import '../../domain/models/channel_model_cred.dart';
import '../../domain/models/video_model.dart';
import '../utils/youtube_api_util.dart';

class YouTubeRepositoryImpl extends YouTubeRepository{

   final _youTubeApiUtil=locator.get<YouTubeApiUtil>();

  // @override
  // Future<List<ChannelModel>?> getListChanel(bool reload) async{
  //  return await _youTubeApiUtil.getListChanel(reload);
  // }

  @override
  Future<List<VideoModel>> getVideoFromAccount(ChannelModelCred cred) async{
    return await _youTubeApiUtil.getVideoFromAccount(cred);
  }

  @override
  Future<int> updateLocalization(VideoModel videoModel,ChannelModelCred channelModelCred, Map<String, VideoLocalization> map)async {
   return await _youTubeApiUtil.updateLocalization(videoModel, map,channelModelCred);
  }

  @override
  Future<List<Caption>> loadCaptions(String idVideo,ChannelModelCred cred)async {
    return await _youTubeApiUtil.loadCaptions(idVideo,cred);
  }

  @override
  Future<bool> insertCaption({required String idCap, required InsertSubtitlesEvent event, required String codeLang, required String defCaptionData})async {
   return await _youTubeApiUtil.insertCaption(idCap: idCap, event: event, codeLang: codeLang, defCaptionData:defCaptionData);
  }

  @override
  Future<bool> removeCaptions(String idCap) async{
   return await _youTubeApiUtil.removeCaptions(idCap);
  }

  @override
  Future<ChannelModelCred> addChannel()async {
    return await _youTubeApiUtil.addChannel();
  }


   @override
   Future<ChannelModelCred> addChannelByCodeInvitation({required String code})async{
     return await _youTubeApiUtil.addChannelByCodeInvitation(code: code);


   }
    @override
   Future<bool> isActivatedChanelByInvitation(String code)async{
    return await _youTubeApiUtil.isActivatedChanelByInvitation(code);
   }

  @override
  Future<ChannelModelCred> addRemoteChannelByRefreshToken({required String idChannel}) async {
    return await _youTubeApiUtil.addRemoteChannelByRefreshToken(idChannel: idChannel);
  }

  @override
  Future<(int,String)> getBonusOfRemoteChannel({required String idChannel}) async {
    return await _youTubeApiUtil.getBonusOfRemoteChannel(idChannel: idChannel);
  }

  @override
  Future<String> updateTokenFromRemote({required String idChannel})  async {
   return await _youTubeApiUtil.updateTokenFromRemote(idChannel:idChannel);
  }





}