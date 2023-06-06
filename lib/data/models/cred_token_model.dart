




  import 'package:cloud_firestore/cloud_firestore.dart';

class CredTokenModel{
    final String clientId;
    final String clientSecret;





    factory CredTokenModel.fromApi(DocumentSnapshot doc) {
      return CredTokenModel(
        clientId: doc.get('ClientID'),
        clientSecret: doc.get('Secret'),
      );
    }

    const CredTokenModel({
    required this.clientId,
    required this.clientSecret,
  });
}