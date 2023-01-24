


  class VideoChannelModel{

    final String idVideo;
    final String title;
    final String description;
    final String urlBanner;
    final String videoPublishedAt;
    final String duration;
    final String viewCount;
    final String likeCount;
    final String commentCount;


    const VideoChannelModel({
      required this.duration,
      required this.viewCount,
      required this.likeCount,
      required this.commentCount,
    required this.idVideo,
    required this.title,
    required this.description,
    required this.urlBanner,
    required this.videoPublishedAt,
  });
}