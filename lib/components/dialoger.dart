

import 'dart:io';
import 'dart:ui';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../resourses/colors_app.dart';




class Dialoger {


  static void showLogOut({required BuildContext context}){
    showCustomDialog(
      textButtonCancel: 'Отмена',
      textButtonAccept: 'Выйти',
      contextUp: context,
      title: 'Выйти из аккаунта?',
      titleColor: colorGrey,
      content:  Text('Ваши данные сохранены на сервере',
        style: TextStyle(
            color: colorGrey,
            fontSize: 14
        ),),
    );


  }



  static void showGetStarted(BuildContext context) {
    showCustomDialog(
      textButtonCancel: 'Отмена',
      textButtonAccept: 'Выйти',
      contextUp: context,
      title: 'Get Started!',
      content: const Text('Free trial'),

    );
  }

  static void showNotSubscribed(BuildContext context) {
    showCustomDialog(
      textButtonCancel: 'Отмена',
      textButtonAccept: 'Выйти',
      contextUp: context,
      title: 'Error: You do not have an active subscription!',
      titleColor: const Color(0xFFFF0000),
      content: const Text(
        'You can continue to use quick connect, or start your free full access trial to continue.',
      ),

    );
  }

  static Future<T?> showCustomDialog<T>({
    required BuildContext contextUp,
    required String title,
    required String textButtonCancel,
    required String textButtonAccept,
    Color? titleColor,
    Widget? content,
  }) async {
    final titleWidget = Text(
      title,
      style: TextStyle(
        color: titleColor,
        fontSize: 18,
        fontWeight: FontWeight.w500
      ),
    );
    return showDialog<T>(
      context: contextUp,
      useRootNavigator: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Platform.isAndroid
            ? AlertDialog(
          contentPadding: const EdgeInsets.all(0.0),
          backgroundColor: colorGrey,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          //title: titleWidget,
          content: Container(
            height: 200,
            padding: const EdgeInsets.only(left: 20.0,right: 15.0,top: 15.0,bottom: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: colorPrimary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                titleWidget,
                content!,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child:  Text(textButtonCancel,style:const TextStyle(
                          color: Colors.white,

                      )),
                      onPressed: () {
                           Navigator.pop(context);
                      },
                    ),
                    // TextButton(
                    //   child:  Text(textButtonAccept,style: TextStyle(
                    //       color: colorPrimary,
                    //
                    //   ),),
                    //   onPressed: () {
                    //
                    //   },
                    // )
                  ],
                )
              ],
            ),
          ),

        )
            : CupertinoAlertDialog(
          title: titleWidget,
          content: content,
          actions: <Widget>[
            TextButton(
              child:  Text(textButtonCancel),
              onPressed: (){},
            ),
            // TextButton(
            //   child:  Text(textButtonAccept),
            //   onPressed: () {
            //
            //   },
            // )
          ],
        ),
      ),
    );
  }

  static void showInfoDialog(BuildContext context,String title,String body,bool isError) {
    showCustomDialog(
      textButtonCancel: 'Ok',
      textButtonAccept: '',
      contextUp: context,
      title: title,
      titleColor: isError?colorRed:Colors.white,
      content:  Text(body,style:const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.normal
      ),),

    );
  }

  static void showNotSignedIn() {
    Fluttertoast.showToast(
      msg: 'Sign in or Sign up to continue.',
      fontSize: 16.0,
      gravity: ToastGravity.CENTER,
    );
  }
  static void showMessageSnackBar(String message,BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration:const Duration(seconds: 1),
        backgroundColor: colorPrimary,
        content: Text(message,style:const TextStyle(
            color: Colors.white
        ),)));
  }

  static void showError(String message,BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(message,style:const TextStyle(
            color: Colors.white
        ),)));
  }

  static void showMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: colorBackground,
      fontSize: 16.0,
      gravity: ToastGravity.CENTER,
    );
  }
}