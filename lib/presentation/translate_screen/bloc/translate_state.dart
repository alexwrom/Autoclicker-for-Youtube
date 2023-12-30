

  import 'package:equatable/equatable.dart';
import 'package:youtube_clicker/domain/models/channel_model_cred.dart';

  enum TranslateStatus{
    error,
    success,
    translating,
    unknown,
    forbidden,
    updateBonusLocal,
    initTranslate
  }

  enum CaptionStatus{
    loading,
    error,
    success,
    translating,
    completeTranslate,
    unknown,
    empty,

  }

   extension TranslateStatusExt on TranslateStatus{
     bool get isError=>this==TranslateStatus.error;
     bool get isSuccess=>this==TranslateStatus.success;
     bool get isTranslating=>this==TranslateStatus.translating;
     bool get isForbidden=>this==TranslateStatus.forbidden;
   }
  extension CaptionStatusExt on CaptionStatus{
    bool get isLoading=>this==CaptionStatus.loading;
    bool get isError=>this==CaptionStatus.error;
    bool get isSuccess=>this==CaptionStatus.success;
    bool get isTranslating=>this==CaptionStatus.translating;
    bool get isEmpty=>this==CaptionStatus.empty;
    bool get isCompleteTranslate=>this==CaptionStatus.completeTranslate;

  }


class TranslateState extends Equatable{

    final TranslateStatus translateStatus;
    final CaptionStatus captionStatus;
    final String progressTranslate;
    final double progressTranslateDouble;
    final String error;
    final String messageStatus;
    final ChannelModelCred updatedChannel;
    final List<String> listCodeLanguageNotSuccessful;


   const TranslateState(
      this.translateStatus,
      this.captionStatus,
      this.progressTranslate,
      this.error,
      this.progressTranslateDouble,
      this.messageStatus,
       this.listCodeLanguageNotSuccessful,
       this.updatedChannel);

    factory TranslateState.unknown(){
        return  TranslateState(TranslateStatus.unknown,CaptionStatus.unknown,'0%','',0.0,'---',const [],ChannelModelCred.unknown());
    }



  @override
  List<Object?> get props => [translateStatus,captionStatus,progressTranslate,error,progressTranslateDouble,messageStatus,listCodeLanguageNotSuccessful,updatedChannel];

    TranslateState copyWith({
    TranslateStatus? translateStatus,
      CaptionStatus? captionStatus,
    String? progressTranslate,
    String? error,
      double? progressTranslateDouble,
      String? messageStatus,
      List<String>? listCodeLanguageNotSuccessful,
      ChannelModelCred? updatedChannel
  }) {
    return TranslateState(
    translateStatus ?? this.translateStatus,
       captionStatus??this.captionStatus,
       progressTranslate ?? this.progressTranslate,
       error ?? this.error,
        progressTranslateDouble ?? this.progressTranslateDouble,
      messageStatus??this.messageStatus,
      listCodeLanguageNotSuccessful?? this.listCodeLanguageNotSuccessful,
      updatedChannel??this.updatedChannel
    );
  }
}