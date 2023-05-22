

  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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


  @override
  void initState() {
    super.initState();
    _codeController=TextEditingController();
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
               return Container(
                 margin:  const EdgeInsets.symmetric(horizontal: 50),
                 constraints: const BoxConstraints(maxWidth: 500),
                 child: Column(
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
                           textButton: 'SingIn')
                     },
                     const SizedBox(height: 50),

                   ],
                 ),
               );
             }
         ),
       )
   );
  }
}