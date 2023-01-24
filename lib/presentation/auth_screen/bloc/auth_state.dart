

part of 'auth_bloc.dart';




enum AuthStatus{
  unknown,
  authenticated,
  unauthenticated,
  error,
  processSingIn,
  processLogIn,
  processLogOut,
  processForgot,
  sendToEmail
}





class AuthState extends Equatable {
  final AuthStatus authStatus;
  final LocalStatus localStatus;
  final String error;
  final bool isLoading;



  bool get isAuthenticated => authStatus == AuthStatus.authenticated;


  const AuthState(this.authStatus,this.localStatus,this.error,[this.isLoading = false]);

  factory AuthState.unauthenticated() {
    return const AuthState(AuthStatus.unauthenticated,LocalStatus.ru,'');
  }

  factory AuthState.unknown() {
    return const AuthState(AuthStatus.unknown, LocalStatus.ru,'');
  }

  @override
  List<Object> get props => [authStatus,localStatus, error, isLoading];

  AuthState copyWith({
    AuthStatus? authStatus,
    LocalStatus? localStatus,
    String? error,
    bool? isLoading,



  }) {
    return AuthState(
      authStatus ?? this.authStatus,
      localStatus??this.localStatus,
      error ?? this.error,
      isLoading ?? this.isLoading,

    );
  }
}