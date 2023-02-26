

   import 'package:googleapis/youtube/v3.dart';

class AllVideoModelFromApi{
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
     final String status;
     final String categoryId;
     final String defaultLanguage;


      AllVideoModelFromApi.fromApi({required Video video}):
            categoryId=video.snippet!.categoryId??'',
            defaultLanguage=video.snippet!.defaultLanguage??'',
         idVideo=video.id??'',
          idChannel=video.snippet!.channelId??'',
         title=video.snippet!.title??'',
           description=video.snippet!.description??'',
           urlBanner=video.snippet!.thumbnails!.medium!.url??'',
           urlBannerMax=video.snippet!.thumbnails!.standard!.url??'',
           videoPublishedAt=video.snippet!.publishedAt.toString(),
           channelTitle=video.snippet!.channelTitle??'',
           duration=video.contentDetails!.duration??'',
            viewCount=video.statistics!.viewCount??'',
            likeCount=video.statistics!.likeCount??'',
            commentCount=video.statistics!.commentCount??'',
            status=video.status!.privacyStatus??'';

}


  extension AllVideoModelFromApiExt on AllVideoModelFromApi{
     bool get isPublic=>status!='unlisted';
  }


