


  import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:youtube_clicker/presentation/translate_screen/bloc/translate_event.dart';

import '../models/channel_model.dart';
import '../models/channel_model_cred.dart';
import '../models/video_model.dart';

abstract class YouTubeRepository{



    //Future<List<ChannelModel>?> getListChanel(bool reload);
    Future<ChannelModelCred> addChannel();
    Future<ChannelModelCred> addChannelByCodeInvitation({required String code});
    Future<List<VideoModel>> getVideoFromAccount(ChannelModelCred cred);
    Future<int> updateLocalization(VideoModel videoModel,ChannelModelCred channelModelCred,Map<String,VideoLocalization> map);
    Future<List<Caption>> loadCaptions(String idVideo,ChannelModelCred cred);
    Future<bool> insertCaption({required String idCap,required InsertSubtitlesEvent event,required String codeLang, required String defCaptionData});
    Future<bool> removeCaptions(String idCap);
    Future<bool> isActivatedChanelByInvitation(String code);
    Future<ChannelModelCred> addRemoteChannelByRefreshToken({required String idChannel});
    Future<(int,String)> getBonusOfRemoteChannel({required String idChannel});
    Future<String> updateTokenFromRemote({required String idChannel});


  }