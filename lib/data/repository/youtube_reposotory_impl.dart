



  import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:youtube_clicker/domain/models/channel_model.dart';
import 'package:youtube_clicker/domain/repository/youtube_repository.dart';

import '../../di/locator.dart';
import '../../domain/models/channel_model_cred.dart';
import '../../domain/models/video_model.dart';
import '../utils/youtube_api_util.dart';

class YouTubeRepositoryImpl extends YouTubeRepository{

   final _youTubeApi=locator.get<YouTubeApiUtil>();

  @override
  Future<List<ChannelModel>?> getListChanel(bool reload) async{
   return await _youTubeApi.getListChanel(reload);
  }

  @override
  Future<List<VideoModel>> getVideoFromAccount(ChannelModelCred cred) async{
    return await _youTubeApi.getVideoFromAccount(cred);
  }

  @override
  Future<int> updateLocalization(VideoModel videoModel,ChannelModelCred channelModelCred, Map<String, VideoLocalization> map)async {
   return await _youTubeApi.updateLocalization(videoModel, map,channelModelCred);
  }

  @override
  Future<List<Caption>> loadCaptions(String idVideo)async {
    return await _youTubeApi.loadCaptions(idVideo);
  }

  @override
  Future<void> insertCaption({required String idCap, required String idVideo, required String codeLang})async {
   return await _youTubeApi.insertCaption(idCap: idCap, idVideo: idVideo, codeLang: codeLang);
  }

  @override
  Future<void> removeCaptions(String idCap) async{
    await _youTubeApi.removeCaptions(idCap);
  }

  @override
  Future<ChannelModelCred> addChannel()async {
    return await _youTubeApi.addChannel();
  }



}