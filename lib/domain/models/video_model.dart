

 class VideoModel{
   final String idVideo;
   final String idChannel;
   final String title;
   final String description;
   final String urlBanner;
   final String urlBannerMax;
   final String videoPublishedAt;
   final String channelTitle;
   final String duration;
   final String viewCount;
   final String likeCount;
   final String commentCount;
   final bool isPublic;
   final String categoryId;
   final String defaultLanguage;

   const VideoModel({
     required this.categoryId,
     required this.defaultLanguage,
     required this.urlBannerMax,
     required this.isPublic,
     required this.duration,
     required this.viewCount,
     required this.likeCount,
     required this.commentCount,
    required this.idVideo,
     required this.idChannel,
    required this.title,
    required this.description,
    required this.urlBanner,
    required this.videoPublishedAt,
    required this.channelTitle,
  });
}