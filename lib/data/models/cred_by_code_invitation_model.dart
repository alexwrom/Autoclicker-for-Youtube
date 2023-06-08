

import 'package:cloud_firestore/cloud_firestore.dart';

class CredByCodeInvitationModel{

  final String emailUser;
  final String refreshToken;
  final String idInvitation;

  const CredByCodeInvitationModel({
    required this.emailUser,
    required this.refreshToken,
    required this.idInvitation
  });



  factory CredByCodeInvitationModel.fromApi(DocumentSnapshot doc) {
    return CredByCodeInvitationModel(
      emailUser: doc.get('emailUser'),
      refreshToken: doc.get('refreshToken'),
      idInvitation: doc.id
    );
  }
}