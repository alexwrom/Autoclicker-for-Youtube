





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

class TranslateBloc extends Bloc<TranslateEvent,TranslateState>{


    final _translateRepository=locator.get<TranslateRepository>();
    final _youTubeRepository=locator.get<YouTubeRepository>();
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

     TranslateBloc():super(TranslateState.unknown()){
        on<StartTranslateEvent>(_initTranslate);
        on<GetSubtitlesEvent>(_getCaption);


     }


     Future<void> _getCaption(GetSubtitlesEvent event,emit)async{
        emit(state.copyWith(captionStatus: CaptionStatus.loading));
        await Future.delayed(Duration(seconds: 3));
        emit(state.copyWith(captionStatus: CaptionStatus.success));
     }


     Future<void> _initTranslate(StartTranslateEvent event,emit)async{
       _clearVar();
       final num=event.videoModel.description.isEmpty?1:2;
       _codeList=event.codeLanguage;
       _operationQueueAll=(_codeList.length*num)+1;
       _operationQueueTotal=_operationQueueAll;
       event.videoModel.description.isNotEmpty?_operationQueueDescTrans=_codeList.length:0;
       _operationQueueTitleTrans=_codeList.length;
        emit(state.copyWith(translateStatus: TranslateStatus.translating));
       try{
         await _cycleTranslate(event.videoModel, event.codeLanguage);
       }on Failure catch(error){
         _clearVar();
         emit(state.copyWith(translateStatus: TranslateStatus.error,error: error.message));
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

  Future<void> _cycleTranslate(
      VideoModel videoModel, List<String> codeLanguage) async {
    if (_operationQueueAll > 0) {
      if (_operationQueueTitleTrans > 0) {
        final titleT =await _translateRepository.translate(codeLanguage[_indexTitle],videoModel.title);
        //await Future.delayed(Duration(seconds: 2));
        _titleTranslate.add(titleT);
        _indexTitle++;
        _operationQueueTitleTrans--;
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

        for (int i = 0; i < _titleTranslate.length; i++) {
            _mapUpdateLocalisation.addAll({
              codeLanguage[i]: VideoLocalization(
                  description: _descTranslate.isNotEmpty?_descTranslate[i]:'', title: _titleTranslate[i])
            });

        }
        await _youTubeRepository.updateLocalization(videoModel,_mapUpdateLocalisation);
        //await Future.delayed(Duration(seconds: 2));
      }

      _operationQueueAll--;
      _cycleTranslate(videoModel, codeLanguage);

      emit(state.copyWith(
          translateStatus: TranslateStatus.translating,
          progressTranslateDouble:
              _getProgressDouble(_operationQueueAll, _operationQueueTotal),
          progressTranslate:
              _getProgress(_operationQueueAll, _operationQueueTotal)));

      if (_operationQueueAll == 0) {
        _clearVar();
        emit(state.copyWith(translateStatus: TranslateStatus.success));
      }
    }
  }

















   }