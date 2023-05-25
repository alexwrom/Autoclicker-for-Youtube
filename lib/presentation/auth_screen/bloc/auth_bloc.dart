



import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/domain/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:youtube_clicker/utils/preferences_util.dart';

import '../../../utils/failure.dart';






part 'auth_event.dart';
part 'auth_state.dart';



enum LocalStatus{
  ru,
  en
}







class AuthBloc extends Bloc<AuthEvent, AuthState> {


   final _authRepository=locator.get<AuthRepository>();
   final boxVideo=Hive.box('video_box');


  AuthBloc()
      : super(AuthState.unknown()) {
    on<LogOutEvent>(_logOut);
    on<SingInEvent>(_singIn);
    on<LogInEvent>(_logIn);
    on<Unknown>(_resetState);
    on<ForgotEvent>(_forgotPass);
    on<SendCodeEmail>(_sendCodeToEmail);

  }


   void _forgotPass(ForgotEvent event,emit) async{

     emit(state.copyWith(authStatus: AuthStatus.processForgot));
     try{
       final result=  await _authRepository.forgotPass(email: event.email,newPass: event.newPass);
       if(result){
         emit(state.copyWith(authStatus: AuthStatus.successNewPass));
       }else if(event.newPass.contains('abc')){
         emit(state.copyWith(authStatus: AuthStatus.sendToEmail));
       }else if(event.newPass!='abc'){
         emit(state.copyWith(authStatus: AuthStatus.processUpdatePass));
       }


     }on Failure catch(error){

       emit(state.copyWith(authStatus: AuthStatus.error,error: error.message));
     }
   }

   void _resetState(Unknown event,emit)async{
     emit(state.copyWith(authStatus: AuthStatus.unknown));
   }

   void _sendCodeToEmail(SendCodeEmail event,emit)async{
     emit(state.copyWith(authStatus: AuthStatus.processSingIn));
     try {
       if(event.email.isEmpty){
              throw const Failure('Enter email');
            }else if(event.password.isEmpty){
              throw const Failure('Enter password');
            }else if(event.repPass.isEmpty){
              throw const Failure('Repeat password');
            }else if(event.password!=event.repPass){
              throw const Failure('Password mismatch');
            }
       await FirebaseAuth.instance.signInAnonymously();
       DocumentSnapshot userDoc=await FirebaseFirestore.instance.collection('userpc').doc(event.email).get();
       if(userDoc.exists){
         throw const Failure('This user already exists');
       }else{
         final code =  (Random().nextInt(60000)+10000).toString();
         final ts=DateTime.now().millisecondsSinceEpoch.toString();
         await PreferencesUtil.setEmail(event.email);
         await PreferencesUtil.setPassword(event.password);
         await PreferencesUtil.setCodeVerificationEmail([code,ts]);
         await _sendEmail(event.email, code);
         emit(state.copyWith(authStatus: AuthStatus.verificationCodeExist));
       }

     }on Failure catch (e) {
       emit(state.copyWith(authStatus: AuthStatus.error,error: e.message));
     }on MailerException catch(e){
       emit(state.copyWith(authStatus: AuthStatus.error,error: e.message));
     }on  FirebaseAuthException catch(error){
       emit(state.copyWith(authStatus: AuthStatus.error,error: error.message));

     }




   }

   _sendEmail(String email,String code)async{
    final htmlBody=_htmlBody(code);
    String username = '';
    String password = '';
    String host='';
    int port=0;

    try {
      await FirebaseAuth.instance.signInAnonymously();
      final doc=await FirebaseFirestore.instance.collection('settings').doc('setting').get();
      username=doc.get('SMTPlogin');
      password=doc.get('SMTPpassword');
      host=doc.get('SMTPHost');
      port=doc.get('SMTPPort');
    } on  FirebaseAuthException catch(error){
      PreferencesUtil.setPassword('');
      PreferencesUtil.setCodeVerificationEmail(['','']);
      throw Failure(error.message!);

    }
    final smtpServer = SmtpServer(host,
    port: port,
    ssl: true,
    username: username,
    password: password);
    final message = Message()
      ..from = Address(username, 'YouClicker')
      ..recipients.add(email)
      ..html = htmlBody;

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      PreferencesUtil.setPassword('');
      PreferencesUtil.setCodeVerificationEmail(['','']);

     throw Failure(e.message);
    }
   }

   String _htmlBody(String code){
    return """""<html>
     <head>
	   <title>be1.ru</title>
   </head>
   <body>
   <p style="text-align:center"><img alt="" src="https://play-lh.googleusercontent.com/-v_3PwP5PejV308DBx8VRtOWp2W_nkgIBZOt1X536YwGD7ytPPI2of2h3hG_uk7siAuh=w240-h480-rw" style="height:100px; width:100px" /></p>

   <hr />
   <p style="text-align:center"><strong>Dear user of the YouClicker application.</strong></p>

   <p style="text-align:center">An email has been sent to you in response to a request to create an account for the YouClicker application.</p>

   <p style="text-align:center"><strong>Confirm code: </strong>$code</p>

   <hr />
    <p style="text-align:center"><span style="color:#e74c3c">If you did not send this request, please ignore this email.</span></p>
    </body>
    </html>""""";
   }

   void _singIn(SingInEvent event,emit)async{
     emit(state.copyWith(authStatus: AuthStatus.processSingIn));
     try{
       final code=PreferencesUtil.getCOdeVerificationEmail[0];
       if(event.code!=code){
         throw const Failure('Incorrect code');
       }
       await _authRepository.singIn(pass: event.password,email: event.email);
       emit(state.copyWith(authStatus: AuthStatus.authenticated));

       await Future.delayed(const Duration(milliseconds: 2000));
       PreferencesUtil.setPassword('');
       PreferencesUtil.setCodeVerificationEmail(['','']);
       emit(state.copyWith(authStatus: AuthStatus.completeSingIn));
     }on Failure catch(error){
       emit(state.copyWith(authStatus: AuthStatus.error,error: error.message));
     }


   }

   void _logIn(LogInEvent event,emit)async{
     emit(state.copyWith(authStatus: AuthStatus.processLogIn));
     try{
       final result= await _authRepository.logIn(pass: event.password,email: event.email);
       if(result){
         emit(state.copyWith(authStatus: AuthStatus.authenticated));
       }
     }on Failure catch(error){
       emit(state.copyWith(authStatus: AuthStatus.error,error: error.message));
     }


   }





  void _singInGoogle(SingInEvent event,emit)async{
    emit(state.copyWith(authStatus: AuthStatus.processSingIn));
    try{
     await _authRepository.singInGoogle();
     emit(state.copyWith(authStatus: AuthStatus.authenticated));
    }on Failure catch(error){
      emit(state.copyWith(authStatus: AuthStatus.error,error: error.message));
    }


  }
  void _logOut(event,emit) async{
    emit(state.copyWith(authStatus: AuthStatus.processLogOut));
    try{
      await _authRepository.logOut(isDelAcc:event.isDeleteAcc);
      emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
    }on Failure catch(error){
      emit(state.copyWith(authStatus: AuthStatus.error,error: error.message));
    }
  }







  }

