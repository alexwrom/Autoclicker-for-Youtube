



  import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clicker/resourses/colors_app.dart';

import '../../resourses/images.dart';

class SplashPage extends StatelessWidget{
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body:
    Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           ClipRRect(
             borderRadius: BorderRadius.circular(20),
             child: Image.asset(logoApp),
           ),
           const SizedBox(height: 40),
           SizedBox(
             height: 50,
             child: AnimatedTextKit(
               repeatForever: true,
               animatedTexts: [
                 FlickerAnimatedText('YouTube',textStyle: TextStyle(
                 color: colorRed,
                 fontSize: 32,
                 fontWeight: FontWeight.w500
                )),
                 FlickerAnimatedText('Clicker',textStyle: TextStyle(
                     color: colorBackground,
                     fontSize: 32,
                     fontWeight: FontWeight.w500
                 )),
               ],
             ),
           ),
         ],
       ),),
  );
  }


}