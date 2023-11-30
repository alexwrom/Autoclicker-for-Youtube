

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            Row(
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

                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60,right: 15),
              child: GestureDetector(
                onTap: (){
                  onDelete.call(index);
                },
                  child: const Icon(Icons.delete_outline,color: Colors.grey)),
            )
          ],
        ),
      ),
    );
  }



}