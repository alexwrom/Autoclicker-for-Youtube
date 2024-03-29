






import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_clicker/presentation/auth_screen/singin_page.dart';

import '../../components/dialoger.dart';
import '../../resourses/colors_app.dart';
import '../../resourses/images.dart';
import '../main_screen/list_channel_add_page.dart';
import 'bloc/auth_bloc.dart';
import 'enter_code_verification_page.dart';
import 'login_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({ super.key });

  @override
  State  createState() => _AuthPageState();
}

class _AuthPageState extends State  with TickerProviderStateMixin{

  late TabController _tabControllerMain;


  @override
  void initState() {
    super.initState();
    _tabControllerMain=TabController(length: 2, vsync: this);
  }


  @override
  void dispose() {
    super.dispose();
    _tabControllerMain.dispose();
  }

  @override
  void didChangeDependencies() {
    _tabControllerMain.addListener(() {
      FocusScope.of(context).unfocus();
    });
    super.didChangeDependencies();
  }

  static Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

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
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>const ListChannelAdd()));
            }

            if(s.authStatus==AuthStatus.verificationCodeExist){
              Navigator.push(context, MaterialPageRoute(builder:(_)=>const EnterCodeVerificationEmail()));
            }
          },
          builder: (context,state) {

            if(state.authStatus==AuthStatus.processSingIn){
              return const Center(child: CircularProgressIndicator());
            }
            return Center(
              child: Container(
                padding: const EdgeInsets.only(left: 25,right: 25),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                  margin: const EdgeInsets.only(top: 100,left: 30,right: 30),
                  decoration: BoxDecoration(
                      color: colorPrimary,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(100),topRight: Radius.circular(60))
                  ),
                child: SingleChildScrollView(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 420),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding:const EdgeInsets.all(3.0),
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
                        const SizedBox(height: 50),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                             // width: 300,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  color: colorBackground,
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              child: TabBar(
                                dividerColor: Colors.transparent,
                                indicatorSize: TabBarIndicatorSize.tab,
                                padding: const EdgeInsets.all(3),
                                controller: _tabControllerMain,
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w700
                                ),
                                labelColor: Colors.white,
                                unselectedLabelColor: colorGrey,
                                indicator: BoxDecoration(
                                    color: colorRed,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                tabs:  [
                                  Tab(
                                    text: 'LogIn'.tr(),
                                  ),
                                  Tab(
                                    text: 'SingIn'.tr(),
                                  ),
                                ],

                              ),
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              height: 310,
                              child: TabBarView(
                                  controller: _tabControllerMain,
                                  children: const[
                                    LogInPage(),
                                    SingInPage()
                                  ]),
                            )
                          ],
                        ),

                        IconButton(onPressed: (){
                          Dialoger.showCustomDialog(
                              contextUp: context,
                              title: '',
                              sizeTextAccept: 17.0,
                              textButtonCancel: 'Close'.tr(),
                              textButtonAccept: 'Open chat'.tr(),
                              content: Text('Want to ask a question in the support group?'.tr(),
                               style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              ),),
                              voidCallbackAccept: (){
                               _launchUrl('https://t.me/youclicker_support');
                              },
                              voidCallbackCancel: (){

                              });
                        },
                            icon: const Icon(Icons.question_answer_outlined,color: Colors.white))


                      ],
                    ),
                  ),
                )
              ),
            );
          }
      ),
    );
  }
}

