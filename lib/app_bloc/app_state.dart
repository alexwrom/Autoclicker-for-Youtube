

part of 'app_bloc.dart';


enum AuthStatusCheck{
  unknown,
  authenticated,
  unauthenticated,
  error,
  processLogOut,
  verificationCodeExist
}

enum CheckUpdateStatus{
  unknown,
  showMenuUpdate,
  error,
}

class AppState extends Equatable {
  final AuthStatusCheck authStatusCheck;
  final CheckUpdateStatus checkUpdateStatus;
  final LocalStatus localStatus;
  final String error;
  final bool isLoading;
  final bool isLoadingChekAuth;
  final ConfigAppEntity configAppEntity;


  bool get isAuthenticated => authStatusCheck == AuthStatus.authenticated;


  const AppState(this.authStatusCheck,this.localStatus,this.error,this.configAppEntity,this.checkUpdateStatus,
      [this.isLoading = false,this.isLoadingChekAuth=false]);

  factory AppState.unauthenticated() {
    return   AppState(AuthStatusCheck.unauthenticated,LocalStatus.ru,'',ConfigAppEntity.unknown(),CheckUpdateStatus.unknown);
  }

  factory AppState.unknown() {
    return   AppState(AuthStatusCheck.unknown, LocalStatus.ru,'',ConfigAppEntity.unknown(),CheckUpdateStatus.unknown);
  }

  @override
  List<Object> get props => [authStatusCheck,localStatus, error, isLoading,isLoadingChekAuth,configAppEntity,checkUpdateStatus];

  AppState copyWith({
    AuthStatusCheck? authStatusCheck,
    LocalStatus? localStatus,
    String? error,
    bool? isLoading,
    bool? isLoadingChekAuth,
    ConfigAppEntity? configAppEntity,
    CheckUpdateStatus? checkUpdateStatus

  }) {
    return AppState(
        authStatusCheck ?? this.authStatusCheck,
        localStatus??this.localStatus,
        error ?? this.error,
      configAppEntity??this.configAppEntity,
        checkUpdateStatus??this.checkUpdateStatus,
        isLoading ?? this.isLoading,
        isLoadingChekAuth??this.isLoadingChekAuth,


    );
  }
}