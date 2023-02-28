





   import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:hive/hive.dart';
import 'package:youtube_clicker/domain/models/video_model.dart';
import 'package:youtube_clicker/presentation/translate_screen/bloc/translate_event.dart';
import 'package:youtube_clicker/presentation/translate_screen/bloc/translate_state.dart';
import 'package:youtube_clicker/utils/failure.dart';

import '../../../di/locator.dart';
import '../../../domain/repository/translate_repository.dart';
import '../../../domain/repository/youtube_repository.dart';
import '../../main_screen/cubit/user_data_cubit.dart';

class TranslateBloc extends Bloc<TranslateEvent,TranslateState>{


    final _translateRepository=locator.get<TranslateRepository>();
    final _youTubeRepository=locator.get<YouTubeRepository>();
    final cubitUserData;
    final Map<String,VideoLocalization> _mapUpdateLocalisation={};
    final List<String> _titleTranslate=[];
    final List<String> _descTranslate=[];
    List<String> _codeList=[];
    late int _operationQueueAll;
    late int _operationQueueTotal;
    late int _operationQueueTitleTrans;
    late int _operationQueueDescTrans;
    int _indexTitle=0;
    int _indexDesc=0;
    String? idCap;
    List<Caption> _listCap=[];

     TranslateBloc({required this.cubitUserData}):super(TranslateState.unknown()){
        on<StartTranslateEvent>(_initTranslate,transformer: droppable());
        on<GetSubtitlesEvent>(_getCaption,transformer: droppable());
        on<InsertSubtitlesEvent>(_insertCaption,transformer: droppable());


     }


     Future<void> _getCaption(GetSubtitlesEvent event,emit)async{
        idCap='';

        if(cubitUserData.state.userData.numberOfTrans==0){
          emit(state.copyWith(translateStatus: TranslateStatus.forbidden));
        }
        emit(state.copyWith(captionStatus: CaptionStatus.loading));
        try {
        _listCap= await _youTubeRepository.loadCaptions(event.videoId);
        if(_listCap.isEmpty){
          emit(state.copyWith(captionStatus: CaptionStatus.empty));
        }else{
          idCap=_listCap[0].id;
          emit(state.copyWith(captionStatus: CaptionStatus.success));
        }

        }on Failure catch (e) {
         emit(state.copyWith(captionStatus: CaptionStatus.error,error: e.message));
        }
     }

     Future<void> _insertCaption(InsertSubtitlesEvent event,emit)async{
       print('_insertCaption');
       if(cubitUserData.state.userData.numberOfTrans==0){
         emit(state.copyWith(translateStatus: TranslateStatus.forbidden));
       }else{
         emit(state.copyWith(translateStatus: TranslateStatus.translating,progressTranslate: '0%',progressTranslateDouble: 0.0));
         final listCode=event.codesLang;
         int operationAll=listCode.length;
         int opTick=operationAll;

         try {
           for (var element in _listCap) {
             if(listCode.contains(element.snippet!.language)){
                 await _youTubeRepository.removeCaptions(element.id!);

             }

           }


           for(int i=0;i<operationAll;i++){
             opTick--;
            await _youTubeRepository.insertCaption(idCap: idCap!, idVideo: event.idVideo, codeLang:listCode[i]);
            // await Future.delayed(Duration(seconds: 2));
             emit(state.copyWith(
                 translateStatus: TranslateStatus.translating,
                 progressTranslateDouble:
                 _getProgressDouble(opTick, operationAll),
                 progressTranslate:
                 _getProgress(opTick, operationAll),messageStatus: 'Status CAP $i'));
             if(opTick==0){
               await cubitUserData.updateBalance(listCode.length);
               emit(state.copyWith(translateStatus: TranslateStatus.success,messageStatus: 'Status CAP $i'));
             }

           }
         }on Failure catch (e) {
           print('Error ${e.message}');
           emit(state.copyWith(translateStatus: TranslateStatus.error,error: e.message));
         }
       }



     }


