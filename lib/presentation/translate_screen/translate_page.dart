


import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/domain/models/video_model.dart';
import 'package:youtube_clicker/presentation/main_screen/cubit/user_data_cubit.dart';
import 'package:youtube_clicker/presentation/main_screen/cubit/user_data_state.dart';
import 'package:youtube_clicker/resourses/colors_app.dart';

import '../../components/dialoger.dart';
import '../../data/models/hive_models/video.dart';
import '../../data/services/youtube_api_service.dart';
import '../../utils/parse_time_duration.dart';
import 'bloc/translate_bloc.dart';
import 'bloc/translate_event.dart';
import 'bloc/translate_state.dart';
import 'choise_language_page.dart';


class TranslatePage extends StatefulWidget{
  const TranslatePage({super.key,required this.videoModel});

  final VideoModel videoModel;

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {

   String _textButton='Translate title and description';
   late TranslateBloc _translateBloc;
   List<String> _listCodeLanguage=[];
   final boxVideo=Hive.box('video_box');




  @override
  Widget build(BuildContext context) {
    
    final _h=MediaQuery.of(context).size.height/3;
    if(widget.videoModel.description.isEmpty){
      _textButton='Translate title';
    }
    final balance=context.read<UserDataCubit>().state.userData.numberOfTrans;
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        elevation: 0,
        title:  Text(widget.videoModel.title,style:const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700
        ),),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context)=>_translateBloc,
          child: BlocConsumer<TranslateBloc,TranslateState>(
            listener: (_,stateLis){


            },
            builder: (context,state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: _h,
                          decoration: BoxDecoration(
                              color: colorPrimary,
                              borderRadius:const BorderRadius.only(bottomLeft: Radius.circular(60),bottomRight: Radius.circular(30))
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(60),bottomRight: Radius.circular(30)),
                            child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Icon(Icons.image_outlined,color: Colors.grey,size: 100),
                                errorWidget: (context, url, error) =>const Icon(Icons.error),
                                imageUrl: widget.videoModel.urlBanner),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 20,
                          child: Container(
                            padding:const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(ParseTimeDuration.toStringTimeVideo(widget.videoModel.duration),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700
                              ),),
                          ),
                        ),
                        Visibility(
                          visible: state.translateStatus.isSuccess||state.translateStatus.isTranslating||state.translateStatus.isError,
                          child: Container(
                            width: double.infinity,
                            height: _h,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.8),
                                borderRadius:const BorderRadius.only(bottomLeft: Radius.circular(60),bottomRight: Radius.circular(30))
                            ),
                            child: _progressIndicator(state.translateStatus,state.progressTranslate,state.progressTranslateDouble)
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 30,right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                          mainAxisAlignment : MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: colorPrimary,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                padding: const EdgeInsets.only(left: 10,top: 5,bottom: 5,right: 10),
                                child: Row(
                                  children: [
                                    const Text('Selected translations:',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400
                                      ),),
                                    const SizedBox(width: 10),
                                    ValueListenableBuilder<int>(
                                      valueListenable: notifiCodeList,
                                        builder: (context,value,child) {
                                          print('State Code Lang ${value}');
                                        return Text('${value}',
                                          style:const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700
                                          ),);
                                      }
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    )),
                                    backgroundColor: MaterialStateProperty.all(colorPrimary),
                                  ),

                                  onPressed:()async{
                                     Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ChoiceLanguagePage(idVideo:widget.videoModel.idVideo)));
                                     },
                                  child:const Icon(Icons.translate,color: Colors.white,)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: colorPrimary
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20,top: 5,right: 20,bottom: 5),
                                  decoration: BoxDecoration(
                                      color: colorRed,
                                      borderRadius:const BorderRadius.only(topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(5),
                                          bottomLeft: Radius.circular(5))
                                  ),
                                  child: const Text('Title:',style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700
                                  ),),
                                ),
                                 Padding(
                                   padding: const EdgeInsets.all(10.0),
                                   child: Text(widget.videoModel.title,style:const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400
                                ),),
                                 ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Visibility(
                            visible: widget.videoModel.description.isNotEmpty,
                            child: Container(
                              padding: const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: colorPrimary
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 20,top: 3,right: 20,bottom: 3),
                                    decoration: BoxDecoration(
                                      color: colorRed,
                                        borderRadius:const BorderRadius.only(topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(5),
                                            bottomLeft: Radius.circular(5))
                                    ),
                                    child: const Text('Description:',
                                        style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700
                                    ),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(widget.videoModel.description,style:const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Visibility(
                            visible: widget.videoModel.description.isNotEmpty,
                              child: const SizedBox(height: 20)),

                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                )),
                                backgroundColor: MaterialStateProperty.all(colorRed),
                              ),

                                onPressed:()async{
                                 if(!state.captionStatus.isTranslating&&!state.translateStatus.isTranslating){
                                   if(_listCodeLanguage.isNotEmpty){
                                     if(state.translateStatus.isForbidden){
                                       Dialoger.showNotTranslate(context,'The balance of active transfers is over');
                                     }else{
                                       if(balance<_listCodeLanguage.length){
                                         Dialoger.showNotTranslate(context,'You don\'t have enough translations');
                                       }else{
                                         Dialoger.showGetStartedTranslate(context,_listCodeLanguage.length, () {
                                           _translateBloc.add(StartTranslateEvent(
                                               codeLanguage: _listCodeLanguage,
                                               videoModel: widget.videoModel));
                                         });
                                       }

                                     }
                                   }else{
                                     Dialoger.showMessageSnackBar('No languages selected for translation', context);
                                   }
                                 }


                                 },
                                child: Text(_textButton,
                              style:const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                              ),)),
                          ),

                          const SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  )),
                                  backgroundColor: MaterialStateProperty.all(colorRed),
                                ),

                                onPressed:()async{


                                  if(!state.captionStatus.isTranslating&&!state.translateStatus.isTranslating){
                                    if(state.captionStatus.isSuccess){
                                      if(_listCodeLanguage.isNotEmpty){
                                        if(state.translateStatus.isForbidden){
                                          Dialoger.showNotTranslate(context,'The balance of active transfers is over');
                                        }else{
                                          if(balance<_listCodeLanguage.length){
                                            Dialoger.showNotTranslate(context,'You don\'t have enough translations');
                                          }else{
                                            Dialoger.showGetStartedTranslate(context,_listCodeLanguage.length, () {
                                              _translateBloc.add(StartTranslateEvent(
                                                  codeLanguage: _listCodeLanguage,
                                                  videoModel: widget.videoModel));
                                            });
                                          }

                                        }

                                      }else{
                                        Dialoger.showMessageSnackBar('No languages selected for translation', context);
                                      }
                                    }else if(state.captionStatus.isLoading){
                                      Dialoger.showMessageSnackBar('The titles haven\'t loaded yet', context);
                                    }else if(state.captionStatus.isError){
                                      Dialoger.showInfoDialog(context, 'Error!',
                                          'There were errors loading subtitles. Subtitle translation is not available. Try again later',true,(){});
                                    }else if(state.captionStatus.isEmpty){
                                      Dialoger.showInfoDialog(context, 'Titles missing!',
                                          'There are no subtitles. Download basic subtitles in Youtube Studio if you need them',false,(){});
                                    }
                                  }



                                },
                                child:const Text('Translate subtitle',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                  ),)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  Widget _progressIndicator(TranslateStatus status,String progress,double percent){
    String text='Loading localization...';
    if(status.isTranslating){
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 5.0,
            percent: percent,
            center:  Text(progress,
               style:const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400
            ),),
            progressColor: Colors.lightGreen,
          ),
          const SizedBox(height: 20),
          Text(text,style:const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400
          ),),
        ],
      ));
    }

    if(status.isSuccess){
      text='Localization completed successfully';
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline_rounded,color: Colors.lightGreen,size: 60,),
          const SizedBox(height: 20),
          Text(text,style:const TextStyle(
              color: Colors.lightGreen,
              fontSize: 18,
              fontWeight: FontWeight.w400
          ),),
        ],
      ));
    }

    if(status.isError){
      text='An error occurred during the download process';
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline,color: colorRed,size: 60),
          const SizedBox(height: 20),
          Text(text,style: TextStyle(
              color:colorRed,
              fontSize: 18,
              fontWeight: FontWeight.w400
          ),),
        ],
      ));
    }

  return Container();

  }

  @override
  void initState() {
    super.initState();
    _translateBloc=TranslateBloc();
    _translateBloc.add(GetSubtitlesEvent(videoId: widget.videoModel.idVideo));
    boxVideo.keys.map((key) {
      final Video value = boxVideo.get(key);
      _listCodeLanguage=value.codeLanguage;
    }).toList();
   notifiCodeList.value=_listCodeLanguage.length;
  }




  @override
  void dispose() {
    super.dispose();
    _translateBloc.close();
  }
}

