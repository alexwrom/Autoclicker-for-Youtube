

 import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtil{

  static SharedPreferences? _prefsInstance;


  static Future<SharedPreferences?> init() async {
   _prefsInstance = await SharedPreferences.getInstance();
   return _prefsInstance;
  }


  static Future<void> setHeadersGoogleApi(Map<String,String> header)async{
       final headerToString=json.encode(header);
      await _prefsInstance!.setString(prefsKeyGoogleToken, headerToString);
  }

  static Future<void> setUrlAvatar(String url)async{
    await _prefsInstance!.setString(prefsKeyUrlAvatar, url);
  }



  static Future<void> setUserName(String name)async{
    await _prefsInstance!.setString(prefsKeyUserName, name);
  }

  static Future<void> setUserId(String uid)async{
    await _prefsInstance!.setString(prefsKeyUid, uid);
  }

  static Future<void> setEmail(String email)async{
    await _prefsInstance!.setString(prefsKeyEmail, email);
  }

  static Future<void> setPassword(String password)async{
    await _prefsInstance!.setString(prefsKeyPassword, password);
  }

  static Future<void> setKeyHave(int key)async{
    await _prefsInstance!.setInt(prefsKeyVideoHave, key);
  }

  static Future<void> setCodeVerificationEmail(List<String> codeData)async{
    await _prefsInstance!.setStringList(prefsKeyVerifiEmail, codeData);
  }


  ///0 - code verification 1 - time stamp
  static List<String> get getCOdeVerificationEmail=>_prefsInstance!.getStringList(prefsKeyVerifiEmail)??['',''];
  ///
  static String get getPassword=>_prefsInstance!.getString(prefsKeyPassword)??'';
  static String get getHeaderApiGoogle =>_prefsInstance!.getString(prefsKeyGoogleToken)??'';
  static String get getUrlAvatar=>_prefsInstance!.getString(prefsKeyUrlAvatar)??'';
  static String get getUserName=>_prefsInstance!.getString(prefsKeyUserName)??'';
  static String get getUid=>_prefsInstance!.getString(prefsKeyUid)??'';
  static String get getEmail=>_prefsInstance!.getString(prefsKeyEmail)??'';
  static int get getKey=>_prefsInstance!.getInt(prefsKeyVideoHave)??0;

  static clear()async{
   await _prefsInstance!.clear();

  }


 }

  const String prefsKeyPassword='password';
  const String prefsKeyVerifiEmail='cede_email';
  const String prefsKeyGoogleToken='token';
  const String prefsKeyUrlAvatar='avatar';
  const String prefsKeyUserName='name';
  const String prefsKeyUid='uid';
  const String prefsKeyEmail='email';
  const String prefsKeyVideoHave='key_video';