

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:youtube_clicker/data/models/hive_models/channel_lang_code.dart';
import 'package:youtube_clicker/data/models/list_translate_api.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/presentation/main_screen/cubit/user_data_cubit.dart';
import 'package:youtube_clicker/resourses/colors_app.dart';
import 'package:youtube_clicker/utils/preferences_util.dart';

import '../../components/dialoger.dart';
import '../../domain/models/channel_model_cred.dart';
import '../../utils/failure.dart';

class ChoiceLanguagePage extends StatefulWidget{
   const ChoiceLanguagePage({super.key,required this.idVideo,required this.credChannel});
   final String idVideo;
   final ChannelModelCred credChannel;


  @override
  State<ChoiceLanguagePage> createState() => _ChoiceLanguagePageState();
}

class _ChoiceLanguagePageState extends State<ChoiceLanguagePage> {




   late List<String> _choiceCodeLanguageList;
   Map<String,String> _codeLanguageMap={};
   final boxVideo=Hive.box('video_box');
   //dynamic _keyHiveVideo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: Column(
        children: [
          Container(
            height: 100,
            padding: const EdgeInsets.only(top: 30,left: 20,right: 20),
            decoration: BoxDecoration(
                color: colorPrimary,
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(40))
            ),
            child: Row(
              children: [
                IconButton(onPressed: () {
                  Navigator.pop(context);
                },
                    icon: const Icon(Icons.arrow_back,color: Colors.white)),
                const SizedBox(width: 10),
                    Text('Choose a language for translation'.tr(),style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                    ),),
                  ],
                ),),
                 Expanded(child:
                 Stack(
                   children: [
                     SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30,right: 15),
                          child: FutureBuilder<List<String>>(
                            future:  _sortListLanguagesByABC(ListTranslate.codeListTranslate),
                            builder: (context,list) {
                              if(!list.hasData){
                                return Container();
                              }
                              return Column(
                                children: List.generate(ListTranslate.codeListTranslate.length, (index){
                                    return _ItemLanguage(
                                      listChoice:_choiceCodeLanguageList,
                                        codeLanguage: _languageCodeByLanguage(list.data![index]),
                                        title: list.data![index],
                                        index: index,
                                        callback: (i){
                                          var code=_languageCodeByLanguage(list.data![i!['index']]);
                                          if(i['add']){
                                            _addChoiceCodeLanguage(widget.credChannel.keyLangCode,code,widget.idVideo);
                                          }else{
                                            _removeChoiceCodeLanguage(widget.credChannel.keyLangCode,code,widget.idVideo);
                                          }

                                        },);
                                }),
                              );
                            }
                          ),
                        ),
                     ),
                     Positioned(
                       bottom: 40,
                       right: 40,
                       child: ElevatedButton(
                           style: ButtonStyle(
                             shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(20)
                             )),
                             backgroundColor: MaterialStateProperty.all(colorRed),
                           ),

                           onPressed:(){
                            Navigator.pop(context);
                           },
                           child: Text('Back'.tr(),
                             style: const TextStyle(
                                 color: Colors.white,
                                 fontSize: 16,
                                 fontWeight: FontWeight.w500
                             ),)),
                     ),
                   ],
                 ))
              ],
            ),
          );
  }


   Future<List<String>> _sortListLanguagesByABC(Map defList)async{
    List<String> translateList=[];
     for (int i=0;i<defList.length; i++) {
      var key=defList.keys.elementAt(i);
      var lang=defList[key]![0].toString();
      var langTrans=lang.tr();
      translateList.add(langTrans);
      _codeLanguageMap[langTrans]=key;
     }
     translateList.sort();
     return translateList;

   }

    String _languageCodeByLanguage(String language){
       return _codeLanguageMap[language]??'';
   }
   List<String> _getListChoiceCodeLanguage(int keyLangCode){
       List<String> codesList=[];
       ChannelLangCode value = boxVideo.get(keyLangCode);
       codesList=value.codeLanguage;
       // boxVideo.keys.map((key) {
       //    ChannelLangCode value = boxVideo.get(key);
       //      codesList=value.codeLanguage;
       // }).toList();
       return codesList;
    }


    _addChoiceCodeLanguage(int keyLangCode,String code,String idChannel)async{
      boxVideo.put(keyLangCode, ChannelLangCode(id: idChannel, codeLanguage: _choiceCodeLanguageList));
      _choiceCodeLanguageList.add(code);
      notifiCodeList.value=_choiceCodeLanguageList.length;
    }

    _removeChoiceCodeLanguage(int keyLangCode,String code,String idVideo){
      _choiceCodeLanguageList.remove(code);
      try{
        boxVideo.put(keyLangCode, ChannelLangCode(id: idVideo, codeLanguage: _choiceCodeLanguageList));
        notifiCodeList.value=_choiceCodeLanguageList.length;
      }on HiveError catch(error,stackTrace){
         Dialoger.showError(error.message, context);
        Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
      }





    }


   @override
  void dispose() {
  super.dispose();
  }

  @override
  void initState() {
    super.initState();
   _choiceCodeLanguageList=_getListChoiceCodeLanguage(widget.credChannel.keyLangCode);
   // _keyHiveVideo=PreferencesUtil.getKey;
  }
}

  class _ItemLanguage extends StatefulWidget{
     _ItemLanguage({required this.index,required this.title,required this.callback,required this.codeLanguage,required this.listChoice});
    final int index;
    final String title;
    final List<String> listChoice;
    final String codeLanguage;
     var callback=(Map<String,dynamic>? map)=>map;

  @override
  State<_ItemLanguage> createState() => _ItemLanguageState();


}

class _ItemLanguageState extends State<_ItemLanguage> {

  late bool _value;


   @override
  void initState() {
    super.initState();
   _value=widget.listChoice.contains(widget.codeLanguage);

  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        activeColor: colorRed,
        value: _value,
        onChanged: (bool? value) {
              setState(() {
                _value=value!;
                widget.callback({
                  'index':widget.index,
                   'add':_value});
              });
        },),
      title: Text(widget.title,
        style:const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400
        ),),
    );
  }
}