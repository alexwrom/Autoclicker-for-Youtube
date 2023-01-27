



  import 'package:googleapis/youtube/v3.dart';
import 'package:youtube_clicker/domain/models/channel_model.dart';
import 'package:youtube_clicker/domain/repository/youtube_repository.dart';

import '../../di/locator.dart';
import '../../domain/models/video_model.dart';
import '../utils/youtube_api_util.dart';

class YouTubeRepositoryImpl extends YouTubeRepository{

   final _youTubeApi=locator.get<YouTubeApiUtil>();

  @override
  Future<List<ChannelModel>?> getChannels(bool reload) async{
   return await _youTubeApi.getChannels(reload);
  }

  @override
  Future<List<VideoModel>> getVideoFromAccount(String idUpload) async{
    return await _youTubeApi.getVideoFromAccount(idUpload);
  }

  @override
  Future<void> updateLocalization(VideoModel videoModel, Map<String, VideoLocalization> map)async {
   return await _youTubeApi.updateLocalization(videoModel, map);
  }

  @override
  Future<String> loadCaptions(String idVideo)async {
    return await _youTubeApi.loadCaptions(idVideo);
  }

  @override
  Future<void> insertCaption({required String idCap, required String idVideo, required String codeLang})async {
   return await _youTubeApi.insertCaption(idCap: idCap, idVideo: idVideo, codeLang: codeLang);
  }



}