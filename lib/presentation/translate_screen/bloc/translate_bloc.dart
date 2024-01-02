

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:youtube_clicker/domain/models/video_model.dart';
import 'package:youtube_clicker/presentation/translate_screen/bloc/translate_event.dart';
import 'package:youtube_clicker/presentation/translate_screen/bloc/translate_state.dart';
import 'package:youtube_clicker/utils/failure.dart';

import '../../../di/locator.dart';
import '../../../domain/models/channel_model_cred.dart';
import '../../../domain/repository/translate_repository.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../domain/repository/youtube_repository.dart';
import '../../main_screen/bloc/main_bloc.dart';
import '../../main_screen/cubit/user_data_cubit.dart';

class TranslateBloc extends Bloc<TranslateEvent, TranslateState> {
  final _translateRepository = locator.get<TranslateRepository>();
  final _userRepository = locator.get<UserRepository>();
  final _youTubeRepository = locator.get<YouTubeRepository>();
  late UserDataCubit cubitUserData;
  final Map<String, VideoLocalization> _mapUpdateLocalisation = {};
  final List<String> _titleTranslate = [];
  final List<String> _descTranslate = [];
  List<String> _codeList = [];
  late int _operationQueueAll;
  late int _operationQueueTotal;
  late int _operationQueueTitleTrans;
  late int _operationQueueDescTrans;
  int _indexTitle = 0;
  int _indexDesc = 0;
  String? idCap;
  List<Caption> _listCap = [];
  final List<String> _oldCodeList = [];


  TranslateBloc({required this.cubitUserData})
      : super(TranslateState.unknown()) {
    on<StartTranslateEvent>(_initTranslate, transformer: droppable());
    on<GetSubtitlesEvent>(_getCaption, transformer: droppable());
    on<InsertSubtitlesEvent>(_insertCaption, transformer: droppable());
    on<CheckBalanceEvent>(_checkBalance);
  }

  Future<void> _getCaption(GetSubtitlesEvent event, emit) async {
    idCap = '';
    // if (_balanceEmpty(cubitUserData.state.userData.numberOfTrans,
    //     event.cred.bonus,event.codesLang.length)) {
    //   emit(state.copyWith(translateStatus: TranslateStatus.forbidden));
    // }
    emit(state.copyWith(captionStatus: CaptionStatus.loading,translateStatus: TranslateStatus.unknown));
    try {
      _listCap =
          await _youTubeRepository.loadCaptions(event.videoId, event.cred);
      if (_listCap.isEmpty) {
        emit(state.copyWith(captionStatus: CaptionStatus.empty));
      } else {
        final defLang = event.defaultAudioLanguage;
        for (var cap in _listCap) {
          if (cap.snippet!.language == defLang) {
            idCap = cap.id;
            break;
          }
        }

        emit(state.copyWith(captionStatus: CaptionStatus.success));
      }
    } on Failure catch (e) {
      emit(
          state.copyWith(captionStatus: CaptionStatus.error, error: e.message));
    }
  }

