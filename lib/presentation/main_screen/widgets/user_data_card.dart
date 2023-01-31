


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../components/dialoger.dart';
import '../cubit/user_data_cubit.dart';
import '../cubit/user_data_state.dart';

class UserDataCard extends StatefulWidget{
  const UserDataCard({super.key});

  @override
  State<UserDataCard> createState() => _UserDataCardState();
}

class _UserDataCardState extends State<UserDataCard> {
  final _cubitUserData=UserDataCubit();


  @override
  void initState() {
    super.initState();
    _cubitUserData.getDataUser();
    print('Init User');

  }

  @override
  Widget build(BuildContext context) {
    print('Build User');
    return BlocProvider(
      create: (_)=>_cubitUserData,
      child: BlocConsumer<UserDataCubit,UserdataState>(
        listener: (_,stLis){
          if (stLis.error != '') Dialoger.showError(stLis.error,context);
        },
        builder: (context,state) {
          return Container(
            child: Text('${state.userData.timeStamp}',style: TextStyle(
                color:Colors.white
            ),),
          );
        }
      ),
    );
  }
}