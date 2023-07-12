



  import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clicker/domain/models/channel_model.dart';

import '../../../components/dialoger.dart';
import '../../../domain/models/channel_model_cred.dart';
import '../../../resourses/colors_app.dart';
import '../video_list_page.dart';



class ItemChannel extends StatelessWidget{
  const ItemChannel({super.key,required this.channelModel});

   final ChannelModel channelModel;



  @override
  Widget build(BuildContext context) {
   return GestureDetector(
     onTap: (){
       // if(int.parse(channelModel.videoCount)>0){
       //   Navigator.push(context, MaterialPageRoute(builder: (_)=> VideoListPage(channelModel: channelModel)));
       // }else{
       //   Dialoger.showMessageSnackBar('There are no videos on the channel',context);
       // }

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
            ClipRRect(
              borderRadius:const BorderRadius.only(topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20)),
              child: CachedNetworkImage(
                  placeholder: (context, url) => const Icon(Icons.image_outlined,color: Colors.grey,size: 100),
                  errorWidget: (context, url, error) =>const Icon(Icons.error,color: Colors.grey,size: 60),
                  imageUrl: channelModel.urlBanner, fit: BoxFit.cover,
                  width: 120,
                  height: 130),
            ),

           Padding(
             padding: const EdgeInsets.only(left: 15,top: 15,bottom: 15,right: 15),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  SizedBox(
                    width: 270,
                    child: Text(channelModel.title,
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
                   child: Text(channelModel.description.isEmpty?'Channel description missing....'.tr():channelModel.description,
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
                         Icon(Icons.account_circle_outlined,color: colorRed.withOpacity(0.7),size: 15),
                         const SizedBox(width: 5),
                         Text(channelModel.subscriberCount,
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
                         Text(channelModel.viewCount,
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
                         Icon(Icons.video_collection_rounded,color: colorRed.withOpacity(0.7),size: 15),
                         const SizedBox(width: 5),
                         Text(channelModel.videoCount,
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