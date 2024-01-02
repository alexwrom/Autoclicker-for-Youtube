

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius:const BorderRadius.only(topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              child: CachedNetworkImage(
                  placeholder: (context, url) => const Icon(Icons.image_outlined,color: Colors.grey,size: 100),
                  errorWidget: (context, url, error) =>const Icon(Icons.error,color: Colors.grey,size: 60),
                  imageUrl: channelModelCred.imgBanner, fit: BoxFit.cover,
                  width: 90.0,
                  height: 90.0),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 230.0),
                        child: Text(channelModelCred.nameChannel,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700
                          ),)
                      ),
                      Visibility(
                        visible: channelModelCred.bonus > 0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: GestureDetector(
                            onTap: (){
                              // Dialoger.showTakeBonus(context:context,
                              //     channelModelCred: channelModelCred);
                            },
                            child: SizedBox(
                              height: 30.0,
                              width: 80.0,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(left: 25.0),
                                    height: 30.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                        color: colorRed,
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child:  Text('${channelModelCred.bonus}',
                                      style:const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700
                                      ),),
                                  ),
                                  Container(
                                      width: 30.0,
                                      height: 30.0,
                                      padding: const EdgeInsets.all(5.0),
                                      decoration:  const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Image.asset(imgPresentBonus)),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Row(
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
                        const SizedBox(width: 10.0),
                        GestureDetector(
                            onTap: (){
                              onDelete.call(index);
                            },
                            child: const Icon(Icons.delete_outline,color: Colors.grey))
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }



}