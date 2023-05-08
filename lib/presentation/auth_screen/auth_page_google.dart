



import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:youtube_clicker/presentation/auth_screen/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clicker/resourses/colors_app.dart';
import 'package:youtube_clicker/resourses/images.dart';

import '../../components/dialoger.dart';
import '../main_screen/channels_page.dart';

class AuthPageGoogle extends StatelessWidget{
  const AuthPageGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: BlocConsumer<AuthBloc,AuthState>(
        listener: (_,s){
          if(s.authStatus==AuthStatus.error){
            Dialoger.showError(s.error, context);
          }

          if(s.authStatus==AuthStatus.authenticated){
             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>const ChannelsPage(reAuth:false)));

          }
        },
        builder: (context,state) {

          if(state.authStatus==AuthStatus.processSingIn){
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 100,left: 20,right: 20),
                  decoration: BoxDecoration(
                    color: colorPrimary,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(100),topRight: Radius.circular(60))
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 320),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 90),
                      Container(
                        alignment: Alignment.center,
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: colorRed,
                          borderRadius:const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50)),
                        ),
                        child: ClipRRect(
                            borderRadius:const BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50)),
                          child: Image.asset(logoApp),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('You',style: TextStyle(
                              color: colorRed,
                              fontSize: 22,
                              fontWeight: FontWeight.w700
                          ),),
                          const Text('Clicker',style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700
                          ),),
                        ],
                      ),
                      const SizedBox(height: 140),
                      Image.asset(banner,width: 300,),
                      Center(
                        child: GestureDetector(
                          child: Container(
                            width: 200,
                            padding: const EdgeInsets.only(top: 10,bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey[400]
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(logoGoogle,width: 30,height: 30),
                               const SizedBox(width: 10),
                               const Text('Sign in with Google',style:TextStyle(
                                  color: Colors.white,
                                 fontSize: 16
                                ))
                              ],
                            ),
                          ),
                          onTap: (){
                            //context.read<AuthBloc>().add(const SingInEvent());
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }





}