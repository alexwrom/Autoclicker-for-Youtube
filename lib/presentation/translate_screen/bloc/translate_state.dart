

  import 'package:equatable/equatable.dart';

  enum TranslateStatus{
    error,
    success,
    translating,
    unknown,
    forbidden
  }

  enum CaptionStatus{
    loading,
    error,
    success,
    translating,
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

  }


class TranslateState extends Equatable{

    final TranslateStatus translateStatus;
    final CaptionStatus captionStatus;
    final String progressTranslate;
    final double progressTranslateDouble;
    final String error;
    final String messageStatus;


   const TranslateState(this.translateStatus,this.captionStatus, this.progressTranslate,this.error,this.progressTranslateDouble,this.messageStatus);

    factory TranslateState.unknown(){
        return const TranslateState(TranslateStatus.unknown,CaptionStatus.unknown,'0%','',0.0,'---');
    }



  @override
  List<Object?> get props => [translateStatus,captionStatus,progressTranslate,error,progressTranslateDouble,messageStatus];

    TranslateState copyWith({
    TranslateStatus? translateStatus,
      CaptionStatus? captionStatus,
    String? progressTranslate,
    String? error,
      double? progressTranslateDouble,
      String? messageStatus
  }) {
    return TranslateState(
    translateStatus ?? this.translateStatus,
       captionStatus??this.captionStatus,
       progressTranslate ?? this.progressTranslate,
       error ?? this.error,
        progressTranslateDouble ?? this.progressTranslateDouble,
      messageStatus??this.messageStatus
    );
  }
}