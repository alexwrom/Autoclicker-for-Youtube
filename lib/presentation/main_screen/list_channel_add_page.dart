

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clicker/presentation/main_screen/widgets/card_free_trial.dart';
import 'package:youtube_clicker/presentation/main_screen/widgets/item_channel_cred.dart';
import 'package:youtube_clicker/presentation/main_screen/widgets/user_data_card.dart';

import '../../components/dialoger.dart';
import '../../resourses/colors_app.dart';
import 'bloc/main_bloc.dart';
import 'bloc/main_event.dart';
import 'bloc/main_state.dart';

class ListChannelAdd extends StatefulWidget{
  const ListChannelAdd({super.key});

  @override
  State<ListChannelAdd> createState() => _ListChannelAddState();
}

class _ListChannelAddState extends State<ListChannelAdd> {

  @override
  void initState() {
    super.initState();
    context.read<MainBloc>().add(GetChannelEvent());

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
           floatingActionButton: state.mainStatus.isEmpty||state.mainStatus.isError?null:FloatingActionButton(
             backgroundColor: colorRed,
             child: const Icon(Icons.add,color: Colors.white),
             onPressed: () {
                 context.read<MainBloc>().add(AddChannelEvent());
           },),
             backgroundColor: colorBackground,
             body: BlocConsumer<MainBloc,MainState>(
                 listener: (_,s){
              if (s.mainStatus.isError ||
                  s.addCredStatus.isError ||
                  s.addCredStatus.isErrorRemove) {
                Dialoger.showError(s.error, context);
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
                           const Text('Data loading error',style: TextStyle(
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
                                 context.read<MainBloc>().add(GetChannelEvent());
                               },
                               child:const Text('Reload page'))
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
                                   const Icon(Icons.perm_identity_rounded,size: 30,color: Colors.white),
                                   const SizedBox(width: 10),
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
                                   CardFreeTrial(),
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
                                             child:const Text('My channels',
                                               style: TextStyle(
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
                                                   const Text(
                                                     'Deleting a channel...',
                                                     style: TextStyle(
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
                                         const Text(
                                           "Saved channel list is empty",
                                           style: TextStyle(
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
                                               context.read<MainBloc>().add(AddChannelEvent());
                                             },
                                             child: const Text(
                                                 'Add a channel'))
                                       ],
                                     ),
                                   ),



                                   Visibility(
                                       visible: !state.mainStatus.isEmpty,
                                       child: Column(children: [
                                         ...List.generate(state.listCredChannels.length, (index){
                                           return  ItemChannelCred(channelModelCred: state.listCredChannels[index],
                                           index: index,
                                           onDelete: (i){
                                            Dialoger.showDeleteChannel(context: context,keyHint: state
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