


 import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clicker/domain/models/user_data.dart';

import '../../../domain/models/channel_model_cred.dart';

class MainEvent extends Equatable{
  @override

  List<Object?> get props => [];
  const MainEvent();


 }
 class BlockAccountEvent extends MainEvent{
  final bool unlock;
  const BlockAccountEvent({required this.unlock});
 }
 class AddChannelWithGoogleEvent extends MainEvent{}
 class TakeBonusEvent extends MainEvent{
  final ChannelModelCred channelModelCred;
  const TakeBonusEvent({required this.channelModelCred});
 }

 class AddChannelByInvitationEvent extends MainEvent{
   final String codeInvitation;
   const AddChannelByInvitationEvent({
    required this.codeInvitation,
  });
}

 class GetChannelEvent extends MainEvent{
   final UserData user;
   const GetChannelEvent({required this.user});
 }

 class RemoveChannelEvent extends MainEvent{
   final int keyHive;
   final int index;
    const RemoveChannelEvent({required this.keyHive,required this.index});
 }

 class GetListVideoFromChannelEvent extends MainEvent{
    final ChannelModelCred cred;
    const GetListVideoFromChannelEvent({
    required this.cred,

  });
}