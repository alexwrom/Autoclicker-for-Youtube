


 import 'package:equatable/equatable.dart';

class MainEvent extends Equatable{
  @override

  List<Object?> get props => [];



 }

 class GetChannelEvent extends MainEvent{}

 class GetListVideoFromChannelEvent extends MainEvent{
    final String idChannel;

    GetListVideoFromChannelEvent({
    required this.idChannel,
  });
}