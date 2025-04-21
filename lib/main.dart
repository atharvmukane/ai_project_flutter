// ignore_for_file: deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:localstorage/localstorage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:project_interview/auth_module/providers/auth_provider.dart';
import 'package:project_interview/home_module/providers/home_provider.dart';
import 'package:provider/provider.dart';

import 'auth_module/screens/splash_screen.dart';
import 'navigation/navigation_service.dart';
import 'theme_manager.dart';

// import 'navigation/navigation_service.dart';
// import 'navigation/navigators.dart';
// import 'navigation/routes.dart';

final LocalStorage storage = LocalStorage('interview_flow');

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

awaitStorageReady() async {
  await storage.ready;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.release != null && double.parse(androidInfo.version.release!.split('')[0]) <= 8.0) {
      HttpOverrides.global = MyHttpOverrides();
    }
  }

  return runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  myInit() async {
    // Permission.accessMediaLocation.request();
    // await this.initDynamicLinks();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  void initState() {
    super.initState();
    myInit();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
            navigatorKey: navigatorKey,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            },
            title: 'Interview Flow',
            theme: theme.getTheme(),
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: generateRoute,
            routes: {
              '/': (BuildContext context) => const SplashScreen(),
              // '/': (BuildContext context) =>
              //     HomeScreen(args: HomeScreenArguments()),
            }),
      ),
    );
  }
}
