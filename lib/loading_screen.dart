import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common_functions.dart';
import '../main.dart';
import '../navigation/arguments.dart';
import '../navigation/navigators.dart';
import 'commonWidgets/circular_loader.dart';
import 'navigation/routes.dart';

class LoadingScreen extends StatefulWidget {
  final LoadingScreenArguments args;
  const LoadingScreen({Key? key, required this.args}) : super(key: key);

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  Map language = {};
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;

  // late User user;
  bool isLoading = true;

  // fetchAndNavigateToActivity() async {
  //   final response =
  //       await Provider.of<DailyActivityProvider>(context, listen: false)
  //           .fetchSingleActivityById(
  //     query:
  //         '?activityId=${widget.args.featureId}&activityType=${widget.args.type}',
  //     activityType: widget.args.type,
  //     accessToken: user.accessToken,
  //   );

  //   if (response['success']) {
  //     return response;
  //   } else {
  //     showSnackbar('Activity not found');
  //     pop();
  //     return {'success': false};
  //   }
  // }

  checkFeature() async {
    try {
      switch (widget.args.type) {
        // case 'Yoga':
        //   final response = await fetchAndNavigateToActivity();
        //   if (response['success']) {
        //     pushReplacement(NamedRoute.yogaDetailsScreen,
        //         arguments: YogaDetailsArguments(
        //             selectedYoga: response['activity'],
        //             trimester: (response['activity'] as Yoga)
        //                     .trimester
        //                     .isNotEmpty
        //                 ? (response['activity'] as Yoga).trimester[0].toString()
        //                 : '1',
        //             yoga: []));
        //   }
        //   break;

//
        default:
          navigatorKey.currentState!.pop();
          break;
      }
    } catch (e) {
      pop();
    }
  }

  @override
  void initState() {
    super.initState();
    // user = Provider.of<AuthProvider>(context, listen: false).user;

    checkFeature();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    // language = Provider.of<AuthProvider>(context).selectedLanguage;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: dH,
          width: dW,
          child: const CircularLoader(),
        ),
      ),
    );
  }
}
