

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/channel_model_cred.dart';
import '../../../resourses/colors_app.dart';
import '../video_list_page.dart';

class ItemChannelCred extends StatelessWidget{
  const ItemChannelCred({super.key,required this.channelModelCred});


  final ChannelModelCred channelModelCred;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=> VideoListPage(channelModelCred: channelModelCred)));
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
                  imageUrl: channelModelCred.imgBanner, fit: BoxFit.cover,
                  width: 100,
                  height: 100),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15,top: 15,bottom: 15,right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 270,
                    child: Text(channelModelCred.nameChannel,
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
                    child: Text(channelModelCred.accountName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style:const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w400
                      ),),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Row(
                      //   children: [
                      //     Icon(Icons.account_circle_outlined,color: colorRed.withOpacity(0.7),size: 15),
                      //     const SizedBox(width: 5),
                      //     Text(channelModel.subscriberCount,
                      //       overflow: TextOverflow.ellipsis,
                      //       maxLines: 2,
                      //       style:const TextStyle(
                      //           color: Colors.grey,
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w700
                      //       ),),
                      //   ],
                      // ),

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