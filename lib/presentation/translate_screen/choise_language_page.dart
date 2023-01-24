

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:youtube_clicker/data/models/hive_models/video.dart';
import 'package:youtube_clicker/data/models/list_translate_api.dart';
import 'package:youtube_clicker/resourses/colors_app.dart';

import '../../components/dialoger.dart';
import '../../utils/failure.dart';

class ChoiceLanguagePage extends StatefulWidget{
   const ChoiceLanguagePage({super.key,required this.idVideo});
   final String idVideo;
  @override
  State<ChoiceLanguagePage> createState() => _ChoiceLanguagePageState();
}

class _ChoiceLanguagePageState extends State<ChoiceLanguagePage> {




   List<String> _choiceCodeLanguageList=[];
   final boxVideo=Hive.box('video_box');
   dynamic _keyHiveVideo;
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
                  const  Text('Choose a language for translation',style: TextStyle(
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
                          child: Column(
                            children: List.generate(ListTranslate.codeListTranslate.length, (index){
                                return _ItemLanguage(
                                  listChoice:_choiceCodeLanguageList,
                                    codeLanguage: ListTranslate.langCode(index),
                                    title: ListTranslate.langName(index, Local.en),
                                    index: index,
                                    callback: (i){
                                      if(i!['add']){
                                        setState(() {
                                          _addChoiceCodeLanguage(ListTranslate.langCode(i['index']),widget.idVideo);
                                        });
                                      }else{
                                        setState(() {
                                          _removeChoiceCodeLanguage(ListTranslate.langCode(i['index']),widget.idVideo);
                                        });
                                      }

                                    },);
                            }),
                          ),
                        ),
                     ),
                     Visibility(
                       visible: _choiceCodeLanguageList.isNotEmpty,
                       child: Positioned(
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
                              Navigator.pop(context,_choiceCodeLanguageList);
                             },
                             child:const Text('Download translation',
                               style: TextStyle(
                                   color: Colors.white,
                                   fontSize: 16,
                                   fontWeight: FontWeight.w500
                               ),)),
                       ),
                     ),
                   ],
                 ))
              ],
            ),
          );
  }

   List<String> _getListChoiceCodeLanguage(String idVideo){
       List<String> codesList=[];
       boxVideo.keys.map((key) {
         final Video value = boxVideo.get(key);
          if(idVideo==value.id){
            _keyHiveVideo=key;
            codesList=value.codeLanguage;
          }
       }).toList();
       return codesList;
    }


    _addChoiceCodeLanguage(String code,String idVideo)async{
      if(_choiceCodeLanguageList.isEmpty){
       _keyHiveVideo=await boxVideo.add(Video(id: idVideo, codeLanguage: _choiceCodeLanguageList));
      }else{
        boxVideo.put(_keyHiveVideo, Video(id: idVideo, codeLanguage: _choiceCodeLanguageList));
      }
      _choiceCodeLanguageList.add(code);

    }

    _removeChoiceCodeLanguage(String code,String idVideo){
      _choiceCodeLanguageList.remove(code);
      try{
        boxVideo.put(_keyHiveVideo, Video(id: idVideo, codeLanguage: _choiceCodeLanguageList));
      }on HiveError catch(error,stackTrace){
         Dialoger.showError(error.message, context);
        Error.throwWithStackTrace(Failure(error.toString()), stackTrace);
      }



    }

   @override
  void initState() {
    super.initState();
  _choiceCodeLanguageList=_getListChoiceCodeLanguage(widget.idVideo);

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
        fillColor: MaterialStatePropertyAll(colorRed),
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