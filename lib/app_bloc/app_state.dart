

part of 'app_bloc.dart';


enum AuthStatusCheck{
  unknown,
  authenticated,
  unauthenticated,
  error,
  processLogOut,
  verificationCodeExist
}

class AppState extends Equatable {
  final AuthStatusCheck authStatusCheck;
  final LocalStatus localStatus;
  final String error;
  final bool isLoading;
  final bool isLoadingChekAuth;


  bool get isAuthenticated => authStatusCheck == AuthStatus.authenticated;


  const AppState(this.authStatusCheck,this.localStatus,this.error,
      [this.isLoading = false,this.isLoadingChekAuth=false]);

  factory AppState.unauthenticated() {
    return  const AppState(AuthStatusCheck.unauthenticated,LocalStatus.ru,'');
  }

  factory AppState.unknown() {
    return  const AppState(AuthStatusCheck.unknown, LocalStatus.ru,'');
  }

  @override
  List<Object> get props => [authStatusCheck,localStatus, error, isLoading,isLoadingChekAuth];

  AppState copyWith({
    AuthStatusCheck? authStatusCheck,
    LocalStatus? localStatus,
    String? error,
    bool? isLoading,
    bool? isLoadingChekAuth,

  }) {
    return AppState(
        authStatusCheck ?? this.authStatusCheck,
        localStatus??this.localStatus,
        error ?? this.error,
        isLoading ?? this.isLoading,
        isLoadingChekAuth??this.isLoadingChekAuth,

    );
  }
}