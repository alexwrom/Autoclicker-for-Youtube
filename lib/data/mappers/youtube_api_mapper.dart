



  import 'package:youtube_clicker/data/models/channel_model_from_api.dart';

import '../../domain/models/channel_model.dart';

class YouTubeApiMapper{


     static ChannelModel fromApi({required ChannelModelFromApi channelModelFromApi}){
       return ChannelModel(
         idChannel: channelModelFromApi.idChannel,
           idUpload: channelModelFromApi.idUpload,
        urlBanner: channelModelFromApi.urlBanner,
        title: channelModelFromApi.title,
        description: channelModelFromApi.description,
        videoCount: channelModelFromApi.videoCount,
        viewCount: channelModelFromApi.viewCount,
        subscriberCount: channelModelFromApi.subscriberCount);
  }



  }