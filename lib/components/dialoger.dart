

import 'dart:io';
import 'dart:ui';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youtube_clicker/presentation/membership_screen/membership_page.dart';

import '../presentation/auth_screen/auth_page.dart';
import '../presentation/auth_screen/bloc/auth_bloc.dart';
import '../resourses/colors_app.dart';




class Dialoger {


  static void showLogOut({required BuildContext context}){
    showCustomDialog(
      textButtonCancel: 'Close',
      textButtonAccept: 'Ok',
      textButtonColor: Colors.white,
      contextUp: context,
      title: 'Sign out?',
      titleColor: Platform.isIOS?colorPrimary:Colors.white,
      content:  Text('Your data is saved on the server',
        style: TextStyle(
            color: Platform.isIOS?colorPrimary:Colors.grey,

        ),),
      voidCallback: (){
        context.read<AuthBloc>().add(LogOutEvent());
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>const AuthPage()));
      }
    );


  }



  static void showGetStartedTranslate(BuildContext context,int numberTranslate, VoidCallback callback) {
    showCustomDialog(
      textButtonCancel: 'Cancel',
      textButtonAccept: 'To begin',
      textButtonColor: Colors.white,
      contextUp: context,
      title: 'Translate?',
      titleColor: Platform.isIOS?colorPrimary:Colors.white,
      content:  Text('Your transfer balance will be debited - $numberTranslate',
        style:  TextStyle(
            color: Platform.isIOS?colorPrimary:Colors.grey
        ),),
      voidCallback: (){
          callback();
      }

    );
  }

  static void showNotTranslate(BuildContext context,String title) {
    showCustomDialog(
      textButtonCancel: 'Close',
      textButtonAccept: 'To the store',
      contextUp: context,
      title: title,
      titleColor: const Color.fromRGBO(212,32,60, 1),
      content:  Text(
        'Choose the appropriate offer for further work with translations',
        style: TextStyle(
          color: Platform.isIOS?colorPrimary:Colors.white
        ),
      ),
      voidCallback: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>MembershipPage()));
      }

    );
  }

  static Future<T?> showCustomDialog<T>({
    required BuildContext contextUp,
    required String title,
    required String textButtonCancel,
    required String textButtonAccept,
    required VoidCallback voidCallback,
    Color? textButtonColor=const Color.fromRGBO(212,32,60, 1),
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
            padding: const EdgeInsets.only(left: 30.0,right: 30.0,top: 15.0,bottom: 15.0),
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
                      child:  Text(textButtonAccept,style: TextStyle(
                        color: textButtonColor,

                      ),),
                      onPressed: () {
                        Navigator.pop(context);
                        voidCallback();
                      },
                    ),
                    TextButton(
                      child:  Text(textButtonCancel,style:const TextStyle(
                          color: Colors.white,

                      )),
                      onPressed: () {
                           Navigator.pop(context);
                      },
                    ),

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
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            if(textButtonAccept.isNotEmpty)...{
              TextButton(
                child:  Text(textButtonAccept),
                onPressed: () {
                  Navigator.pop(context);
                  voidCallback();
                },
              )
            }
          ],
        ),
      ),
    );
  }

  static void showInfoDialog(BuildContext context,String title,String body,bool isError,VoidCallback voidCallback) {
    showCustomDialog(
      textButtonCancel: 'Ok',
      textButtonAccept: '',
      contextUp: context,
      title: title,
      titleColor: isError?colorRed:Platform.isIOS?colorPrimary:Colors.white,
      content:  Text(body,style: TextStyle(
        color: Platform.isIOS?colorPrimary:Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.normal
      ),),
      voidCallback: (){
        voidCallback();
      }

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