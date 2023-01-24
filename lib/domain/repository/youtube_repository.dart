


  import 'package:googleapis/youtube/v3.dart';

import '../models/channel_model.dart';
import '../models/video_model.dart';

abstract class YouTubeRepository{



    Future<List<ChannelModel>?> getChannels(bool reload);
    Future<List<VideoModel>> getVideoFromAccount(String idUpload);
    Future<void> updateLocalization(VideoModel videoModel,Map<String,VideoLocalization> map);

  }