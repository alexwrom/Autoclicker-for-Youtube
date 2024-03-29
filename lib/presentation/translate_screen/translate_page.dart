


import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
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
import '../../data/models/hive_models/channel_lang_code.dart';
import '../../data/services/youtube_api_service.dart';
import '../../domain/models/channel_model_cred.dart';
import '../../utils/parse_time_duration.dart';
import '../main_screen/bloc/main_bloc.dart';
import '../main_screen/bloc/main_event.dart';
import 'bloc/translate_bloc.dart';
import 'bloc/translate_event.dart';
import 'bloc/translate_state.dart';
import 'choise_language_page.dart';


class TranslatePage extends StatefulWidget{
  const TranslatePage({super.key,required this.videoModel,required this.credChannel});

  final VideoModel videoModel;
  final ChannelModelCred credChannel;

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {

   String _textButton='Translate title and description'.tr();
   late TranslateBloc _translateBloc;
   List<String> _listCodeLanguage=[];
   final boxVideo=Hive.box('video_box');
   late ChannelModelCred _channelModelCred;
   bool _tranlatingSubtitle = false;


   void _updateChannel({required ChannelModelCred channelModelCred,required int translateQuantity}) async {
     if(channelModelCred.bonus>0){
       int totalBonus = 0;
       int bonusOfRemoteChannel = channelModelCred.bonus;
       int numberTranslate = translateQuantity;
       final res = bonusOfRemoteChannel - numberTranslate;
       if(res<0){
         totalBonus = 0;
       }else {
         totalBonus = res;
       }
       ChannelModelCred channel = channelModelCred;
       channel = channel.copyWith(bonus:totalBonus);
       _channelModelCred = channel;
       print('Update bonus ${_channelModelCred.bonus}');
     }
   }

  @override
  Widget build(BuildContext context) {

    final _h=MediaQuery.of(context).size.height/3;
    if(widget.videoModel.description.isEmpty){
      _textButton='Translate title'.tr();
    }




    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        actions: [
          Expanded(
            child: Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.pop(context,_channelModelCred);
                }, icon: const Icon(Icons.arrow_back),color: Colors.white),
                Text(widget.videoModel.title,style:const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                ),),
              ],
            ),
          ),
        ],
        // iconTheme: const IconThemeData(
        //   color: Colors.white, //change your color here
        // ),
        elevation: 0,
        // title:  Text(widget.videoModel.title,style:const TextStyle(
        //     color: Colors.white,
        //     fontSize: 18,
        //     fontWeight: FontWeight.w700
        // ),),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context)=>_translateBloc,
          child: BlocConsumer<TranslateBloc,TranslateState>(
            listener: (_,stateLis){
              if(stateLis.translateStatus.isError){
                if(stateLis.listCodeLanguageNotSuccessful.isNotEmpty){
                  Dialoger.showErrorCompleteTranslate(
                      listErrorCompleteTranslate:stateLis.listCodeLanguageNotSuccessful,
                      context: context,
                       callRepeatTranslate: (){
                         _translateBloc.add(InsertSubtitlesEvent(
                           cred: _channelModelCred,
                           repeatTranslate: true,
                             defaultAudioLanguage: widget.videoModel.defaultAudioLanguage,
                             codesLang: stateLis.listCodeLanguageNotSuccessful,
                             idVideo: widget.videoModel.idVideo));
                       });
                }else{
                  Dialoger.showError(stateLis.error, context);
                }

              }

              if(stateLis.translateStatus == TranslateStatus.initTranslate){
                if(_tranlatingSubtitle){
                  _initTranslateSubtitle(stateLis, context);
                }else{
                  _initTranslate(context, stateLis);
                }

              }
              if(stateLis.translateStatus.isForbidden){
                //Dialoger.showNotTranslate(context,'The balance of active transfers is over'.tr());
                Dialoger.showNotTranslate(context,'You don\'t have enough translations'.tr(),_channelModelCred);
              }

              if(stateLis.translateStatus.isSuccess){
                context.read<MainBloc>().add(UpdateChannelListEvent(channelModelCred: _channelModelCred,
                    translateQuantity: _listCodeLanguage.length));
                _updateChannel(channelModelCred: _channelModelCred,
                    translateQuantity: _listCodeLanguage.length);
              }

              if(stateLis.translateStatus == TranslateStatus.updateBonusLocal){
                _channelModelCred = stateLis.updatedChannel;
                context.read<MainBloc>().add(UpdateBonusEvent(
                channelModelCred: stateLis.updatedChannel));
              }

              // if(stateLis.translateStatus == TranslateStatus.updateBalanceLocal){
              //   context.read<MainBloc>().add(UpdateBalanceEvent(
              //       updateBalance: stateLis.updatedBalance));
              // }




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
                                     Text('Selected translations:'.tr(),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400
                                      ),),
                                    const SizedBox(width: 10),
                                    ValueListenableBuilder<int>(
                                      valueListenable: notifiCodeList,
                                        builder: (context,value,child) {
                                        return Text('$value',
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
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ChoiceLanguagePage(
                                          idVideo: widget.videoModel.idVideo,
                                          credChannel: _channelModelCred)));
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
                                  child:  Text('Title:'.tr(),style: const TextStyle(
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
                                    child:  Text('Description:'.tr(),
                                        style: const TextStyle(
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
                                  _tranlatingSubtitle = false;
                                context.read<TranslateBloc>().add(CheckBalanceEvent(
                                    channelModelCred: _channelModelCred,
                                    codeLanguage: _listCodeLanguage,
                                    videoModel: widget.videoModel));



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
                                  _tranlatingSubtitle = true;
                                  context.read<TranslateBloc>().add(CheckBalanceEvent(
                                      channelModelCred: _channelModelCred,
                                      codeLanguage: _listCodeLanguage,
                                      videoModel: widget.videoModel));


                                  },
                                child: Text('Translate subtitle'.tr(),
                                  style: const TextStyle(
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

  void _initTranslateSubtitle(TranslateState state, BuildContext context) {
    if(!state.captionStatus.isTranslating&&!state.translateStatus.isTranslating){
      if(state.captionStatus.isSuccess){
        if(_listCodeLanguage.isNotEmpty){
          if(state.translateStatus.isForbidden){
            //Dialoger.showNotTranslate(context,'The balance of active transfers is over'.tr());
            Dialoger.showNotTranslate(context,'You don\'t have enough translations'.tr(),_channelModelCred);
          }else{
            Dialoger.showGetStartedTranslate(context,_listCodeLanguage.length, () {
                _translateBloc.add(InsertSubtitlesEvent(
                    cred: _channelModelCred,
                    defaultAudioLanguage: widget.videoModel.defaultAudioLanguage,
                    codesLang: _listCodeLanguage,
                    repeatTranslate: false,
                    idVideo: widget.videoModel.idVideo));
              },
            _channelModelCred);


          }

        }else{
         Dialoger.showMessageSnackBar('No languages selected for translation'.tr(), context);
        }
      }else if(state.captionStatus.isLoading){
        Dialoger.showMessageSnackBar('The titles haven\'t loaded yet'.tr(), context);
      }else if(state.captionStatus.isError){
        Dialoger.showInfoDialog(context, 'Error!'.tr(),
            'There were errors loading subtitles. Subtitle translation is not available. Try again later'.tr(),true,(){});
      }else if(state.captionStatus.isEmpty){
        Dialoger.showInfoDialog(context, 'Titles missing!'.tr(),
           'There are no subtitles. Download basic subtitles in Youtube Studio if you need them'.tr(),false,(){});
      }
    }


  }

  void _initTranslate(BuildContext context, TranslateState state) {
    if (widget.videoModel.defaultLanguage.isEmpty&&_channelModelCred.defaultLanguage.isEmpty) {
      Dialoger.showInfoDialog(
          context,
          'There are no localization settings on the channel'.tr(),
          'You need to set the language of the title and description of the video in your channel settings'.tr(),
          false,
          () {});
    } else {
      if(!state.captionStatus.isTranslating&&!state.translateStatus.isTranslating){
        if(_listCodeLanguage.isNotEmpty){
          if(state.translateStatus.isForbidden){
            //Dialoger.showNotTranslate(context,'The balance of active transfers is over'.tr());
            Dialoger.showNotTranslate(context,'You don\'t have enough translations'.tr(),_channelModelCred);
          }else{
            Dialoger.showGetStartedTranslate(context,_listCodeLanguage.length,
                    () {
                _translateBloc.add(StartTranslateEvent(
                    channelModelCred: _channelModelCred,
                    codeLanguage: _listCodeLanguage,
                    videoModel: widget.videoModel));
              },
              _channelModelCred);


          }
        }else{
          Dialoger.showMessageSnackBar('No languages selected for translation'.tr(), context);
        }
      }
    }
  }

  Widget _progressIndicator(TranslateStatus status,String progress,double percent){
    String text='Loading localization...'.tr();
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
      text='Localization completed successfully'.tr();
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
      text='An error occurred during the download process'.tr();
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
    _channelModelCred = widget.credChannel;
    final ChannelLangCode value = boxVideo.get(_channelModelCred.keyLangCode);
    _listCodeLanguage=value.codeLanguage;
    _translateBloc=TranslateBloc(cubitUserData: context.read<UserDataCubit>());
    _translateBloc.add(GetSubtitlesEvent(
      codesLang: _listCodeLanguage,
      defaultAudioLanguage: widget.videoModel.defaultAudioLanguage,
        videoId: widget.videoModel.idVideo,cred: _channelModelCred));
    // boxVideo.keys.map((key) {
    //   final ChannelLangCode value = boxVideo.get(widget.credChannel.keyLangCode);
    //   _listCodeLanguage=value.codeLanguage;
    // }).toList();
   notifiCodeList.value=_listCodeLanguage.length;
  }




  @override
  void dispose() {
    super.dispose();
    _translateBloc.close();
  }
}

