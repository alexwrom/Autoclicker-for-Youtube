


  import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clicker/utils/parse_time_duration.dart';

import '../../../domain/models/channel_model_cred.dart';
import '../../../domain/models/video_model.dart';
import '../../../resourses/colors_app.dart';
import '../../translate_screen/translate_page.dart';

class ItemNotPubVideo extends StatelessWidget{
  const ItemNotPubVideo({super.key,required this.videoNotPublished,required this.credChannel});

  final VideoModel videoNotPublished;
  final ChannelModelCred credChannel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        //start play
        Navigator.push(context, MaterialPageRoute(builder: (_)=>TranslatePage(videoModel: videoNotPublished,credChannel: credChannel)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colorPrimary
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:const BorderRadius.only(topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  child: CachedNetworkImage(
                      placeholder: (context, url) => const Icon(Icons.image_outlined,color: Colors.grey,size: 100),
                      errorWidget: (context, url, error) =>const Icon(Icons.error,color: Colors.grey,size: 60),
                      imageUrl: videoNotPublished.urlBanner, fit: BoxFit.cover,
                      width: 120,
                      height: 130),
                ),

                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding:const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(ParseTimeDuration.toStringTimeVideo(videoNotPublished.duration),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700
                      ),),
                  ),
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15,top: 15,bottom: 15,right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 270,
                    child: Text(videoNotPublished.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                      ),),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 270,
                    height: 35,
                    child: Text(videoNotPublished.description.isEmpty?'Video description missing....':videoNotPublished.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style:const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w400
                      ),),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.recommend_outlined,color: colorRed.withOpacity(0.7),size: 15),
                          const SizedBox(width: 5),
                          Text(videoNotPublished.likeCount,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style:const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w700
                            ),),
                        ],
                      ),
                      const SizedBox(width: 30),
                      Row(
                        children: [
                          Icon(Icons.remove_red_eye_outlined,color: colorRed.withOpacity(0.7),size: 15),
                          const SizedBox(width: 5),
                          Text(videoNotPublished.viewCount,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style:const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w700
                            ),),

                        ],
                      ),

                      const SizedBox(width: 30),
                      Row(
                        children: [
                          Icon(Icons.mode_comment_outlined,color: colorRed.withOpacity(0.7),size: 15),
                          const SizedBox(width: 5),
                          Text(videoNotPublished.commentCount,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w700
                            ),),

                        ],
                      )
                    ],
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );

  }


  }