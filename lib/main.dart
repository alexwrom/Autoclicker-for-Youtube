import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_clicker/presentation/auth_screen/auth_page.dart';
import 'package:youtube_clicker/presentation/auth_screen/bloc/auth_bloc.dart';
import 'package:youtube_clicker/presentation/main_screen/bloc/main_bloc.dart';
import 'package:youtube_clicker/presentation/main_screen/channels_page.dart';
import 'package:youtube_clicker/presentation/main_screen/cubit/user_data_cubit.dart';
import 'package:youtube_clicker/presentation/main_screen/list_channel_add_page.dart';
import 'package:youtube_clicker/presentation/membership_screen/membership_page.dart';
import 'package:youtube_clicker/utils/preferences_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clicker/di/locator.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'app_bloc/app_bloc.dart';
import 'components/dialoger.dart';
import 'data/models/hive_models/video.dart';
import 'di/locator.dart';
import 'presentation/auth_screen/auth_page_google.dart';
import 'presentation/splash_screen/splash_page.dart';
import 'utils/app_theme.dart';

Future<void> initHive()async{
  final path=(await getApplicationDocumentsDirectory()).path;
  Hive..init(path)..registerAdapter(VideoAdapter());
  await Hive.openBox('video_box');
}

void main()async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PreferencesUtil.init();
  await initHive();
  di.setup();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_)=>AuthBloc()),
        BlocProvider<AppBloc>(create: (_) => AppBloc()),
        BlocProvider<MainBloc>(create: (_)=>MainBloc()),
        BlocProvider<UserDataCubit>(create: (_)=>UserDataCubit())
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const App(),
        debugShowCheckedModeBanner: false,
        builder: (context,child)=>ResponsiveWrapper.builder(
          child,
          maxWidth:1200,
          minWidth: 480,
          defaultScale:true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(480, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET),
            const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ],
        ),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);




  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {




  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
        if (state.error != '') Dialoger.showError(state.error,context);
      },
      builder: (_, state) {
        if (state.authStatusCheck == AuthStatusCheck.unknown) {
          return const SplashPage();
        } else if (state.authStatusCheck == AuthStatusCheck.unauthenticated) {
          return const AuthPage();
        }
        return const ListChannelAdd();

      },
    );

  }

  @override
  void initState() {
    super.initState();
    context.read<AppBloc>().add(AuthInitCheck());

  }


  @override
  void dispose() {
    super.dispose();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initLanguage();


  }

  initLanguage()async{
    // if(ui.window.locale.toString()=='ru_RU'){
    //   await context.setLocale(const Locale('ru','RU'));
    //
    // }else{
    //   await context.setLocale(const Locale('en','EN'));
    // }
  }


}