  Future<void> _insertCaption(InsertSubtitlesEvent event, emit) async {
    if (_balanceEmpty(cubitUserData.state.userData.numberOfTrans,
        event.cred.bonus,event.codesLang.length)) {
      emit(state.copyWith(translateStatus: TranslateStatus.forbidden));
    } else {
      emit(state.copyWith(
          translateStatus: TranslateStatus.translating,
          progressTranslate: '0%',
          progressTranslateDouble: 0.0));

      try {
        final defLang = event.defaultAudioLanguage.split('-')[0];
        var listCodeLang = event.codesLang;

        if (_oldCodeList.isEmpty) {
          _oldCodeList.addAll(listCodeLang);
        }

        List<String> listCodeLanguageNotSuccessful = [];
        listCodeLang.remove(defLang);
        int operationAll = listCodeLang.length;
        int opTick = operationAll;

        if (_oldCodeList.length == listCodeLang.length) {
          _listCap.clear();
          _listCap =
              await _youTubeRepository.loadCaptions(event.idVideo, event.cred);
        }
        String fullDefLang = event.defaultAudioLanguage;
        bool isExist = false;

        for (var element in _listCap) {
          if (element.snippet!.language == fullDefLang) {
            isExist = true;
            break;
          }
        }

        if (!isExist) {
          emit(state.copyWith(
              translateStatus: TranslateStatus.error,
              error:
                  'There are no subtitles. Download basic subtitles in Youtube Studio if you need them'
                      .tr()));
          return;
        }

        for (var element in _listCap) {
          var codeLangFromSubtitle = element.snippet!.language;
          if (codeLangFromSubtitle!.contains('-')) {
            codeLangFromSubtitle = codeLangFromSubtitle.split('-')[0];
          }
          if (listCodeLang.contains(codeLangFromSubtitle)) {
            await _youTubeRepository.removeCaptions(element.id!);
          }
        }

        for (int i = 0; i < operationAll; i++) {
          opTick--;
          final result = await _youTubeRepository.insertCaption(
              idCap: idCap!, idVideo: event.idVideo, codeLang: listCodeLang[i]);
          if (!result) {
            listCodeLanguageNotSuccessful.add(listCodeLang[i]);
          }
          emit(state.copyWith(
              translateStatus: TranslateStatus.translating,
              progressTranslateDouble: _getProgressDouble(opTick, operationAll),
              progressTranslate: _getProgress(opTick, operationAll),
              messageStatus: 'Status CAP $i'));
          if (opTick == 0) {
            final l1 = listCodeLang.length;
            final l2 = listCodeLanguageNotSuccessful.length;
            final resultCountSuccessTranslate = l1 - l2;

            await _updateBalance(resultCountSuccessTranslate, event.cred);

            if (l2 > 0) {
              emit(state.copyWith(
                  listCodeLanguageNotSuccessful: listCodeLanguageNotSuccessful,
                  translateStatus: TranslateStatus.error,
                  error: 'Error!'.tr()));
            } else {
              emit(state.copyWith(
                  translateStatus: TranslateStatus.success,
                  messageStatus: 'Status CAP $i'));
            }
          }
        }
      } on Failure catch (e) {
        emit(state.copyWith(
            translateStatus: TranslateStatus.error, error: e.message));
      }
    }
  }

  Future<void> _initTranslate(StartTranslateEvent event, emit) async {
    _clearVar();
    if (_balanceEmpty(cubitUserData.state.userData.numberOfTrans,
        event.channelModelCred.bonus,event.codeLanguage.length)) {
      emit(state.copyWith(translateStatus: TranslateStatus.forbidden));
    } else {
      final num = event.videoModel.description.isEmpty ? 1 : 2;
      _codeList = event.codeLanguage;
      _operationQueueAll = (_codeList.length * num) + 1;
      _operationQueueTotal = _operationQueueAll;
      event.videoModel.description.isNotEmpty
          ? _operationQueueDescTrans = _codeList.length
          : 0;
      _operationQueueTitleTrans = _codeList.length;
      emit(state.copyWith(
          translateStatus: TranslateStatus.translating,
          progressTranslate: '0%',
          progressTranslateDouble: 0.0));
      try {
        await _cycleTranslate(
            event.videoModel, event.channelModelCred, event.codeLanguage);
      } on Failure catch (error) {
        _clearVar();
        emit(state.copyWith(
            translateStatus: TranslateStatus.error, error: error.message));
      }
    }
  }


  Future<void> _checkBalance(CheckBalanceEvent event,emit) async {
    emit(state.copyWith(translateStatus: TranslateStatus.unknown));
    final bonusRemote = await _youTubeRepository.getBonusOfRemoteChannel(idChannel: event.channelModelCred.idChannel);
    int bonusLocal = event.channelModelCred.bonus;
    final balanceRemote = await _userRepository.getBalance();
    int balanceLocal = cubitUserData.state.userData.numberOfTrans;

     ChannelModelCred  channelModelCred = event.channelModelCred;
      channelModelCred = channelModelCred.copyWith(bonus: bonusRemote);
      emit(state.copyWith(translateStatus: TranslateStatus.updateBonusLocal,updatedChannel: channelModelCred));
      bonusLocal = bonusRemote<0?0:bonusRemote;
      cubitUserData.updateLocalBonus(newBalance: balanceRemote);
      emit(state.copyWith(translateStatus: TranslateStatus.updateBalanceLocal,updatedBalance: balanceRemote));
      balanceLocal = balanceRemote;

      if(_balanceEmpty(balanceLocal,
        bonusLocal,event.codeLanguage.length)){
      emit(state.copyWith(translateStatus: TranslateStatus.forbidden));
    }else{

      emit(state.copyWith(translateStatus: TranslateStatus.initTranslate));
    }
  }

  bool _balanceEmpty(int userBalance,int channelRemoteBonus,int quantityLanguage){
    final total = userBalance+channelRemoteBonus;
    if(total == 0){
      return true;
    }
    if(total<quantityLanguage){
      return true;
    }
    return false;
  }

