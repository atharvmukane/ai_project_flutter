import 'package:flutter/material.dart';

import '../auth_module/screens/signupScreen.dart';
import '../auth_module/screens/splash_screen.dart';
import '../home_module/screens/add_interview_screen.dart';
import '../home_module/screens/answer_analysis_screen.dart';
import '../home_module/screens/dashboard_screen.dart';
import '../home_module/screens/interview_details_screen.dart';
import '../home_module/screens/interview_session_screen.dart';
import '../loading_screen.dart';
import 'arguments.dart';
import 'routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    //

    // Auth Screens
    case NamedRoute.signupScreen:
      return _getPageRoute(const SignupScreen());

    case NamedRoute.dashboardScreen:
      return _getPageRoute(const DashboardScreen());

    case NamedRoute.addInterviewScreen:
      return _getPageRoute(const AddInterviewScreen());

    case NamedRoute.interviewSessionScreen:
      return _getPageRoute(InterviewSessionScreen(args: settings.arguments as InterviewSessionScreenArguments));

    case NamedRoute.interviewDetailsScreen:
      return _getPageRoute(InterviewDetailsScreen(args: settings.arguments as InterviewDetailsScreenArguments));

    case NamedRoute.answerAnalysisScreen:
      return _getPageRoute(AnswerAnalysisScreen(args: settings.arguments as AnswerAnalysisScreenArguments));

    // Bottom Nav
    // case NamedRoute.bottomNavBarScreen:
    //   return _getPageRoute(
    //       BottomNavBar(args: settings.arguments as BottomNavArgumnets));

    // Login Screen
    // case NamedRoute.loginScreen:
    //   return _getPageRoute(const LoginScreen());

    default:
      return _getPageRoute(const SplashScreen());
  }
}

PageRoute _getPageRoute(Widget screen) {
  return MaterialPageRoute(builder: (context) => screen);
}
