// ignore_for_file: avoid_function_literals_in_foreach_calls, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../common_functions.dart';
import '../../http_helper.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../../api.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final LocalStorage storage = LocalStorage('interview_flow');
  List availableLanguages = [];

  Map get selectedLanguage => {};
  late User user;

  // late User user;
  // String razorpayId = 'rzp_live_SADgg4dpiG8ML8';

  String androidVersion = '1';
  String iOSVersion = '1';
  Map? deleteFeature;

  List chatFAQs = [
    'isItSafeToExercise',
    'whatFoodsToAvoid',
    'howMuchWeightToGain',
    'areCounterMedsSafe',
  ];

  Map garbhSanskarVideos = {};

  status() async {
    final url = '${webApi['domain']}${endPoint['testStatus']}';
    Map body = {
      // 'mobileNo': mobileNo,
    };
    try {
      final response = await RemoteServices.httpRequest(method: 'GET', url: url);

      return response;
    } catch (error) {
      return {'success': false, 'login': false};
    }
  }

  Future generateQuestions({required Map<String, String> body, required Map<String, String> files}) async {
    try {
      final url = '${webApi['domain']}${endPoint['generateQuestions']}';
      final response = await RemoteServices.formDataRequest(
        method: 'POST',
        url: url,
        body: body,
        files: files,
      );

      if (response['success']) {}
      notifyListeners();
      return response;
    } catch (error) {
      return {'success': false, 'message': 'failedToRegister'};
    }
  }

  // sendOTPtoUser(String mobileNo, {bool business = false}) async {
  //   final url = '${webApi['domain']}${endPoint['sendOTPtoUser']}';
  //   Map body = {
  //     'mobileNo': mobileNo,
  //   };
  //   try {
  //     final response = await RemoteServices.httpRequest(method: 'POST', url: url, body: body);

  //     return response;
  //   } catch (error) {
  //     return {'success': false, 'login': false};
  //   }
  // }

  // resendOTPtoUser(String mobileNo, String type) async {
  //   final url = '${webApi['domain']}${endPoint['resendOTPtoUser']}';
  //   Map body = {
  //     'mobileNo': mobileNo,
  //     "type": type,
  //   };
  //   try {
  //     final response = await RemoteServices.httpRequest(method: 'POST', url: url, body: body);

  //     return response['result']['type'];
  //   } catch (error) {
  //     return {'success': false, 'login': false};
  //   }
  // }

  // verifyOTPofUser(String mobileNo, String otp) async {
  //   final url = '${webApi['domain']}${endPoint['verifyOTPofUser']}';
  //   Map body = {
  //     'mobileNo': mobileNo,
  //     "otp": otp,
  //   };
  //   try {
  //     final response = await RemoteServices.httpRequest(method: 'POST', url: url, body: body);

  //     return response['result']['type'];
  //   } catch (error) {
  //     return {'success': false, 'login': false};
  //   }
  // }

