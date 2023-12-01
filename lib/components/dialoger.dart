

import 'dart:io';
import 'dart:ui';


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youtube_clicker/components/text_fields.dart';
import 'package:youtube_clicker/presentation/membership_screen/membership_page.dart';
import 'package:youtube_clicker/presentation/translate_screen/bloc/translate_bloc.dart';

import '../data/models/list_translate_api.dart';
import '../presentation/auth_screen/auth_page.dart';
import '../presentation/auth_screen/bloc/auth_bloc.dart';
import '../presentation/main_screen/bloc/main_bloc.dart';
import '../presentation/main_screen/bloc/main_event.dart';
import '../presentation/translate_screen/bloc/translate_event.dart';
import '../resourses/colors_app.dart';
import 'buttons.dart';




class Dialoger {


  static void showBlockAccountDialog({required BuildContext context, required bool isBlockedAccount}){

    showCustomDialog(
        textButtonCancel: 'Close'.tr(),
        textButtonAccept: 'Ok',
        textButtonColor: Colors.white,
        contextUp: context,
        title: !isBlockedAccount?
        'Temporary account blocking. During the lockout, your balance is maintained and will not be reset after 30 days of account inactivity. Continue?'.tr():
        'Remove account from temporary blocking?'.tr(),
        titleColor: Platform.isIOS?colorPrimary:Colors.white,
        content: Container(),
        voidCallbackAccept: (){
         context.read<MainBloc>().add(BlockAccountEvent(unlock: isBlockedAccount));
         },
        voidCallbackCancel: (){}
    );


  }


  static void showErrorCompleteTranslate({
    required List<String> listErrorCompleteTranslate,
    required BuildContext context,
    required Function callRepeatTranslate}){
    showCustomDialog(
        textButtonCancel: 'Close'.tr(),
        textButtonAccept: '',
        textButtonColor: Colors.white,
        contextUp: context,
        title: 'There were problems with these languages when installing subtitles.'.tr(),
        titleColor: Platform.isIOS?colorPrimary:Colors.white,
        content:   ActionDialogErrorTranslate(
          listCodeLanguageErrorComplete: listErrorCompleteTranslate,
        ),
        voidCallbackAccept: (){
          callRepeatTranslate.call();

        },
        voidCallbackCancel: (){}
    );
  }


