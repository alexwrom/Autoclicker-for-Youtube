





import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clicker/presentation/auth_screen/enter_code_verification_page.dart';
 import 'dart:ui' as ui;
import '../../app_bloc/app_bloc.dart';
import '../../components/buttons.dart';
import '../../components/dialoger.dart';
import '../../components/text_fields.dart';
import '../../resourses/colors_app.dart';
import 'bloc/auth_bloc.dart';


class SingInPage extends StatefulWidget{
  const SingInPage({Key? key}) : super(key: key);

  @override
  State<SingInPage> createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {

  late TextEditingController _emailController;
  late TextEditingController _passController;
  late TextEditingController _passConfirmController;
  bool _isAcceptTerms=false;

  @override
  void initState() {
    super.initState();
    _emailController=TextEditingController();
    _passController=TextEditingController();
    _passConfirmController=TextEditingController();
  }


  @override
  void dispose() {
    super.dispose();
    _passConfirmController.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
     return  BlocBuilder<AppBloc,AppState>(
       builder: (context,state) {
         return Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             EmailFieldLogin(controller: _emailController,),
             const SizedBox(height: 10),
             PassFieldLogin(controller: _passController,textHint: 'Password'.tr(),),
             const SizedBox(height: 10),
             PassFieldLogin(controller: _passConfirmController,textHint: 'Confirm password'.tr()),
             const SizedBox(height: 40),
          BlocConsumer<AuthBloc,AuthState>(
            listener: (_,snap){

              if(snap.authStatus==AuthStatus.error){
               Dialoger.showError(snap.error, context);
             }


            },
            builder: (context,state) {
              if(state.authStatus==AuthStatus.processSingIn){
                return  SizedBox(width:40,height:40,child:  CircularProgressIndicator(color: colorBackground));
              }


              return SubmitButton(onTap: (){
                 FocusScope.of(context).unfocus();
                 context.read<AuthBloc>().add(SendCodeEmail(email: _emailController.text, password: _passController.text,repPass: _passConfirmController.text));
                 },
                   textButton: 'SingIn'.tr());
            }
          ),

           ],
         );
       }
     );
  }



}