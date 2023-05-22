

  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

import '../../components/buttons.dart';
import '../../components/dialoger.dart';
import '../../components/text_fields.dart';
import '../../resourses/colors_app.dart';
import '../../utils/preferences_util.dart';
import '../main_screen/list_channel_add_page.dart';
import 'bloc/auth_bloc.dart';

class EnterCodeVerificationEmail extends StatefulWidget{
  const EnterCodeVerificationEmail({super.key});

  @override
  State<EnterCodeVerificationEmail> createState() => _EnterCodeVerificationEmailState();
}

class _EnterCodeVerificationEmailState extends State<EnterCodeVerificationEmail> {

  late TextEditingController _codeController;
  late CountdownTimerController _timerController;


  @override
  void initState() {
    super.initState();
    _codeController=TextEditingController();
    _timerController=CountdownTimerController(endTime: _timeEnd(),
    onEnd: (){
      _clearDataForCodeVerifi();
      Navigator.pop(context);
    });
  }


  @override
  void dispose() {
    super.dispose();
    _timerController.dispose();
  }

  int _timeEnd(){
    int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
    return endTime;

  }


  @override
  Widget build(BuildContext context) {
   return Scaffold(
       backgroundColor: colorPrimary,
       body:GestureDetector(
         onTap: (){
           FocusScope.of(context).unfocus();
         },
         child: BlocConsumer<AuthBloc,AuthState>(
             listener: (context,stateListener){
               if(stateListener.authStatus==AuthStatus.error){
                 Dialoger.showError(stateListener.error, context);
               }
               if(stateListener.authStatus==AuthStatus.completeSingIn){
                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>const ListChannelAdd()));
               }

             },
             builder: (context,state) {

               if(state.authStatus==AuthStatus.authenticated){
                 return const Center(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children:[
                       Icon(Icons.check_circle_outline_rounded,color: Colors.green,size: 120),
                       SizedBox(height: 20,),
                       Text('Registration successfully completed',style: TextStyle(
                           color: Colors.white,
                           fontSize: 20,
                           fontWeight: FontWeight.w700)),
                     ],
                   ),
                 );
               }
               return AbsorbPointer(
                 absorbing: state.authStatus==AuthStatus.processSingIn,
                 child: Stack(
                   alignment: Alignment.center,
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(top: 60,right: 30),
                       child: Align(
                           alignment: Alignment.topRight,
                           child: GestureDetector(
                               onTap: (){
                                 _clearDataForCodeVerifi();
                                 Navigator.pop(context);
                               },
                               child: const Icon(Icons.close,color: Colors.white,size: 30))),
                     ),
                     Container(
                       alignment: Alignment.center,
                       margin:  const EdgeInsets.symmetric(horizontal: 50),
                       constraints: const BoxConstraints(maxWidth: 500),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(Icons.email_outlined,color: colorGrey,size: 120),
                           const SizedBox(height: 80),
                           const Text('Enter the code from the letter',style: TextStyle(
                               color: Colors.white,
                               fontSize: 20,
                               fontWeight: FontWeight.w700)),
                           const SizedBox(height: 50),
                           CodeField(controller: _codeController,textHint: ''),
                           const SizedBox(height: 30),

                           if(state.authStatus==AuthStatus.processSingIn)...{
                             SizedBox(width:40,height:40,child:  CircularProgressIndicator(color: colorBackground))
                           }else...{
                             SubmitButton(
                                 onTap: () {
                                   FocusScope.of(context).unfocus();
                                   final code=_codeController.text;
                                   final password=PreferencesUtil.getPassword;
                                   final email=PreferencesUtil.getEmail;
                                   if (code.isEmpty) {
                                     return;
                                   }
                                   context.read<AuthBloc>().add(SingInEvent(email: email, password: password, code: code));
                                 },
                                 textButton: 'SingIn'),
                             const SizedBox(height: 50),
                             CountdownTimer(
                               controller: _timerController,
                               widgetBuilder: (_, time) {
                                 if(time==null){
                                   if (time == null) {
                                     return Container();
                                   }
                                 }
                                 return Text(
                                   'Code lifetime: ${time.sec??'00'} sec.',
                                   style: TextStyle(
                                       color: colorRed,
                                       fontWeight: FontWeight.w500,
                                       fontSize: 18
                                   ),);
                               },
                             )
                           },


                         ],
                       ),
                     ),
                   ],
                 ),
               );
             }
         ),
       )
   );
  }

  void _clearDataForCodeVerifi() {
    PreferencesUtil.setPassword('');
    PreferencesUtil.setCodeVerificationEmail(['','']);
  }
}