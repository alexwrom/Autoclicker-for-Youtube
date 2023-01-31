


  import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clicker/presentation/main_screen/cubit/user_data_state.dart';
  import 'package:youtube_clicker/utils/preferences_util.dart';
import '../../../di/locator.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../utils/failure.dart';

class UserDataCubit extends Cubit<UserdataState>{
  UserDataCubit():super(UserdataState.unknown());

  final _repositoryUser=locator.get<UserRepository>();
  final _uid=PreferencesUtil.getUid;


  getDataUser()async{
    emit(state.copyWith(userDataStatus: UserDataStatus.loading));
    try {
      final userData=await _repositoryUser.getDataUser(uid: _uid);
      emit(state.copyWith(userDataStatus: UserDataStatus.success,userData: userData));
    }on Failure catch (e) {
      emit(state.copyWith(userDataStatus: UserDataStatus.error,error: e.message));
    }
  }



  }