     Future<void> _initTranslate(StartTranslateEvent event,emit)async{
       print('_initTranslate');
       _clearVar();
       if(cubitUserData.state.userData.numberOfTrans==0){
         emit(state.copyWith(translateStatus: TranslateStatus.forbidden));
       }else{
         final num=event.videoModel.description.isEmpty?1:2;
         _codeList=event.codeLanguage;
         _operationQueueAll=(_codeList.length*num)+1;
         _operationQueueTotal=_operationQueueAll;
         event.videoModel.description.isNotEmpty?_operationQueueDescTrans=_codeList.length:0;
         _operationQueueTitleTrans=_codeList.length;
         emit(state.copyWith(translateStatus: TranslateStatus.translating,progressTranslate: '0%',progressTranslateDouble: 0.0));
         try{
           await _cycleTranslate(event.videoModel, event.codeLanguage);
         }on Failure catch(error){
           _clearVar();
           emit(state.copyWith(translateStatus: TranslateStatus.error,error: error.message));
         }
       }






     }


     String _getProgress(int op,int allOp){
       final i=allOp-op;
       return '${((i*100)~/allOp).toString()}%';
     }

    double _getProgressDouble(int op,int allOp){
       final i=allOp-op;
       if(op==allOp){
         return 0.0;
       }else{
         return ((i*100)/allOp)/100;
       }


    }

     void _clearVar(){
       _operationQueueAll=0;
       _operationQueueTitleTrans=0;
       _operationQueueDescTrans=0;
       _indexTitle=0;
       _indexDesc=0;
       _titleTranslate.clear();
       _descTranslate.clear();
       _mapUpdateLocalisation.clear();
     }

  Future<void> _cycleTranslate(VideoModel videoModel, List<String> codeLanguage) async {
       int codeState=-1;
    if (_operationQueueAll > 0) {
      if (_operationQueueTitleTrans > 0) {
        try {
          final titleT =await _translateRepository.translate(codeLanguage[_indexTitle],videoModel.title);
          final textTitleLimit=titleT.substring(0,100);
          _titleTranslate.add(textTitleLimit);
          _indexTitle++;
          _operationQueueTitleTrans--;
        } on Failure catch (e) {
          emit(state.copyWith(translateStatus: TranslateStatus.error,error: e.message));
        }
        //await Future.delayed(Duration(seconds: 2));
      } else if (_operationQueueTitleTrans == 0) {
        if (_operationQueueDescTrans > 0) {
          //await Future.delayed(Duration(seconds: 2));
          final descT= await _translateRepository.translate(codeLanguage[_indexDesc],videoModel.description);
          _descTranslate.add(descT);
          _indexDesc++;
          _operationQueueDescTrans--;
        }
      }

      if (_operationQueueAll == 1) {
        if(_titleTranslate.isEmpty){
          emit(state.copyWith(translateStatus: TranslateStatus.error,error:'List code empty...'));
        }else{
          for (int i = 0; i < _titleTranslate.length; i++) {
            _mapUpdateLocalisation.addAll({
              codeLanguage[i]: VideoLocalization(
                  description: _descTranslate.isNotEmpty?_descTranslate[i]:'', title: _titleTranslate[i])
            });
            if(i==_titleTranslate.length-1){
              if(_mapUpdateLocalisation.isNotEmpty){
                codeState= await _youTubeRepository.updateLocalization(videoModel,_mapUpdateLocalisation);
              }else{
                emit(state.copyWith(translateStatus: TranslateStatus.error,error:'List empty'));
              }

            }
          }
        }
        //await Future.delayed(Duration(seconds: 2));
      }

      _operationQueueAll--;
      _cycleTranslate(videoModel, codeLanguage);

      emit(state.copyWith(
          translateStatus: TranslateStatus.translating,
          progressTranslateDouble:
              _getProgressDouble(_operationQueueAll, _operationQueueTotal),
          progressTranslate:
              _getProgress(_operationQueueAll, _operationQueueTotal),messageStatus: 'Status TD $_operationQueueAll Code $codeState CL = ${videoModel.defaultLanguage}'));

      if (_operationQueueAll == 0) {
        _clearVar();
        await cubitUserData.updateBalance(codeLanguage.length);
        emit(state.copyWith(translateStatus: TranslateStatus.success,messageStatus: 'Status TD $_operationQueueAll Code $codeState CL = ${videoModel.defaultLanguage}'));

      }
    }


  }

















   }