

  class ChannelModel{

    final String idUpload;
    final String idChannel;
    final String urlBanner;
    final String title;
    final String description;
    final String videoCount;
    final String viewCount;
    final String subscriberCount;

    const ChannelModel({
      required this.idChannel,
      required this.idUpload,
    required this.urlBanner,
    required this.title,
    required this.description,
    required this.videoCount,
    required this.viewCount,
    required this.subscriberCount,
  });
}