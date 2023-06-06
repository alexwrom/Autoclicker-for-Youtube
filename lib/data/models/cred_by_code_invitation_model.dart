

import 'package:cloud_firestore/cloud_firestore.dart';

class CredByCodeInvitationModel{

  final String emailUser;
  final String refreshToken;

  const CredByCodeInvitationModel({
    required this.emailUser,
    required this.refreshToken,
  });



  factory CredByCodeInvitationModel.fromApi(DocumentSnapshot doc) {
    return CredByCodeInvitationModel(
      emailUser: doc.get('emailUser'),
      refreshToken: doc.get('refreshToken'),
    );
  }
}