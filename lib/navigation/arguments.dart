import 'package:project_interview/home_module/models/interview_model.dart';

class HomeScreenArguments {
  const HomeScreenArguments();
}

class SelectLanguageScreenArguments {
  final bool fromOnboarding;
  const SelectLanguageScreenArguments({this.fromOnboarding = false});
}

class BottomNavArgumnets {
  final int index;
  BottomNavArgumnets({this.index = 0});
}

class LoadingScreenArguments {
  final String type;
  final String featureId;
  LoadingScreenArguments({
    required this.type,
    required this.featureId,
  });
}

class DashboardScreenArguments {
  DashboardScreenArguments();
}

class AddInterviewScreenArguments {
  AddInterviewScreenArguments();
}

class InterviewSessionScreenArguments {
  final Interview interview;
  InterviewSessionScreenArguments({required this.interview});
}

class InterviewDetailsScreenArguments {
  final Interview interview;
  InterviewDetailsScreenArguments({required this.interview});
}

class AnswerAnalysisScreenArguments {
  final List<InterviewQAA> interviewQAAs;
  final int index;
  AnswerAnalysisScreenArguments({required this.interviewQAAs, required this.index});
}
