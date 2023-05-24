


  import 'package:googleapis/youtube/v3.dart';

class ChannelModelFromApi{
    final String idUpload;
    final String idChannel;
    final String urlBanner;
    final String title;
    final String description;
    final String videoCount;
    final String viewCount;
    final String subscriberCount;

    ChannelModelFromApi.fromApi({required Channel channel}):
          idChannel=channel.id!,
            idUpload=channel.contentDetails!.relatedPlaylists!.uploads!,
        urlBanner=channel.snippet!.thumbnails!.medium!.url!,
        title=channel.snippet!.title!,
          description=channel.snippet!.description!,
          videoCount=channel.statistics!.videoCount!,
       viewCount=channel.statistics!.viewCount!,
            subscriberCount=channel.statistics!.subscriberCount!;
            //channel.snippet.defaultLanguage;

}