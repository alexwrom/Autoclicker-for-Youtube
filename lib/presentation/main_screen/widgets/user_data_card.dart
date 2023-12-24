


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clicker/presentation/membership_screen/membership_page.dart';
import 'package:youtube_clicker/resourses/colors_app.dart';


import '../../../components/dialoger.dart';
import '../../../domain/models/user_data.dart';
import '../../../utils/preferences_util.dart';
import '../../auth_screen/auth_page.dart';

import '../bloc/main_bloc.dart';
import '../bloc/main_event.dart';
import '../cubit/user_data_cubit.dart';
import '../cubit/user_data_state.dart';

class UserDataCard extends StatefulWidget{
  const UserDataCard({super.key});

  @override
  State<UserDataCard> createState() => _UserDataCardState();
}

class _UserDataCardState extends State<UserDataCard> {



  @override
  void initState() {
    super.initState();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.watch<UserDataCubit>().state.userData;
    if(!user.init)context.read<UserDataCubit>().getDataUser();
  }

  double _getWight(int count) {
    return count > 999 ? 50.0 : 40.0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserDataCubit, UserdataState>(
        listener: (_, stLis) {
          if (stLis.error == 'User is not found') {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AuthPage()));
          }
          if (stLis.error != '') Dialoger.showError(stLis.error, context);
        },
        builder: (context, state) {
          return Row(
            children: [
              Badge(
                alignment: AlignmentDirectional.topStart,
                label: state.userDataStatus.isLoading ? const SizedBox(
                    width: 10, height: 10,
                    child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 1,)) : Text(
                  '${state.userData.numberOfTrans}', style:
                const TextStyle(
                    fontWeight: FontWeight.w700
                ),),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => MembershipPage()));
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
                      child: const Icon(Icons.translate, color: Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => MembershipPage()));
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
                    child: const Icon(Icons.store_mall_directory_rounded,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 5)
            ],
          );
        }
    );
  }
}
