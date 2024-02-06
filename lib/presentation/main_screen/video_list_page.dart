




import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
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
  bool _remoteChannel = false;
  late ChannelModelCred _channelModelCred;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    context.read<MainBloc>().add(GetListVideoFromChannelEvent(cred: widget.channelModelCred));
    _remoteChannel  = widget.channelModelCred.remoteChannel;
    _channelModelCred = widget.channelModelCred;
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





  @override
  Widget build(BuildContext context) {
    final center=MediaQuery.of(context).size.height/3;
    return Scaffold(
      backgroundColor: colorBackground,
      body: Column(
        children: [
          Container(
            height: 120,
            padding: const EdgeInsets.only(top: 30,left: 20,right: 20),
            decoration: BoxDecoration(
                color: colorPrimary,
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(40))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                                imageUrl: _channelModelCred.imgBanner),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/2.3),
                          child: Text(_channelModelCred.nameChannel,
                            maxLines: 2,
                            style:const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700
                          ),),
                        ),
                      ],
                    ),
                  ],
                ),

                Visibility(
                  visible: _channelModelCred.refreshToken.isNotEmpty,
                  child: BlocConsumer<MainBloc,MainState>(
                    listener: (c,s){
                      if(s.statusAddRemoteChannel.isError){
                        _remoteChannel =!_remoteChannel;
                        Dialoger.showError(s.error, context);
                      }
                    },
                    builder: (context,state) {
                      return Row(
                        children: [
                           Icon(Icons.smartphone,color: colorGrey,size: 23.0),
                         Switch(
                           thumbColor: MaterialStatePropertyAll(colorGrey),
                            trackColor: MaterialStatePropertyAll(colorBackground),
                             value: _remoteChannel,
                             onChanged: (v){
                              setState(() {
                                _remoteChannel = v;
                                context.read<MainBloc>().add(
                                        AddOrRemoveRemoteChannelEvent(
                                            channelModelCred:
                                            _channelModelCred,
                                            remove: !_remoteChannel));
                                  });
                         }),
                           Icon(Icons.public,color: colorGrey,size: 25.0)
                        ],
                      );
                    }
                  ),
                )

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
                            Text(
                             "No published videos found".tr(),
                             style: const TextStyle(
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
                          child:   Center(child:
                            Column(
                              children:[
                                 const Icon(Icons.error_outline,color: Colors.grey,size: 50),
                                 const SizedBox(height: 10),
                                 Text('Data loading error'.tr(),style: const TextStyle(
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
                              child: Text('Channel video'.tr(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400
                                ),),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...List.generate(state.videoFromChannel.length, (index){
                            return  ItemVideo(
                                videoModel: state.videoFromChannel[index],
                                credChannel:_channelModelCred,
                             onUpdateChannel: (newChannelData){
                                  _channelModelCred = newChannelData;
                                  print('New Channel ${_channelModelCred.bonus}');
                             },);
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


}