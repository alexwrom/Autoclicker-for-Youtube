
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

  const SingInEvent();

}
class LogOutEvent extends AuthEvent{}
class ForgotEvent extends AuthEvent{
  final String email;
  const ForgotEvent({required this.email});


}

