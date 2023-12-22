

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:youtube_clicker/domain/models/user_data.dart';
import 'package:youtube_clicker/presentation/main_screen/video_list_page.dart';
import 'package:youtube_clicker/presentation/main_screen/widgets/item_channel_cred.dart';
import 'package:youtube_clicker/presentation/main_screen/widgets/user_data_card.dart';
import 'package:youtube_clicker/resourses/images.dart';

import '../../components/dialoger.dart';
import '../../components/floating_buttom_animation.dart';
import '../../resourses/colors_app.dart';
import 'bloc/main_bloc.dart';
import 'bloc/main_event.dart';
import 'bloc/main_state.dart';
import 'cubit/user_data_cubit.dart';

class ListChannelAdd extends StatefulWidget{
  const ListChannelAdd({super.key});

  @override
  State<ListChannelAdd> createState() => _ListChannelAddState();
}

class _ListChannelAddState extends State<ListChannelAdd> {


  late UserData userData;
  bool _isGetListChannel = false;



  @override
  void initState() {
    super.initState();


  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!_isGetListChannel){
      userData = context.watch<UserDataCubit>().state.userData;
     context.read<MainBloc>().add(GetChannelEvent(user:userData));
      _isGetListChannel = true;
    }


  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return BlocBuilder<MainBloc,MainState>(
     builder: (context,state) {
       return AbsorbPointer(
         absorbing: state.mainStatus.isLoading||state.addCredStatus.isRemoval,
         child: Scaffold(
           floatingActionButton: state.mainStatus.isError?null:
           FloatingButtonAnimation(
             closedForegroundColor: Colors.white,
             openForegroundColor: Colors.white,
             closedBackgroundColor: colorRed,
             openBackgroundColor: colorPrimary,
             labelsBackgroundColor: Colors.white,
             speedDialChildren: <SpeedDialChild>[
               SpeedDialChild(
                 child: Image.asset(imgCode,width: 30.0,height: 30.0),
                 backgroundColor: Colors.white,
                 onPressed: () {
                   Dialoger.showChannelSelectionMenu(context: context);
                 },
                 closeSpeedDialOnPressed: true,
               ),
               SpeedDialChild(
                 closeSpeedDialOnPressed: true,
                 child: Image.asset(logoGoogle,width: 30.0,height: 30.0),
                 backgroundColor: Colors.white,
                 onPressed: () {
                   context.read<MainBloc>().add(AddChannelWithGoogleEvent());
                 },
               ),

             ],
             child: const Icon(Icons.add),
           ),

           //
           // FloatingActionButton(
           //   backgroundColor: colorRed,
           //   child: const Icon(Icons.add,color: Colors.white),
           //   onPressed: () {
           //
           //
           //
           //       Dialoger.showChannelSelectionMenu(context: context);
           // },),
             backgroundColor: colorBackground,
             body: BlocConsumer<MainBloc,MainState>(
                 listener: (_,s){
              if (s.mainStatus.isError ||
                  s.addCredStatus.isError ||
                  s.addCredStatus.isErrorRemove||
                  s.statusBlockAccount.isError) {
                Dialoger.showError(s.error, context);
              }

              if(!s.isChannelDeactivation){
                Dialoger.showError('One or more channels have been deactivated'.tr(),context);
              }


            },
                 builder: (context,state) {
                   if(state.mainStatus.isLoading||state.addCredStatus.isLoading){
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

              if (state.mainStatus.isSuccess ||
                  state.addCredStatus.isSuccess ||
                  state.mainStatus.isEmpty) {
                return Column(
                       children: [
                         Container(
                           height: 120,
                           padding: const EdgeInsets.only(top: 40,left: 10,right: 10),
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
                                   GestureDetector(
                                     onTap: (){
                                       Dialoger.showBlockAccountDialog(context: context,
                                           isBlockedAccount:state.blockedAccount);
                                     },
                                     child:
                                     !state.statusBlockAccount.isLoading?
                                     Container(
                                       alignment: Alignment.centerRight,
                                       width: 40,
                                       height: 40,
                                       child: Container(
                                         width: 35,
                                         height: 35,
                                         decoration: BoxDecoration(
                                             shape: BoxShape.circle,
                                             color: colorBackground
                                         ),
                                         child:
                                         Icon(state.blockedAccount?Icons.pause:
                                         Icons.play_arrow,color: Colors.white),
                                       ),
                                     ):const Padding(
                                       padding: EdgeInsets.only(left: 10),
                                       child: SizedBox(
                                           width: 30,
                                           height: 30,
                                           child: CircularProgressIndicator(color: Colors.white,strokeWidth: 1.5)),
                                     ),
                                   ),const SizedBox(width: 10),
                                   SizedBox(
                                     width: MediaQuery.of(context).size.width/2,
                                     child: Text(state.userName,
                                       maxLines: 1,
                                       style:const TextStyle(
                                       overflow: TextOverflow.ellipsis,
                                         color: Colors.white,
                                         fontSize: 18,
                                         fontWeight: FontWeight.w700
                                     ),),
                                   ),

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
                             child: Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 20),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Visibility(
                                     visible: !state.mainStatus.isEmpty,
                                     child: Align(
                                       alignment: Alignment.centerLeft,
                                       child: Row(
                                         children: [
                                           Container(
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
                                           const SizedBox(width: 20),
                                           if(state.addCredStatus.isRemoval)...{
                                             Padding(
                                               padding: const EdgeInsets.only(top: 30),
                                               child:                                             Row(
                                                 children: [
                                                   SizedBox(
                                                     width: 20,
                                                     height: 20,
                                                     child: CircularProgressIndicator(color: colorRed),
                                                   ),
                                                   const SizedBox(width: 20),
                                                    Text(
                                                     'Deleting a channel...'.tr(),
                                                     style: const TextStyle(
                                                         color: Colors.white,
                                                         fontSize: 14,
                                                         fontWeight: FontWeight.w400
                                                     ),
                                                   ),
                                                 ],
                                               )

                                             )

                                           },
                                         ],
                                       ),
                                     ),
                                   ),
                                   const SizedBox(height: 10),
                                   Visibility(
                                     visible: state.mainStatus.isEmpty,
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                          SizedBox(height: MediaQuery.of(context).size.height/3.5),
                                         const Icon(Icons.hourglass_empty,
                                             color: Colors.grey, size: 50),
                                         const SizedBox(height: 20),
                                          Text(
                                           "Saved channel list is empty".tr(),
                                           style: const TextStyle(
                                               color: Colors.grey,
                                               fontSize: 20,
                                               fontWeight: FontWeight.w400),
                                         ),
                                       ],
                                     ),
                                   ),



                                   Visibility(
                                       visible: !state.mainStatus.isEmpty,
                                       child: Column(children: [
                                         ...List.generate(state.listCredChannels.length, (index){
                                           return  ItemChannelCred(channelModelCred: state.listCredChannels[index],
                                           index: index,
                                           onAction: (credChannel){
                                             if(state.blockedAccount){
                                               Dialoger.showInfoDialog(context,
                                                 '','You cannot perform any activities while your account is suspended. Unpause and continue working.'.tr(),true,(){

                                                   }
                                               );
                                               return;
                                             }
                                             Navigator.push(context,
                                                 MaterialPageRoute(builder: (_)=> VideoListPage(channelModelCred: credChannel)));
                                           },
                                           onDelete: (i){
                                             Dialoger.showDeleteChannel(context: context,keyHive: state
                                                .listCredChannels[index]
                                                .keyLangCode,index:index);
                                          },);
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
         ),
       );
     }
   );
  }
}