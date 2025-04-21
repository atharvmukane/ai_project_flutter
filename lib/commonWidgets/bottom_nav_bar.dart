// ignore_for_file: unused_import, depend_on_referenced_packages

import '../../navigation/arguments.dart';
import '../../main.dart';
import '../colors.dart';
import '../common_functions.dart';
import '../navigation/navigators.dart';
import '../navigation/routes.dart';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'asset_svg_icon.dart';
import 'gradient_widget.dart';

class BottomNavBar extends StatefulWidget {
  final BottomNavArgumnets args;
  const BottomNavBar({super.key, required this.args});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  final LocalStorage storage = LocalStorage('interview_flow');

  int _currentIndex = 0;
  bool isLoading = false;

  double dW = 0;
  double dH = 0;
  double tS = 0;
  Map language = {};

  String? notificationId;
  final unselectedColor = const Color(0xFF9798A3);
  // late User user;

  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigator.push(
    //     context,
    //     PageTransition(
    //       duration: const Duration(milliseconds: 500),
    //       child: ChatGptScreen(args: ChatGptScreenArguments()),
    //       type: PageTransitionType.bottomToTop,
    //     ));
  }

  initFcm() async {
    // FirebaseMessaging messaging = FirebaseMessaging.instance;

    // NotificationSettings settings = await messaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );

    // if (settings.authorizationStatus == AuthorizationStatus.authorized ||
    //     settings.authorizationStatus == AuthorizationStatus.provisional) {
    //   LocalNotificationService.initialize(
    //       navigatorKey.currentContext!, handleNotificationClick);

    //   FirebaseMessaging.onBackgroundMessage(
    //       (RemoteMessage message) => handleNotificationClick(message));

    //   FirebaseMessaging.instance.getInitialMessage().then((message) {
    //     if (message != null) {
    //       message.data['notificationId'] = message.messageId;
    //       handleNotificationClick(message.data);
    //     }
    //   });

    //   FirebaseMessaging.onMessage.listen((message) async {
    //     if (message.notification != null) {
    //       message.data['notificationId'] = message.messageId;

    //       LocalNotificationService.display(message);
    //     }
    //   });

    //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //     if (message.notification != null) {
    //       message.data['notificationId'] = message.messageId;
    //       handleNotificationClick(message.data);
    //     }
    //   });
    //   awaitStoreReady();
    // }
  }

  // getStartedDialog() async {
  //   return showDialog(
  //     context: context,
  //     builder: ((context) => CustomDialogBox(
  //           title: language['started'],
  //           firstButton: DialogTextButton(
  //             onPressed: pop,
  //             text: language['cancel'],
  //           ),
  //           secondButton: FilledDialogButton(
  //             onPressed: () {
  //               pop();
  //               push(NamedRoute.garbhSanskarScreen);
  //             },
  //             text: language['startNow'],
  //           ),
  //         )),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    // user = Provider.of<AuthProvider>(context, listen: false).user;
    _currentIndex = widget.args.index;

    // initFcm();
  }

  awaitStoreReady() async {
    await storage.ready;
  }

  handleNotificationClick(data) async {
    final notificationIdString = storage.getItem('fcmNotificationIds');
    if (notificationIdString != null) {
      notificationId = json.decode(notificationIdString);
      if (notificationId == data['notificationId']) {
        return;
      }
    }
    storage.setItem('fcmNotificationIds', json.encode(data['notificationId']));

    switch (data['type']) {
      // case 'Signup':
      //   pushAndRemoveUntil(NamedRoute.bottomNavBarScreen,
      //       arguments: BottomNavArgumnets(index: 0));
      //   break;
    }
  }

  Future<bool> _willPopCallback() async {
    if (_currentIndex != 0) {
      onTapped(0);
      return false;
    } else {
      return true;
    }
  }

  List<Widget> get _children => [
        // HomeScreen(changeIndex: onTapped),
        // const DailyActivitiesScreen(),
        // ChatGptScreen(
        //   args: ChatGptScreenArguments(),
        // ),
        // DiaryScreen(changeIndex: onTapped),
        // const MoreScreen(),
      ];

  @override
  void dispose() {
    super.dispose();
  }

  Widget navbarItemContent({
    required String label,
    required String svg,
    required bool isSelected,
  }) =>
      Container(
        padding: iOSCondition(dH) ? EdgeInsets.only(top: dW * 0.02) : EdgeInsets.symmetric(vertical: dW * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isSelected ? AssetSvgIcon(svg, height: 18, color: themeColor) : AssetSvgIcon(svg, color: unselectedColor, height: 18),
            SizedBox(height: dW * 0.01),
            isSelected
                ? Text(
                    label,
                    style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: tS * 11, color: themeColor),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: tS * 11,
                      color: lightGray,
                    ),
                  ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    dH = MediaQuery.of(context).size.height;
    // language = Provider.of<AuthProvider>(context).selectedLanguage;

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: isLoading ? const Center(child: CircularProgressIndicator()) : _children[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, -1), blurRadius: 2, spreadRadius: 2)],
            border: Border.all(width: 0, style: BorderStyle.none, color: Colors.transparent),
            color: Colors.white,
          ),
          child: BottomNavigationBar(
            elevation: 10,
            currentIndex: _currentIndex,
            onTap: onTapped,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            selectedItemColor: Theme.of(context).primaryColor,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: navbarItemContent(
                  label: language['home'],
                  svg: 'home',
                  isSelected: _currentIndex == 0,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: navbarItemContent(
                  label: language['daily'],
                  svg: 'daily',
                  isSelected: _currentIndex == 1,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: navbarItemContent(
                  label: language['chat'],
                  svg: 'chat',
                  isSelected: _currentIndex == 2,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: navbarItemContent(
                  label: language['diary'],
                  svg: 'diary',
                  isSelected: _currentIndex == 3,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: navbarItemContent(
                  label: language['more'],
                  svg: 'more',
                  isSelected: _currentIndex == 4,
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
