


  import 'package:equatable/equatable.dart';

import '../../../domain/models/user_data.dart';


 enum UserDataStatus{
   loading,
   error,
   success,
   unknown

 }

class UserdataState extends Equatable{

  final UserData userData;
  final UserDataStatus userDataStatus;
  final String error;


  const UserdataState(this.userData, this.userDataStatus,this.error);


 factory UserdataState.unknown(){
   return UserdataState(UserData.unknown(), UserDataStatus.unknown,'');
 }



  @override

  List<Object?> get props => [userDataStatus,userData,error];

  UserdataState copyWith({
    UserData? userData,
    UserDataStatus? userDataStatus,
    String? error
  }) {
    return UserdataState(
      userData ?? this.userData,
      userDataStatus ?? this.userDataStatus,
      error??this.error
    );
  }
}