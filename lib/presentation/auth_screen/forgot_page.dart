




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/buttons.dart';
import '../../components/dialoger.dart';
import '../../components/text_fields.dart';
import '../../resourses/colors_app.dart';
import 'bloc/auth_bloc.dart';

class ForgotPage extends StatefulWidget{
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {


  late TextEditingController _emailController;
  String _text='Enter the address provided during registration.';
  String _textButton='Reset the password';
  String _textHint='Email';
  String _email='';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
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

              },
          builder: (context,state) {
            if(state.authStatus==AuthStatus.sendToEmail){
              _text='Enter a new password';
              _textButton='Save new password';
              _textHint='New password';
              _email=_emailController.text;
              _emailController.clear();
              context.read<AuthBloc>().add(Unknown());
            }

            if(state.authStatus==AuthStatus.successNewPass){
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                       Icon(Icons.check_circle_outline_rounded,color: Colors.green,size: 120),
                       SizedBox(height: 20,),
                       Text('Password changed successfully',style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                    ],
                  ),
                );
            }
            return Center(
              child: Container(
                alignment: Alignment.center,
                margin:  const EdgeInsets.all(50),
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Icon(Icons.lock_reset_rounded,color: colorRed,size: 80),
                    const SizedBox(height: 80),
                    const Text('Reset the password',style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700)),
                    const SizedBox(height: 50),
                    EmailFieldLogin(controller: _emailController,textHint: _textHint),
                    const SizedBox(height: 30),

                    if(state.authStatus==AuthStatus.processForgot)...{
                        SizedBox(width:40,height:40,child:  CircularProgressIndicator(color: colorBackground))
                    }else...{
                      SubmitButton(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            if (_emailController.text.isEmpty) {
                              return;
                            }
                            if (_emailController.text.contains('@')) {
                              context.read<AuthBloc>().add(ForgotEvent(
                                  email: _emailController.text,
                                  newPass: 'abc'));
                            } else {
                              context.read<AuthBloc>().add(ForgotEvent(
                                  email: _email,
                                  newPass: _emailController.text));
                            }
                          },
                          textButton: _textButton)
                    },
                    const SizedBox(height: 50),
                     SizedBox(
                      width: 150,
                      child: Text(_text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          )),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _emailController=TextEditingController();
  }

  @override
  void didChangeDependencies() {
    context.read<AuthBloc>().add(Unknown());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    print('Disponse');
    _emailController.dispose();

  }
}