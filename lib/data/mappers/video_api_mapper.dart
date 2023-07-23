



import 'package:youtube_clicker/domain/models/video_model.dart';

import '../models/video_model_from_api.dart';

class VideoMapper{


    static VideoModel fromApi({required AllVideoModelFromApi videoNotPublishedModelFromApi}){
      return VideoModel(
        defaultAudioLanguage: videoNotPublishedModelFromApi.defaultAudioLanguage,
        categoryId: videoNotPublishedModelFromApi.categoryId,
        defaultLanguage: videoNotPublishedModelFromApi.defaultLanguage,
        urlBannerMax: videoNotPublishedModelFromApi.urlBannerMax,
          isPublic: videoNotPublishedModelFromApi.isPublic,
          idChannel: videoNotPublishedModelFromApi.idChannel,
          idVideo: videoNotPublishedModelFromApi.idVideo,
          title: videoNotPublishedModelFromApi.title,
          description: videoNotPublishedModelFromApi.description,
          urlBanner: videoNotPublishedModelFromApi.urlBanner,
          videoPublishedAt: videoNotPublishedModelFromApi.videoPublishedAt,
          channelTitle: videoNotPublishedModelFromApi.channelTitle,
          duration: videoNotPublishedModelFromApi.duration,
          viewCount: videoNotPublishedModelFromApi.viewCount,
          likeCount: videoNotPublishedModelFromApi.likeCount,
          commentCount: videoNotPublishedModelFromApi.commentCount);

    }


  }