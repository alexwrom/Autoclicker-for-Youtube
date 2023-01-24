

  import 'package:equatable/equatable.dart';

  enum TranslateStatus{
    error,
    success,
    translating,
    unknown
  }

   extension TranslateStatusExt on TranslateStatus{
     bool get isError=>this==TranslateStatus.error;
     bool get isSuccess=>this==TranslateStatus.success;
     bool get isTranslating=>this==TranslateStatus.translating;
   }


class TranslateState extends Equatable{

    final TranslateStatus translateStatus;
    final String progressTranslate;
    final double progressTranslateDouble;
    final String error;


   const TranslateState(this.translateStatus, this.progressTranslate,this.error,this.progressTranslateDouble);

    factory TranslateState.unknown(){
        return const TranslateState(TranslateStatus.unknown,'0%','',0.0);
    }



  @override
  List<Object?> get props => [translateStatus,progressTranslate,error,progressTranslateDouble];

    TranslateState copyWith({
    TranslateStatus? translateStatus,
    String? progressTranslate,
    String? error,
      double? progressTranslateDouble
  }) {
    return TranslateState(
    translateStatus ?? this.translateStatus,
       progressTranslate ?? this.progressTranslate,
       error ?? this.error,
        progressTranslateDouble ?? this.progressTranslateDouble
    );
  }
}