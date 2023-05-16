





import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:youtube_clicker/presentation/main_screen/cubit/user_data_state.dart';
import 'package:youtube_clicker/presentation/membership_screen/membership_page.dart';
import 'package:youtube_clicker/resourses/colors_app.dart';

import '../../../resourses/images.dart';
import '../cubit/user_data_cubit.dart';

class CardFreeTrial extends StatelessWidget{




   CardFreeTrial({super.key});

   int _timeEnd(int timeStamp){
     final timeNow=DateTime.now().millisecondsSinceEpoch;
     const int dayFreeTrial=432000000;
     final int dayAuth=timeNow-timeStamp;
     if(dayFreeTrial<dayAuth){
       return 0;
     }
     final int restDays=dayFreeTrial-dayAuth;
     return  timeNow+restDays;

   }







  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataCubit,UserdataState>(
         builder: (context,state) {
           if(state.userDataStatus==UserDataStatus.loading){
             return Container();
           }

           if(!state.isFreeTrial){
             return Container();
           }


           return Container(
             padding: const EdgeInsets.all(20),
             margin: const EdgeInsets.only(top: 30),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                  image: DecorationImage(image: AssetImage(bgCart),fit: BoxFit.cover)
              ),
             child: Column(
               children: [
                const Text('Left before the end of the free period',style: TextStyle(
                   color: Colors.grey,
                   fontWeight: FontWeight.w500,
                   fontSize: 18
                 ),),
                 const SizedBox(height: 15),
                 CountdownTimer(
                   endTime: _timeEnd(state.userData.timeStampAuth),
                   widgetBuilder: (_, time) {
                     if (time == null) {
                       if(state.userData.numberOfTrans>0){
                         context.read<UserDataCubit>().clearBalance();
                       }
                       return Text('Trial period ended!',style: TextStyle(
                           color: colorRed,
                           fontWeight: FontWeight.w500,
                           fontSize: 26
                       ),);
                     }
                     return Text(
                         '${time.days??'0'} days ${time.hours??'00'} hours ${time.min??'00'} min ${time.sec??'00'} sec',
                       style: TextStyle(
                           color: colorRed,
                           fontWeight: FontWeight.w500,
                           fontSize: 26
                       ),);
                   },
                 ),
                 const SizedBox(height: 15),
                 const Text('After the end of the free trial period, the balance of transfers is reset to zero',
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     color: Colors.grey,
                     fontWeight: FontWeight.w400,
                     fontSize: 14
                 ),),
                 const SizedBox(height: 15),
                 Align(
                   alignment: Alignment.centerRight,
                   child: OutlinedButton(onPressed:(){
                       Navigator.push(context, MaterialPageRoute(builder: (_)=>MembershipPage()));

                   }, child:const Text('Go to store',style: TextStyle(
                       color: Colors.grey,
                       fontWeight: FontWeight.w500,
                       fontSize: 16
                   ),)),
                 )
               ],
             ),
           );
         }
       );
  }



}