

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
           categoryId=video.snippet==null?'':video.snippet!.categoryId??'',
            defaultLanguage=video.snippet==null?'':video.snippet!.defaultLanguage??'',
           idVideo=video.snippet==null?'':video.id??'',
          idChannel=video.snippet==null?'':video.snippet!.channelId??'',
         title=video.snippet==null?'':video.snippet!.title??'',
           description=video.snippet==null?'':video.snippet!.description??'',
           urlBanner=video.snippet==null?'':video.snippet!.thumbnails!.medium!.url??'',
           urlBannerMax=video.snippet==null?'':video.snippet!.thumbnails!.standard!.url??'',
           videoPublishedAt=video.snippet==null?'':video.snippet!.publishedAt.toString(),
           channelTitle=video.snippet==null?'':video.snippet!.channelTitle??'',
           duration=video.contentDetails==null?'':video.contentDetails!.duration??'',
            viewCount=video.statistics==null?'':video.statistics!.viewCount??'',
            likeCount=video.statistics==null?'':video.statistics!.likeCount??'',
            commentCount=video.statistics==null?'':video.statistics!.commentCount??'',
            status=video.status==null?'':video.status!.privacyStatus??'';

}


  extension AllVideoModelFromApiExt on AllVideoModelFromApi{
     bool get isPublic=>status!='unlisted';
  }


