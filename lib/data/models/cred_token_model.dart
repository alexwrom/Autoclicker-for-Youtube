




  import 'package:cloud_firestore/cloud_firestore.dart';

class CredTokenModel{
    final String clientId;
    final String clientSecret;
    ///index 0 - UrlSchemes 1 - clientID
    final List<dynamic> credAuthIOS;





    factory CredTokenModel.fromApi(DocumentSnapshot doc) {
      return CredTokenModel(
        clientId: doc.get('ClientID'),
        clientSecret: doc.get('Secret'),
        credAuthIOS: doc.get('CredAuthIOS')
      );
    }

    const CredTokenModel({
    required this.clientId,
    required this.clientSecret,
      required this.credAuthIOS
  });
}