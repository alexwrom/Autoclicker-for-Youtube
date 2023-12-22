

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clicker/domain/models/user_data.dart';
import 'package:youtube_clicker/resourses/images.dart';

import '../../../components/dialoger.dart';
import '../../../domain/models/channel_model_cred.dart';
import '../../../resourses/colors_app.dart';
import '../video_list_page.dart';

class ItemChannelCred extends StatelessWidget{
  const ItemChannelCred({super.key,required this.channelModelCred,
  required this.onDelete,
    required this.onAction,
  required this.index});


  final ChannelModelCred channelModelCred;
  final Function onDelete;
  final Function onAction;
  final int index;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onAction.call(channelModelCred);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colorPrimary
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:const BorderRadius.only(topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              child: CachedNetworkImage(
                  placeholder: (context, url) => const Icon(Icons.image_outlined,color: Colors.grey,size: 100),
                  errorWidget: (context, url, error) =>const Icon(Icons.error,color: Colors.grey,size: 60),
                  imageUrl: channelModelCred.imgBanner, fit: BoxFit.cover,
                  width: 115,
                  height: 115),
            ),
             const SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: channelModelCred.isTakeBonus == 0?225:
                165.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(channelModelCred.nameChannel,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style:const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                      ),),
                    Text(channelModelCred.accountName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style:const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w400
                      ),),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Visibility(
                    visible: channelModelCred.isTakeBonus == 1,
                    child: GestureDetector(
                      onTap: (){
                        Dialoger.showTakeBonus(context:context,
                        channelModelCred: channelModelCred);
                      },
                      child: Container(
                          width: 60.0,
                          height: 60.0,
                          padding: const EdgeInsets.all(5.0),
                          decoration:  const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Image.asset(imgPresentBonus)),
                    ),
                  ),
                ),
                const SizedBox(width: 15.0),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0,right: 10.0),
                  child: Column(
                    children: [
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorBackground
                        ),
                        child: Icon(!channelModelCred.remoteChannel?Icons.smartphone:
                        Icons.public,color: Colors.white),
                      ),
                      const SizedBox(height: 10.0),
                      GestureDetector(
                          onTap: (){
                            onDelete.call(index);
                          },
                          child: const Icon(Icons.delete_outline,color: Colors.grey))
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }



}