


  import 'package:equatable/equatable.dart';

import '../../../domain/models/channel_model_cred.dart';
import '../../../domain/models/video_model.dart';

class TranslateEvent extends Equatable{
  @override
  List<Object?> get props => [];
}


 class StartTranslateEvent extends TranslateEvent{
   final List<String> codeLanguage;
   final VideoModel videoModel;
   final ChannelModelCred channelModelCred;


   StartTranslateEvent({
     required this.videoModel,
    required this.codeLanguage,
     required this.channelModelCred
  });


}

  class TranslateSubtitlesEvent extends TranslateEvent {
    final List<String> codeLanguage;
    final String captionId;

    TranslateSubtitlesEvent({
      required this.codeLanguage,
      required this.captionId,
    });
  }

     class GetSubtitlesEvent extends TranslateEvent{

       final ChannelModelCred cred;
       final String defaultAudioLanguage;
       final List<String> codesLang;
     final String videoId;

     GetSubtitlesEvent({
       required this.defaultAudioLanguage,
       required this.cred,
     required this.videoId,
       required this.codesLang
     });
    }

  class InsertSubtitlesEvent extends TranslateEvent{
    final ChannelModelCred cred;
    final String defaultAudioLanguage;
    final List<String> codesLang;
    final String idVideo;
    final bool repeatTranslate;

    InsertSubtitlesEvent({
      required this.cred,
      required this.defaultAudioLanguage,
      required this.codesLang,
      required this.idVideo,
      required this.repeatTranslate
    });
  }