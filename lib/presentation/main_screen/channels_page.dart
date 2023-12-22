
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clicker/presentation/main_screen/bloc/main_bloc.dart';
import 'package:youtube_clicker/presentation/main_screen/bloc/main_event.dart';
import 'package:youtube_clicker/presentation/main_screen/bloc/main_state.dart';
import 'package:youtube_clicker/presentation/main_screen/widgets/card_free_trial.dart';
import 'package:youtube_clicker/presentation/main_screen/widgets/item_channel.dart';
import 'package:youtube_clicker/presentation/main_screen/widgets/item_notpub_video.dart';
import 'package:youtube_clicker/presentation/main_screen/widgets/user_data_card.dart';
import '../../components/dialoger.dart';
import '../../domain/models/user_data.dart';
import '../../resourses/colors_app.dart';
import '../../utils/preferences_util.dart';
import '../auth_screen/auth_page.dart';
import '../auth_screen/bloc/auth_bloc.dart';
import 'cubit/user_data_cubit.dart';

class ChannelsPage extends StatefulWidget{
  const ChannelsPage({super.key,this.reAuth=true});

  final bool reAuth;

  @override
  State<ChannelsPage> createState() => _ChannelsPageState();
}

class _ChannelsPageState extends State<ChannelsPage> {


  late UserData userData;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: BlocConsumer<MainBloc,MainState>(
        listener: (_,s){
          if(s.mainStatus.isError){
            Dialoger.showError(s.error, context);
          }
        },
        builder: (context,state) {
          if(state.mainStatus.isLoading){
            return const Center(child: CircularProgressIndicator());
          }

          if(state.mainStatus.isError){

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const Icon(Icons.error_outline,color: Colors.grey),
                  const SizedBox(height: 10),
                  Text('Data loading error'.tr(),style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400
                  ),),
                  const SizedBox(height: 10),
                 ElevatedButton(
                     style: ButtonStyle(
                       backgroundColor: MaterialStateProperty.all(colorRed)
                     ),
                     onPressed: (){
                       context.read<MainBloc>().add(GetChannelEvent(user: userData));
                     },
                     child: Text('Reload page'.tr()))
                ],
              ),
            );
          }

          if(state.mainStatus.isSuccess||state.mainStatus.isEmpty){
            return Column(
              children: [
                Container(
                  height: 120,
                  padding: const EdgeInsets.only(top: 40,left: 20,right: 20),
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
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(2),
                            decoration:const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                            ),
                            child: GestureDetector(
                              onTap:(){
                                final uid=PreferencesUtil.getUid;
                                  Dialoger.showInfoDialog(context, 'Your id'.tr(), uid, false, () { });
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => CircularProgressIndicator(color: colorBackground),
                                    errorWidget: (context, url, error) =>const Icon(Icons.error),
                                    imageUrl: state.urlAvatar),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(state.userName,style:const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700
                          ),),

                        ],
                      ),
                      Row(
                        children: [
                          const UserDataCard(),
                          IconButton(onPressed: (){
                           Dialoger.showLogOut(context: context);
                           },
                              icon: Icon(Icons.logout,color: colorRed))
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
                          CardFreeTrial(),
                          Visibility(
                            visible: !state.mainStatus.isEmpty,
                            child: Align(
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
                                child: Text('My channels'.tr(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                  ),),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: state.mainStatus.isEmpty,
                            child: Column(
                              children: [
                                const SizedBox(height: 150),
                                const Icon(Icons.hourglass_empty,
                                    color: Colors.grey, size: 50),
                                const SizedBox(height: 20),
                                 Text(
                                  "This account has no channels".tr(),
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                colorRed)),
                                    onPressed: () {
                                      // context
                                      //     .read<AuthBloc>()
                                      //     .add(LogOutEvent());
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>const AuthPage()));
                                    },
                                    child:  Text(
                                        'Sign in with another account'.tr()))
                              ],
                            ),
                          ),

                          Visibility(
                            visible: !state.mainStatus.isEmpty,
                              child: Column(children: [
                            ...List.generate(state.channelList.length, (index){
                              return  ItemChannel(channelModel: state.channelList[index]);
                            })
                          ],)),

                          Visibility(
                            visible: state.videoNotPubList.isNotEmpty,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(left: 30,top: 30),
                                alignment: Alignment.center,
                                height: 30,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: colorRed
                                ),
                                child: Text('Other videos of the account'.tr(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                  ),),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                              visible: state.videoNotPubList.isNotEmpty,
                              child: Column(children: [
                                ...List.generate(state.videoNotPubList.length, (index){
                                  return  ItemNotPubVideo(videoNotPublished: state.videoNotPubList[index],credChannel:state.listCredChannels[index] );
                                })
                              ],)),


                        ],
                      ),
                    ),
                  ),
                )

              ],
            );
          }


          return Container();

        }
      )
    );
  }

  @override
  void initState() {
    super.initState();

  }

   @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userData = context.watch<UserDataCubit>().state.userData;
    context.read<MainBloc>().add(GetChannelEvent(user: userData));
  }
}


