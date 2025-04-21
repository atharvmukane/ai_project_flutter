// ignore_for_file: use_build_context_synchronously, deprecated_member_use, use_super_parameters

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:project_interview/common_functions.dart';
import 'package:provider/provider.dart';
import '../../commonWidgets/asset_svg_icon.dart';
import '../../commonWidgets/gradient_widget.dart';
import '../../navigation/arguments.dart';
import '../../navigation/navigators.dart';
import '../../navigation/routes.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final LocalStorage storage = LocalStorage('interview_flow');
  bool isLoggedOut = true;
  bool isFetchingFleetData = true;

  var referralCode = '';
  var referredByUserId = '';
  TextTheme get textTheme => Theme.of(bContext).textTheme;

  Map language = {};

  Map? fleetData;

  goToOnboardingScreen() {
    Future.delayed(const Duration(seconds: 2), () => pushAndRemoveUntil(NamedRoute.signupScreen));
  }

  tryAutoLogin() async {
    try {
      await storage.ready;
      final accessTokenString = storage.getItem('accessToken');
      // final Map response = {'success': true};
      // final response = await getLanguage();

      final appCongigResponse = await Provider.of<AuthProvider>(context, listen: false).status();
      if (appCongigResponse['success']) {
        debugPrint(appCongigResponse['message']);
      }
      if (accessTokenString != null) {
        var accessToken = json.decode(accessTokenString);
        if (accessToken != null) {
          final user = await Provider.of<AuthProvider>(context, listen: false).login(query: "?email=${accessToken['email']}");

          if (user['success'] && user['login']) {
            Future.delayed(const Duration(seconds: 2), () => pushAndRemoveUntil(NamedRoute.dashboardScreen, arguments: DashboardScreenArguments()));
          } else {
            goToOnboardingScreen();
          }
        } else {
          goToOnboardingScreen();
        }
      } else {
        goToOnboardingScreen();
      }
    } catch (e) {
      goToOnboardingScreen();
    }
  }

  @override
  void initState() {
    super.initState();

    myInit();
  }

  myInit() async {
    tryAutoLogin();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double dW = MediaQuery.of(context).size.width;
    final double dH = MediaQuery.of(context).size.height;
    // final double tS = MediaQuery.of(context).textScaleFactor;
    // final language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: dH,
            width: dW,
            // alignment: Alignment.centerRight,
            child: Image.asset(
              'assets/images/splash_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: dH,
            width: dW,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: dH * 0.14),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/interview_flow.png',
                          width: dW * 0.8,
                          // height: dH * 0.1,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 14),
                        //   child: GradientWidget(
                        //     gradient: const LinearGradient(
                        //       colors: [
                        //         Color(0xffCE1B69),
                        //         Color(0xffFF328B),
                        //       ],
                        //     ),
                        //     child: Text(
                        //       '9 & Beyond',
                        //       style: const TextStyle(
                        //         fontSize: 32.64,
                        //         fontWeight: FontWeight.w900,
                        //         letterSpacing: 3,
                        //         // fontFamily: 'Nunito',
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 10),
                        //   child: Text(
                        //     'Holistic Approach To Pregnancy',
                        //     style: const TextStyle(
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.w400,
                        //       letterSpacing: 0.3,
                        //       color: Color(0xff975EFF),
                        //       // fontFamily: 'Cantora One',
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(bottom: dH * 0.2),
                //   child: Column(
                //     children: [
                //       Text(
                //         'Knowledge Partner',
                //         style: const TextStyle(
                //           fontSize: 9,
                //           fontWeight: FontWeight.w400,
                //           color: Color(0xff6B6C75),
                //           // fontFamily: 'Roboto',
                //         ),
                //       ),
                //       Text(
                //         'Manashakti',
                //         style: const TextStyle(
                //           fontSize: 21.44,
                //           fontWeight: FontWeight.w700,
                //           color: Color(0xffF33800),
                //           // fontFamily: 'Metropolis',
                //         ),
                //       ),
                //       const Padding(
                //         padding: EdgeInsets.only(top: 2),
                //         child: AssetSvgIcon('researchcentre'),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
