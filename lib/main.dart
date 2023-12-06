
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_clicker/presentation/auth_screen/auth_page.dart';
import 'package:youtube_clicker/presentation/auth_screen/bloc/auth_bloc.dart';
import 'package:youtube_clicker/presentation/auth_screen/enter_code_verification_page.dart';
import 'package:youtube_clicker/presentation/main_screen/bloc/main_bloc.dart';
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
import 'data/models/hive_models/cred_channel.dart';
import 'data/models/hive_models/channel_lang_code.dart';
import 'presentation/splash_screen/splash_page.dart';
import 'utils/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';

Future<void> initHive()async{
  final path=(await getApplicationDocumentsDirectory()).path;
  Hive.init(path);
  Hive.registerAdapter(ChannelLangCodeAdapter());
  Hive.registerAdapter(CredChannelAdapter());
  await Hive.openBox('video_box').catchError((error){
    print('Error Open Box 1 $error');
  });
  await Hive.openBox('cred_video').catchError((error){
    print('Error Open Box 2 $error');
  });
}


void main()async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PreferencesUtil.init();
  await initHive();
  await EasyLocalization.ensureInitialized();
  di.setup();
  runApp(EasyLocalization(
      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
        Locale('de'),
        Locale('uk'),
        Locale('fr')
      ],
      path: 'lib/assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale('en'),
      child: const MyApp()
  ),);
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserDataCubit userDataCubit = UserDataCubit();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<UserDataCubit>(create: (_)=>userDataCubit),
        BlocProvider<AuthBloc>(create: (_)=>AuthBloc()),
        BlocProvider<AppBloc>(create: (_) => AppBloc()),
        BlocProvider<MainBloc>(create: (_)=>MainBloc(userDataCubit)),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const App(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
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

class _AppState extends State<App> with WidgetsBindingObserver{

   bool _isShow = false;


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
        if(state.checkUpdateStatus == CheckUpdateStatus.showMenuUpdate){
          print('Show Dialof');
         Dialoger.showBottomMenuAppUpdate(context:context,configAppEntity: state.configAppEntity,
             isAuth:state.authStatusCheck == AuthStatusCheck.unknown
         );
        }

        if (state.error != '') Dialoger.showError(state.error,context);
      },
      builder: (_, state) {
        if (state.authStatusCheck == AuthStatusCheck.unknown) {
          return const SplashPage();
        } else if (state.authStatusCheck == AuthStatusCheck.unauthenticated) {
          return const AuthPage();
        }else if(state.authStatusCheck==AuthStatusCheck.verificationCodeExist){
          return const EnterCodeVerificationEmail();
        }

        return const ListChannelAdd();


      },
    );

  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<AppBloc>().add(AuthInitCheck());

  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();



  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed&&_isShow){
      context.read<AppBloc>().add(CheckAppUpdateEvent());
    }
    if(state == AppLifecycleState.paused){
      _isShow = true;
    }
  }
}



