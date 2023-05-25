



import 'package:googleapis/youtube/v3.dart';
import 'package:youtube_clicker/data/models/channel_model_from_api.dart';
import 'package:youtube_clicker/data/models/video_model_from_api.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/domain/models/video_model.dart';

import '../../domain/models/channel_model.dart';
import '../../domain/models/channel_model_cred.dart';
import '../mappers/channel_cred_mapper.dart';
import '../mappers/video_api_mapper.dart';
import '../mappers/youtube_api_mapper.dart';
import '../models/channel_cred_from_api.dart';
import '../services/youtube_api_service.dart';

class YouTubeApiUtil{

    final _youTubeApi=locator.get<YouTubeApiService>();


    Future<List<ChannelModel>?> getListChanel(bool reload) async{
      List<ChannelModel>? list=[];
      final result=await _youTubeApi.getListChanel(reload);
      for (var element in result) {
         list.add(YouTubeApiMapper.fromApi(channelModelFromApi:element));
      }

      return list;


    }


    Future<List<VideoModel>> getVideoFromAccount(ChannelModelCred cred)async{
      List<VideoModel> list=[];
     final result= await _youTubeApi.getVideoFromAccount(cred);
      for(var item in result){
        list.add(VideoMapper.fromApi(videoNotPublishedModelFromApi: item));


      }
      return list;

    }

    Future<int> updateLocalization(VideoModel videoModel,Map<String,VideoLocalization> map,ChannelModelCred channelModelCred)async{
      return await _youTubeApi.updateLocalization(videoModel,channelModelCred, map);

    }

    Future<List<Caption>> loadCaptions(String idVideo)async{
      return await _youTubeApi.loadCaptions(idVideo);
    }

    Future<void> insertCaption({required String idCap,required String idVideo,required String codeLang})async{
      return await _youTubeApi.insertCaption(idCap: idCap, idVideo: idVideo, codeLang: codeLang);
    }

    Future<void> removeCaptions(String idCap)async{
      await _youTubeApi.removeCaptions(idCap);
    }

    Future<ChannelModelCred> addChannel()async{
     final channel= await _youTubeApi.addChannel();
     return ChannelCredMapper.fromApi(channelModelCredFromApi: channel);
    }





  }