




import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clicker/presentation/main_screen/bloc/main_bloc.dart';
import 'package:youtube_clicker/presentation/main_screen/bloc/main_event.dart';
import 'package:youtube_clicker/presentation/main_screen/bloc/main_state.dart';
import 'package:youtube_clicker/presentation/main_screen/widgets/item_video.dart';

import '../../domain/models/channel_model.dart';
import '../../resourses/colors_app.dart';

class VideoListPage extends StatefulWidget{
  const VideoListPage({super.key,required this.channelModel});

  final ChannelModel channelModel;

  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {




  @override
  Widget build(BuildContext context) {
    final center=MediaQuery.of(context).size.height/3;
    return Scaffold(
      backgroundColor: colorBackground,
      body: Column(
        children: [
          Container(
            height: 100,
            padding: const EdgeInsets.only(top: 30,left: 20,right: 20),
            decoration: BoxDecoration(
                color: colorPrimary,
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(40))
            ),
            child: Row(
              children: [
                IconButton(onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back,color: Colors.white)),
                const SizedBox(width: 10),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.all(2),
                      decoration:const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            placeholder: (context, url) => CircularProgressIndicator(color: colorBackground),
                            errorWidget: (context, url, error) =>const Icon(Icons.error),
                            imageUrl: widget.channelModel.urlBanner),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(widget.channelModel.title,style:const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                    ),),
                  ],
                ),

              ],
            ),
          ),
            Expanded(
                child: SingleChildScrollView(
                child: Container(
                  margin:const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(left: 30,top: 30),
                          alignment: Alignment.center,
                          height: 30,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: colorRed
                          ),
                          child:const Text('Channel video',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            ),),
                        ),
                      ),
                      const SizedBox(height: 10),
                      BlocConsumer<MainBloc,MainState>(
                          listener: (context,stateListener){

                          },
                        builder: (_,state){
                            if(state.mainStatus.isLoading){
                              return  Padding(
                                padding:  EdgeInsets.only(top:center),
                                child: const Center(child: CircularProgressIndicator()),
                              );
                            }
                           if(state.mainStatus.isSuccess){
                            return Column(children: [
                              ...List.generate(state.videoFromChannel.length, (index){
                                return  ItemVideo(videoModel: state.videoFromChannel[index]);
                              })
                            ],);
                           }
                          return Container();
                      },)



                    ],
                  ),
                ),



              ))

        ],
      )
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<MainBloc>().add(GetListVideoFromChannelEvent(idChannel: widget.channelModel.idChannel));

  }
}