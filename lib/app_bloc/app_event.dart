

part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}



class AuthInitCheck extends AppEvent {}
class LocalSelected extends AppEvent{
  final LocalStatus local;
  const LocalSelected({required this.local});
}
