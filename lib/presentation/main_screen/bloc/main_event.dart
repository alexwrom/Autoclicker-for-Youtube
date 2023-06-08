


 import 'package:equatable/equatable.dart';

import '../../../domain/models/channel_model_cred.dart';

class MainEvent extends Equatable{
  @override

  List<Object?> get props => [];



 }
 class AddChannelWithGoogleEvent extends MainEvent{}

 class AddChannelByInvitationEvent extends MainEvent{
   final String codeInvitation;
   AddChannelByInvitationEvent({
    required this.codeInvitation,
  });
}

 class GetChannelEvent extends MainEvent{}
 class RemoveChannelEvent extends MainEvent{
   final int keyHive;
   final int index;
    RemoveChannelEvent({required this.keyHive,required this.index});
 }

 class GetListVideoFromChannelEvent extends MainEvent{
    final ChannelModelCred cred;


    GetListVideoFromChannelEvent({
    required this.cred,

  });
}