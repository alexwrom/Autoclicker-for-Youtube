



 class ConfigAppEntity{

  final String clientId;
  final String clientSecret;
  final int requiredUpdate;
  final String mobileVersion;
  ///index 0 - UrlSchemes 1 - clientID
  final List<dynamic> credAuthIOS;

  const ConfigAppEntity({
    required this.clientId,
    required this.clientSecret,
    required this.credAuthIOS,
    required this.mobileVersion,
    required this.requiredUpdate
  });

 factory ConfigAppEntity.unknown(){
    return const ConfigAppEntity(
        clientId: '',
        clientSecret: '',
        requiredUpdate: 0,
        mobileVersion: '',
        credAuthIOS: []);
  }
}