  String _getProgress(int op, int allOp) {
    final i = allOp - op;
    return '${((i * 100) ~/ allOp).toString()}%';
  }

  double _getProgressDouble(int op, int allOp) {
    final i = allOp - op;
    if (op == allOp) {
      return 0.0;
    } else {
      return ((i * 100) / allOp) / 100;
    }
  }

  void _clearVar() {
    _operationQueueAll = 0;
    _operationQueueTitleTrans = 0;
    _operationQueueDescTrans = 0;
    _indexTitle = 0;
    _indexDesc = 0;
    _titleTranslate.clear();
    _descTranslate.clear();
    _mapUpdateLocalisation.clear();
  }

  Future<void> _cycleTranslate(VideoModel videoModel,
      ChannelModelCred channelModelCred, List<String> codeLanguage) async {
    int codeState = -1;
    if (_operationQueueAll > 0) {
      if (_operationQueueTitleTrans > 0) {
        try {
          final titleT = await _translateRepository.translate(
              codeLanguage[_indexTitle], videoModel.title);
          //final titleT = 'kllksdj;fklasjdklfjasdkfaklsdjfasd';
          if (titleT.length > 100) {
            final textTitleLimit = titleT.substring(0, 100);
            _titleTranslate.add(textTitleLimit);
          } else {
            _titleTranslate.add(titleT);
          }

          _indexTitle++;
          _operationQueueTitleTrans--;
        } on Failure catch (e) {
          emit(state.copyWith(
              translateStatus: TranslateStatus.error, error: e.message));
        }
        //await Future.delayed(Duration(milliseconds: 500));
      } else if (_operationQueueTitleTrans == 0) {
        if (_operationQueueDescTrans > 0) {
          //await Future.delayed(Duration(milliseconds: 500));
          final descT = await _translateRepository.translate(
              codeLanguage[_indexDesc], videoModel.description);
          //final descT = 'llkammc,.mz.x,cm.z,xmc.,zmxc,zmx,czmx';
          _descTranslate.add(descT);
          _indexDesc++;
          _operationQueueDescTrans--;
        }
      }

      if (_operationQueueAll == 1) {
        if (_titleTranslate.isEmpty) {
          emit(state.copyWith(
              translateStatus: TranslateStatus.error,
              error: 'List code empty...'));
        } else {
          for (int i = 0; i < _titleTranslate.length; i++) {
            _mapUpdateLocalisation.addAll({
              codeLanguage[i]: VideoLocalization(
                  description:
                      _descTranslate.isNotEmpty ? _descTranslate[i] : '',
                  title: _titleTranslate[i])
            });
            if (i == _titleTranslate.length - 1) {
              if (_mapUpdateLocalisation.isNotEmpty) {
                try {
                  codeState = await _youTubeRepository.updateLocalization(
                      videoModel, channelModelCred, _mapUpdateLocalisation);
                  //codeState = 2;
                } on Failure catch (e) {
                  emit(state.copyWith(
                      translateStatus: TranslateStatus.error,
                      error: e.message));
                  return;
                }
              } else {
                emit(state.copyWith(
                    translateStatus: TranslateStatus.error,
                    error: 'List empty'));
              }
            }
          }
        }
        //await Future.delayed(Duration(milliseconds: 500));
      }

      _operationQueueAll--;
      _cycleTranslate(videoModel, channelModelCred, codeLanguage);

      emit(state.copyWith(
          translateStatus: TranslateStatus.translating,
          progressTranslateDouble:
              _getProgressDouble(_operationQueueAll, _operationQueueTotal),
          progressTranslate:
              _getProgress(_operationQueueAll, _operationQueueTotal),
          messageStatus:
              'Status TD $_operationQueueAll Code $codeState CL = ${videoModel.defaultLanguage}'));

      if (_operationQueueAll == 0) {
        _clearVar();
        await _updateBalance(codeLanguage.length, channelModelCred);
        emit(state.copyWith(
            translateStatus: TranslateStatus.success,
            messageStatus:
                'Status TD $_operationQueueAll Code $codeState CL = ${videoModel.defaultLanguage}'));
      }
    }
  }

  Future<void> _updateBalance(int translateQuantity, ChannelModelCred channelModelCred) async {
    await cubitUserData.updateBalance(
         numberTranslate: translateQuantity,
        channel: channelModelCred,
        bonusOfRemoteChannel: channelModelCred.bonus);
  }
}
