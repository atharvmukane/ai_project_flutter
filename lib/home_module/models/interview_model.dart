import 'package:project_interview/common_functions.dart';

class InterviewQAA {
  int index;
  String question;
  String answer;
  Map? analaysis;
  List tags;

  InterviewQAA({
    required this.index,
    required this.question,
    required this.answer,
    this.analaysis,
    required this.tags,
  });

  static InterviewQAA fromJson(Map data) {
    return InterviewQAA(
      index: data['index'],
      question: data['question'],
      answer: data['answer'],
      analaysis: data['analaysis'],
      tags: data['tags'] ?? [],
    );
  }
}

class Interview {
  final String id;
  final String company;
  final String industry;
  final DateTime date;
  final String jobTitle;
  final String jobDescription;
  final List skills;
  List<InterviewQAA> interviewQAA;
  String interviewStatus;
  String duration;
  double rating;
  String overallSuccess;

  Interview({
    required this.id,
    required this.company,
    required this.industry,
    required this.date,
    required this.jobTitle,
    required this.jobDescription,
    required this.skills,
    required this.interviewQAA,
    required this.interviewStatus,
    required this.duration,
    required this.rating,
    required this.overallSuccess,
  });

  static Interview fromJson(Map data) {
    return Interview(
      id: data['_id'],
      company: data['company'],
      industry: data['industry'],
      date: getParseDate(data['date'])!,
      jobTitle: data['jobTitle'],
      jobDescription: data['jobDescription'],
      skills: data['skills'],
      interviewQAA: (data['interviewQAA'] as List).map((qaa) => InterviewQAA.fromJson(qaa)).toList(),
      interviewStatus: data['interviewStatus'],
      duration: data['duration'] ?? '0 hr 0 mins',
      rating: data['rating'] ?? 0,
      overallSuccess: data['overallSuccess'] ?? '',
    );
  }
}
