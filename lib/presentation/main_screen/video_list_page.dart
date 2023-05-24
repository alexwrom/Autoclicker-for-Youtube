




import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:youtube_clicker/presentation/main_screen/bloc/main_bloc.dart';
import 'package:youtube_clicker/presentation/main_screen/bloc/main_event.dart';
import 'package:youtube_clicker/presentation/main_screen/bloc/main_state.dart';
import 'package:youtube_clicker/presentation/main_screen/widgets/item_video.dart';
import 'package:http/io_client.dart';
import '../../components/dialoger.dart';
import '../../data/http_client/http_client.dart';
import '../../di/locator.dart';
import '../../domain/models/channel_model.dart';
import '../../domain/models/channel_model_cred.dart';
import '../../resourses/colors_app.dart';
import '../../utils/preferences_util.dart';

class VideoListPage extends StatefulWidget{
  const VideoListPage({super.key,required this.channelModelCred});

  final ChannelModelCred channelModelCred;


  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> with WidgetsBindingObserver{


  IOClient? httpClient;


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
                            imageUrl: widget.channelModelCred.imgBanner),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(widget.channelModelCred.nameChannel,style:const TextStyle(
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
                  child: BlocConsumer<MainBloc,MainState>(
                      listener: (context,stateListener){
                        if(stateListener.videoListStatus.isError){
                          Dialoger.showError(stateListener.error, context);
                        }
                      },
                    builder: (_,state){

                      if (state.videoListStatus.isEmpty) {
                       return Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           SizedBox(height: MediaQuery.of(context).size.height/3),
                           const Icon(Icons.hourglass_empty,
                               color: Colors.grey, size: 50),
                           const SizedBox(height: 20),
                           const Text(
                             "No published videos found",
                             style: TextStyle(
                                 color: Colors.grey,
                                 fontSize: 20,
                                 fontWeight: FontWeight.w400),
                           ),
                         ],
                       );
                      }
                      if(state.videoListStatus.isError){
                        return  Padding(
                          padding:  EdgeInsets.only(top:center),
                          child:  const Center(child:
                            Column(
                              children:[
                                 Icon(Icons.error_outline,color: Colors.grey,size: 50),
                                 SizedBox(height: 10),
                                 Text('Data loading error',style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400
                                ),),
                              ],
                            )
                          ),
                        );
                      }
                        if(state.videoListStatus.isLoading){
                          return  Padding(
                            padding:  EdgeInsets.only(top:center),
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        }
                       if(state.videoListStatus.isSuccess){
                        return Column(children: [
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
                          ...List.generate(state.videoFromChannel.length, (index){
                            return  ItemVideo(videoModel: state.videoFromChannel[index],credChannel:widget.channelModelCred);
                          })
                        ],);
                       }
                      return Container();
                  },),
                ),



              ))

        ],
      )
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    context.read<MainBloc>().add(GetListVideoFromChannelEvent(cred: widget.channelModelCred));
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();


  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
  //  if (state == AppLifecycleState.resumed) {
  //     await _googleSingIn.currentUser!.clearAuthCache();
  //     final  authHeaders = await _googleSingIn.currentUser!.authHeaders;
  //     await PreferencesUtil.setHeadersGoogleApi(authHeaders);
  //   }
   }

}