


  import 'package:equatable/equatable.dart';

import '../../../domain/models/video_model.dart';

class TranslateEvent extends Equatable{
  @override
  List<Object?> get props => [];
}


 class StartTranslateEvent extends TranslateEvent{
   final List<String> codeLanguage;
   final VideoModel videoModel;


   StartTranslateEvent({
     required this.videoModel,
    required this.codeLanguage,
  });
}