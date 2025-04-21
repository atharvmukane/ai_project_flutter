import 'package:flutter/material.dart';
import 'package:project_interview/navigation/navigators.dart';

import '../../api.dart';
import '../../http_helper.dart';
import '../models/interview_model.dart';

class HomeProvider with ChangeNotifier {
  List<Interview> _interviews = [];
  List<Interview> get interviews => [..._interviews];
  //
  //

  Future addInterview({
    required String accessToken,
    required Map<String, String> body,
    required Map<String, String> files,
  }) async {
    try {
      final url = '${webApi['domain']}${endPoint['addInterview']}';
      final response = await RemoteServices.formDataRequest(
        method: 'POST',
        url: url,
        body: body,
        files: files,
        accessToken: accessToken,
      );

      if (response['success']) {
        _interviews.add(Interview.fromJson(response['result']));
        _interviews.sort((a, b) {
          return a.date.compareTo(b.date);
        });
      }

      notifyListeners();
      return response;
    } catch (error) {
      return {'success': false, 'message': 'failedToSave'};
    }
  }

  Future getInterviews(String accessToken, {required String query}) async {
    try {
      final url = '${webApi['domain']}${endPoint['getInterviews']}$query';
      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: url,
        accessToken: accessToken,
      );
      _interviews = [];
      if (response['success']) {
        List<Interview> fetchedInterviews = [];
        fetchedInterviews = (response['result'] as List).map((interview) => Interview.fromJson(interview)).toList();
        _interviews = fetchedInterviews;
      }

      notifyListeners();
      return response;
    } catch (error) {
      return {'success': false, 'message': 'Failed to get scheduled interviews'};
    }
  }

  Future saveRecording({
    required String accessToken,
    required Map<String, String> body,
    required Map<String, String> files,
  }) async {
    try {
      final url = '${webApi['domain']}${endPoint['saveRecording']}';
      final response = await RemoteServices.formDataRequest(
        method: 'POST',
        url: url,
        body: body,
        files: files,
        accessToken: accessToken,
      );

      if (response['success']) {}

      notifyListeners();
      return response;
    } catch (error) {
      return {'success': false, 'message': 'failedToSave'};
    }
  }

  Future endInterviewSession({
    required String accessToken,
    required Map<String, String> body,
  }) async {
    try {
      final url = '${webApi['domain']}${endPoint['endInterviewSession']}';
      final response = await RemoteServices.httpRequest(
        method: 'PUT',
        url: url,
        body: body,
        accessToken: accessToken,
      );

      if (response['success']) {
        pop();
        Future.delayed(const Duration(milliseconds: 500), () {
          _interviews.removeWhere((interview) => interview.id == body['interviewId']);
          notifyListeners();
        });
      }

      return response;
    } catch (error) {
      return {'success': false, 'message': 'Failed to close interview'};
    }
  }
}
