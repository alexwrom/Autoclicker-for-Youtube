


  import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';

import '../models/channel_model.dart';
import '../models/video_model.dart';

abstract class YouTubeRepository{



    Future<List<ChannelModel>?> getChannels(bool reload);
    Future<List<VideoModel>> getVideoFromAccount(String idUpload);
    Future<int> updateLocalization(VideoModel videoModel,Map<String,VideoLocalization> map);
    Future<List<Caption>> loadCaptions(String idVideo);
    Future<void> insertCaption({required String idCap,required String idVideo,required String codeLang});
    Future<void> removeCaptions(String idCap);

  }