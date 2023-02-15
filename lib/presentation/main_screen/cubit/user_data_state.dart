


  import 'package:equatable/equatable.dart';

import '../../../domain/models/user_data.dart';


 enum UserDataStatus{
   loading,
   error,
   success,
   unknown

 }
 extension UserDataStatusExt on UserDataStatus{
   bool get isLoading=>this==UserDataStatus.loading;
   bool get isError=>this==UserDataStatus.error;
   bool get isSuccess=>this==UserDataStatus.success;
 }

class UserdataState extends Equatable{

  final UserData userData;
  final UserDataStatus userDataStatus;
  final String error;
  final bool isSubscribe;
  final bool isFreeTrial;
  final List<String> choiceCodeLanguageList;


  const UserdataState(this.userData, this.userDataStatus,this.error,this.isSubscribe,this.isFreeTrial,this.choiceCodeLanguageList);


 factory UserdataState.unknown(){
   return UserdataState(UserData.unknown(), UserDataStatus.unknown,'',false,false,[]);
 }



  @override

  List<Object?> get props => [userDataStatus,userData,error,isSubscribe,isFreeTrial,choiceCodeLanguageList];

  UserdataState copyWith({
    UserData? userData,
    UserDataStatus? userDataStatus,
    String? error,
    bool? isSubscribe,
    bool? isFreeTrial,
    List<String>? choiceCodeLanguageList

  }) {
    return UserdataState(
      userData ?? this.userData,
      userDataStatus ?? this.userDataStatus,
      error??this.error,
      isSubscribe??this.isSubscribe,
      isFreeTrial??this.isFreeTrial,
      choiceCodeLanguageList??this.choiceCodeLanguageList

    );
  }
}