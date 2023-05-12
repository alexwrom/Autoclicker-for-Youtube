
part of 'auth_bloc.dart';


abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}



class LogInEvent extends AuthEvent {
  final String email;
  final String password;
  const LogInEvent({required this.email,required this.password});

}
class SingInEvent extends AuthEvent{

  final String email;
  final String password;
  final String repPass;
  const SingInEvent({required this.email,required this.password,required this.repPass});

}
class Unknown extends AuthEvent{}
class LogOutEvent extends AuthEvent{
  final bool isDeleteAcc;
  const LogOutEvent({required this.isDeleteAcc});
}
class ForgotEvent extends AuthEvent{
  final String email;
  final String newPass;
  const ForgotEvent({required this.email,required this.newPass});


}

