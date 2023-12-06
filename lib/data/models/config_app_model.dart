




  import 'package:cloud_firestore/cloud_firestore.dart';

class ConfigAppModel{
    final String clientId;
    final String clientSecret;
    final int requiredUpdate;
    final String mobileVersion;
    ///index 0 - UrlSchemes 1 - clientID
    final List<dynamic> credAuthIOS;





    factory ConfigAppModel.fromApi(DocumentSnapshot doc) {
      return ConfigAppModel(
        clientId: doc.get('ClientID'),
        clientSecret: doc.get('Secret'),
        credAuthIOS: doc.get('CredAuthIOS'),
        requiredUpdate: doc.data().toString().contains('mobileRequired')?doc.get('mobileRequired'):2,
        mobileVersion: doc.data().toString().contains('mobileVersion')?doc.get('mobileVersion'):'',
      );
    }

    const ConfigAppModel({
    required this.clientId,
    required this.clientSecret,
      required this.requiredUpdate,
      required this.mobileVersion,
      required this.credAuthIOS
  });
}