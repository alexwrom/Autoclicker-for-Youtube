


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clicker/di/locator.dart';
import 'package:youtube_clicker/resourses/colors_app.dart';


import '../../../components/dialoger.dart';
import '../cubit/user_data_cubit.dart';
import '../cubit/user_data_state.dart';

class UserDataCard extends StatefulWidget{
  const UserDataCard({super.key});

  @override
  State<UserDataCard> createState() => _UserDataCardState();
}

class _UserDataCardState extends State<UserDataCard> {
  final _cubitUserData=locator.get<UserDataCubit>();


  @override
  void initState() {
    super.initState();
    _cubitUserData.getDataUser();
    print('Init User');

  }

  double _getWight(int count){
    return count>999?50.0:40.0;
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
            return Badge(
              alignment:AlignmentDirectional.topStart,
              label: Text('${state.userData.numberOfTrans}',style:
                const TextStyle(
                  fontWeight: FontWeight.w700
                ),),
              child: GestureDetector(
                onTap: (){

                },
                child: Container(
                  alignment: Alignment.centerRight,
                  width: _getWight(state.userData.numberOfTrans),
                  height: 40,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorBackground
                    ),
                    child:const Icon(Icons.translate,color: Colors.white),
                  ),
                ),
              ),
            );
        }
      ),
    );
  }
}