  static void showLogOut({required BuildContext context}){
    bool isRemoveAccount=false;
    showCustomDialog(
      textButtonCancel: 'Close'.tr(),
      textButtonAccept: 'Ok',
      textButtonColor: Colors.white,
      contextUp: context,
      title: 'Sign out?'.tr(),
      titleColor: Platform.isIOS?colorPrimary:Colors.white,
      content:   ActionDialogLogOut(
        callback: (isDeleteAcc){
          isRemoveAccount=isDeleteAcc;
        },
      ),
      voidCallbackAccept: (){
        if(isRemoveAccount){
            _showAcceptRemoveAccount(context: context);
        }else{
          context.read<AuthBloc>().add(const LogOutEvent(isDeleteAcc: false));
          Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>const AuthPage()));
        }

      },
      voidCallbackCancel: (){}
    );


  }


   static void _showAcceptRemoveAccount({required BuildContext context}){

    showCustomDialog(
        textButtonCancel: 'Exit without deleting'.tr(),
        textButtonAccept: 'Delete'.tr(),
        textButtonColor: Colors.white,
        contextUp: context,
        title: 'Delete account?'.tr(),
        titleColor: Platform.isIOS?colorPrimary:Colors.white,
        content: Text('After logging out of the account, it will be permanently deleted from the project database'.tr(),
          style: TextStyle(
            color: Platform.isIOS?colorPrimary:Colors.grey,

          ),),
        voidCallbackAccept: (){
            context.read<AuthBloc>().add(const LogOutEvent(isDeleteAcc: true));
            Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>const AuthPage()));


        },
        voidCallbackCancel: (){
          print('isDeleteAcc: false');
          //context.read<AuthBloc>().add(const LogOutEvent(isDeleteAcc: false));
          Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>const AuthPage()));
        }
    );


  }



  static void showDeleteChannel({required BuildContext context,required int keyHive,required int index}){
    showCustomDialog(
        textButtonCancel: 'Close'.tr(),
        textButtonAccept: 'Delete'.tr(),
        textButtonColor: Colors.white,
        contextUp: context,
        title: 'Delete channel?'.tr(),
        titleColor: Platform.isIOS?colorPrimary:Colors.white,
        content:  Text('Channel data is deleted from local storage'.tr(),
          style: TextStyle(
            color: Platform.isIOS?colorPrimary:Colors.grey,

          ),),
        voidCallbackAccept: (){
          context.read<MainBloc>().add(
              RemoveChannelEvent(
                  keyHive: keyHive,
                  index: index));
        },
        voidCallbackCancel: (){

        }
    );


  }



  static void showGetStartedTranslate(BuildContext context,int numberTranslate, VoidCallback callback) {
    showCustomDialog(
      textButtonCancel: 'Cancel'.tr(),
      textButtonAccept: 'To begin'.tr(),
      textButtonColor: Colors.white,
      contextUp: context,
      title: 'Translate?'.tr(),
      titleColor: Platform.isIOS?colorPrimary:Colors.white,
      content:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Your transfer balance will be debited'.tr(),
            style:  TextStyle(
                color: Platform.isIOS?colorPrimary:Colors.grey
            ),),
          Text(' - $numberTranslate',
            style:  TextStyle(
                color: Platform.isIOS?colorPrimary:Colors.grey
            ),),
        ],
      ),
      voidCallbackAccept: (){
          callback();
      },
        voidCallbackCancel: (){

        }

    );
  }

  static void showNotTranslate(BuildContext context,String title) {
    showCustomDialog(
      textButtonCancel: 'Close'.tr(),
      textButtonAccept: 'To the store'.tr(),
      contextUp: context,
      title: title,
      titleColor: const Color.fromRGBO(212,32,60, 1),
      content:  Text(
        'Choose the appropriate offer for further work with translations'.tr(),
        style: TextStyle(
          color: Platform.isIOS?colorPrimary:Colors.white
        ),
      ),
      voidCallbackAccept: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>MembershipPage()));
      },
        voidCallbackCancel: (){

        }


    );
  }

  static Future<T?> showCustomDialog<T>({
    required BuildContext contextUp,
    required String title,
    required String textButtonCancel,
    required String textButtonAccept,
    required VoidCallback voidCallbackAccept,
    required VoidCallback voidCallbackCancel,
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
            //height: 200,
            padding: const EdgeInsets.only(left: 30.0,right: 30.0,top: 15.0,bottom: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: colorPrimary,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                        voidCallbackAccept();
                      },
                    ),
                    TextButton(
                      child:  Text(textButtonCancel,style:const TextStyle(
                          color: Colors.white,

                      )),
                      onPressed: () {
                            Navigator.pop(context);
                           voidCallbackCancel();
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
              child:  Text(textButtonCancel,textAlign: TextAlign.center,),
              onPressed: (){
                voidCallbackCancel();
                Navigator.pop(context);
              },
            ),
            if(textButtonAccept.isNotEmpty)...{
              TextButton(
                child:  Text(textButtonAccept,textAlign: TextAlign.center),
                onPressed: () {
                  Navigator.pop(context);
                  voidCallbackAccept();
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
      voidCallbackAccept: (){
        voidCallback();
      },
      voidCallbackCancel: (){

      }


    );
  }

  static void showBuyDialog(BuildContext context,String title,String count,bool isError,VoidCallback voidCallback,{required int isTakeBonus}) {
    String quantityBonus = count;
    if(isTakeBonus == 0){
      quantityBonus = '${int.parse(count) + 800}';
    }
    showCustomDialog(
        textButtonCancel: 'Ok',
        textButtonAccept: '',
        contextUp: context,
        title: title,
        titleColor: isError?colorRed:Platform.isIOS?colorPrimary:Colors.white,
        content:  Row(
          crossAxisAlignment:  CrossAxisAlignment.center,
          children: [
            Text('Transfers accrued'.tr(),style: TextStyle(
                color: Platform.isIOS?colorPrimary:Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.normal
            ),),
            Text(' $quantityBonus',style: TextStyle(
                color: Platform.isIOS?colorPrimary:Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.normal
            ),),
          ],
        ),
        voidCallbackAccept: (){
          voidCallback();
        },
        voidCallbackCancel: (){

        }

    );
  }

  static void showChannelSelectionMenu({required BuildContext context}){
     showModalBottomSheet(
       isScrollControlled: true,
       backgroundColor: Colors.transparent,
         context: context,
         builder: (_){
       return  BodyChannelSelectionMenu(
         onAddChannelByCode: (code){
           context.read<MainBloc>().add(AddChannelByInvitationEvent(codeInvitation: code));
         },
       );
     });
  }

  static void showNotSignedIn() {
    Fluttertoast.showToast(
      msg: 'Sign in or Sign up to continue.'.tr(),
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

class BodyChannelSelectionMenu extends StatefulWidget{
  const BodyChannelSelectionMenu({super.key,
  required this.onAddChannelByCode});

  final Function onAddChannelByCode;

  @override
  State<BodyChannelSelectionMenu> createState() => _BodyChannelSelectionMenuState();
}

class _BodyChannelSelectionMenuState extends State<BodyChannelSelectionMenu> {

  late TextEditingController _codeController;



  @override
  void initState() {
    super.initState();
    _codeController=TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(bottom:
      MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 350.0,
        decoration: BoxDecoration(
          color: colorPrimary,
          borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Text('Add channel with invitation code'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30.0
              ),),
            const SizedBox(height: 20.0),
            const Divider(),
            const SizedBox(height: 20.0),
            CodeField(controller: _codeController,textHint: 'Enter the invitation code'.tr()),
            const SizedBox(height: 20.0),
            Center(
              child: SubmitButton(
                colorsFill: colorRed,
                onTap: (){
                FocusScope.of(context).unfocus();
                if(_codeController.text.isNotEmpty){
                  widget.onAddChannelByCode.call(_codeController.text);
                  Navigator.pop(context);
                }else{
                  Dialoger.showMessage('Enter the invitation code'.tr());
                }

              },
                textButton: 'Add a channel'.tr(),),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionDialogLogOut extends StatefulWidget{
  const ActionDialogLogOut({super.key,required this.callback});

  final Function callback;

  @override
  State<ActionDialogLogOut> createState() => _ActionDialogLogOutState();
}

class _ActionDialogLogOutState extends State<ActionDialogLogOut> {
  var _isRemoveAccount=false;


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your data is saved on the server'.tr(),
              style: TextStyle(
                color: Platform.isIOS?colorPrimary:Colors.grey,

              ),),
            Row(
              children: [
                if(Platform.isAndroid)...{
                  Checkbox(
                      fillColor: MaterialStatePropertyAll(colorRed),
                      activeColor: colorRed,
                      value: _isRemoveAccount,
                      onChanged: (v){
                    setState(() {
                      _isRemoveAccount=v!;
                      widget.callback.call(_isRemoveAccount);
                    });

                  })
                }else...{
                  CupertinoCheckbox(
                      activeColor: colorRed,
                      value: _isRemoveAccount, onChanged: (v){
                    setState(() {
                      _isRemoveAccount=v!;
                      widget.callback.call(_isRemoveAccount);
                    });

                  })
                },

                Text('Sign out and delete account?'.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Platform.isIOS?colorPrimary:Colors.grey,

                  ),),
              ],
            )
          ],
        ),
    );
  }
}

class ActionDialogErrorTranslate extends StatefulWidget{
  const ActionDialogErrorTranslate({super.key,required this.listCodeLanguageErrorComplete});


  final List<String> listCodeLanguageErrorComplete;

  @override
  State<ActionDialogErrorTranslate> createState() => _ActionDialogErrorTranslateState();
}

class _ActionDialogErrorTranslateState extends State<ActionDialogErrorTranslate> {



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _parseListCodeLanguage(widget.listCodeLanguageErrorComplete),
            style: TextStyle(
                color: colorRed,
                fontSize: 18,
                fontWeight: FontWeight.w500
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '* ',
                style: TextStyle(
                    color: colorGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                ),
              ),
              Expanded(
                child: Text(
                  'Check if translation is possible in YouTube Studio'.tr(),
                  style: TextStyle(
                      color: colorGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ),
            ],
          ),
        ],
      )
    );
  }


  String _parseListCodeLanguage(List<String> listCodeLanguageErrorComplete){
    final  listMap=ListTranslate.codeListTranslate;
    List<String> listResult=[];
    for(var code in listCodeLanguageErrorComplete){
      String language=listMap[code]![0];
      listResult.add(language.tr());
    }
    String lisToString=listResult.toString().split('[')[1].split(']')[0];
    return lisToString;
  }

}