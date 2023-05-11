





import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clicker/utils/preferences_util.dart';

import '../../app_bloc/app_bloc.dart';
import '../../components/buttons.dart';
import '../../components/dialoger.dart';
import '../../components/text_fields.dart';
import '../../resourses/colors_app.dart';
import '../main_screen/channels_page.dart';
import 'bloc/auth_bloc.dart';
import 'forgot_page.dart';




class LogInPage extends StatefulWidget{
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  late TextEditingController _emailController;
  late TextEditingController _passController;
  String email='';


  @override
  void dispose() {
    super.dispose();
    _passController.dispose();
    _emailController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailController=TextEditingController();
    _passController=TextEditingController();
    email=PreferencesUtil.getEmail;
    if(email.isNotEmpty)_emailController.text=email;
  }
  @override
  Widget build(BuildContext context) {
    return   BlocBuilder<AppBloc,AppState>(
      builder: (context,state) {
        return BlocConsumer<AuthBloc,AuthState>(
          listener: (_,s){
           if(s.authStatus==AuthStatus.error){
             Dialoger.showError(s.error, context);
           }

            if(s.authStatus==AuthStatus.authenticated){


            }
          },
          builder: (context,stateAuth) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EmailFieldLogin(controller: _emailController),
                const SizedBox(height: 10),
                PassFieldLogin(controller: _passController,textHint: 'Password',),
                const SizedBox(height: 50),
                stateAuth.authStatus==AuthStatus.processLogIn?
                SizedBox(width:40,height:40,child:  CircularProgressIndicator(color: colorBackground)):
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SubmitButton(onTap: (){
                      FocusScope.of(context).unfocus();
                      context.read<AuthBloc>().add(LogInEvent(email: _emailController.text,password: _passController.text));
                    },
                      textButton: 'LogIn',),
                    const SizedBox(height: 50),
                    GestureDetector(
                      onTap: (){
                         Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const ForgotPage()));
                      },
                      child: const Text('Forgot password',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.white,fontWeight: FontWeight.w400,fontSize: 17),),
                    )
                  ],
                )

              ],
            );
          }
        );
      }
    );
  }
}