// get app config from DBDB
  getAppConfig(List<String> types) async {
    final url = '${webApi['domain']}${endPoint['getAppConfigs']}';
    try {
      final response = await RemoteServices.httpRequest(method: 'POST', url: url, body: {"types": types});
      // if (response['success']) {
      //   (response['result'] as List).forEach((config) {
      //     if (config['type'] == 'showGarbhSanskarAlways') {
      //       showGarbhSanskarAlways = config['value'] ?? false;
      //     }
      //     if (config['type'] == 'Banner') {
      //       banner = config['value'] ?? '';
      //     }
      //     if (config['type'] == 'SubscriptionScreenImage') {
      //       subscriptionScreenImage = config['value'] ?? '';
      //     }
      //     if (config['type'] == 'SubscriptionDialog' && config['value'] is Map) {
      //       subscriptionDialog = config['value'] ?? {};
      //     }
      //     if (config['type'] == 'Plan' && config['value'] is Map) {
      //       plan = config['value'] ?? {};
      //     }
      //     if (config['type'] == 'blockDailyActivities') {
      //       blockDailyActivities = config['value'] ?? false;
      //     }
      //     if (config['type'] == 'gptQuestionCharge') {
      //       questionRate = config['value'] ?? false;
      //     }
      //     if (config['type'] == 'delete_feature') {
      //       deleteFeature = Platform.isAndroid ? config['value']['android'] : config['value']['iOS'];
      //     }
      //     if (config['type'] == 'Razorpay') {
      //       razorpayId = config['value'] ?? razorpayId;
      //     }
      //     if (config['type'] == 'GarbhSanskarVideos' && config['value'] is Map) {
      //       garbhSanskarVideos = config['value'] ?? {};
      //     }
      //   });
      // }
      return response;
//
    } catch (error) {
      return {'success': false};
    }
  }

  setLanguageInStorage(String language) async {
    await storage.ready;
    storage.setItem('language', json.encode({"language": language}));
    notifyListeners();
  }

  Future login({required String query}) async {
    //  String? fcmToken = await FirebaseMessaging.instance.getToken();
    // if (fcmToken != null && fcmToken != '') {
    //   query += '&fcmToken=$fcmToken';
    // }

    try {
      final url = '${webApi['domain']}${endPoint['login']}$query';
      final response = await RemoteServices.httpRequest(method: 'GET', url: url);

      if (response['success'] && response['login']) {
        user = User.jsonToUser(
          response['result'],
          accessToken: response['accessToken'],
        );

        //   //  user.fcmToken = fcmToken ?? '';

        await storage.ready;
        await storage.setItem(
            'accessToken',
            json.encode({
              "token": user.accessToken,
              "email": user.email,
            }));
      }
      notifyListeners();
      return response;
    } catch (error) {
      return {'success': false, 'login': false};
    }
  }

  Future signup({required Map<String, String> body}) async {
    // String? fcmToken = await FirebaseMessaging.instance.getToken();
    // if (fcmToken != null && fcmToken != '') {
    //   body['fcmToken'] = fcmToken;
    // }

    try {
      final url = '${webApi['domain']}${endPoint['signup']}';
      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: body,
      );

      if (response['success']) {
        user = User.jsonToUser(
          response['result'],
          accessToken: response['accessToken'],
        );

        // user.fcmToken = fcmToken ?? '';

        await storage.ready;
        await storage.setItem(
            'accessToken',
            json.encode({
              "token": user.accessToken,
              "email": user.email,
            }));
      }
      notifyListeners();
      return response;
    } catch (error) {
      return {'success': false, 'message': 'Failed to sign up'};
    }
  }

  Future editProfile({required Map<String, String> body, required Map<String, String> files}) async {
    try {
      final url = '${webApi['domain']}${endPoint['editProfile']}';
      final response = await RemoteServices.formDataRequest(
        method: 'PUT',
        url: url,
        body: body,
        files: files,
        // accessToken: user.accessToken,
      );

      if (response['success']) {}
      notifyListeners();
      return response;
    } catch (error) {
      return {'success': false, 'message': 'failedToSave'};
    }
  }

  logout() async {
    // user = null;
    // await deleteFCMToken();
    await storage.clear();
    notifyListeners();
    return true;
  }

  deleteFCMToken() async {
    // Map<String, String> body = {'fcmToken': user.fcmToken};

    // final String url = '${webApi['domain']}${endPoint['deleteFCMToken']}';
    // try {
    //   final response = await RemoteServices.httpRequest(
    //     method: 'PUT',
    //     url: url,
    //     body: body,
    //     accessToken: user.accessToken,
    //   );

    //   if (!response['success']) {
    //   } else {
    //     notifyListeners();
    //     return;
    //   }
    // } catch (e) {
    //   debugPrint(e.toString());
    // }
  }

  fetchPolicy(String type) async {
    final url = '${webApi['domain']}${endPoint['getAppConfigs']}';
    try {
      final response = await RemoteServices.httpRequest(method: 'POST', url: url, body: {
        "types": [type]
      });
      if (response['success'] && response['result'] != null) {
        return response['result'][0];
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  deleteAccount() async {
    final String url = '${webApi['domain']}${endPoint['deleteAccount']}';
    try {
      final response = await RemoteServices.httpRequest(
        method: 'PUT',
        url: url,
        // accessToken: user.accessToken,
      );

      if (!response['success']) {
      } else {}

      notifyListeners();
      return response;
    } catch (e) {
      return {'success': false, 'message': 'deleteAccountFail'};
    }
  }

  refreshUser() async {
    final String url = '${webApi['domain']}${endPoint['refreshUser']}';
    try {
      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: url,
        // accessToken: user.accessToken,
      );

      if (response['success']) {
        // user = User.jsonToUser(response['result'], accessToken: user.accessToken);

        notifyListeners();
      }

      notifyListeners();
      return response;
    } catch (e) {
      return {'success': false, 'message': 'failedToRefresh'};
    }
  }

  Future getAwsSignedUrl({
    required String fileName,
    required String filePath,
    // required Map<String, String> files,
    // required Map<String, String> body,
  }) async {
    //  String? fcmToken = await FirebaseMessaging.instance.getToken();
    // if (fcmToken != null && fcmToken != '') {
    //   query += '&fcmToken=$fcmToken';
    // }

    try {
      final url = '${webApi['domain']}${endPoint['getAwsSignedUrl']}/$fileName';
      final response = await RemoteServices.httpRequest(method: 'GET', url: url);

      if (response['success']) {
        final s3Response = await http.put(
          Uri.parse(response['result']),
          body: File(filePath).readAsBytesSync(),
        );

        if (s3Response != null) {
          showSnackbar(s3Response.toString());
        }
      }
      notifyListeners();
      return response;
    } catch (error) {
      return {'success': false, 'message': 'failedToGetSignedUrl'};
    }
  }
}
