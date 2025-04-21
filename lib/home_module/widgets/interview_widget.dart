import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_interview/commonWidgets/gradient_widget.dart';
import 'package:project_interview/common_functions.dart';
import 'package:project_interview/navigation/navigators.dart';
import 'package:project_interview/navigation/routes.dart';
import '../../commonWidgets/custom_button.dart';
import '../../navigation/arguments.dart';
import './../../home_module/models/interview_model.dart';

import '../../colors.dart';
// import '../authModule/providers/auth_provider.dart';

class InterviewWidget extends StatefulWidget {
  final Interview interview;
  const InterviewWidget({super.key, required this.interview});

  @override
  State<InterviewWidget> createState() => _InterviewWidgetState();
}

class _InterviewWidgetState extends State<InterviewWidget> {
  //
  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;
  bool isNow = false;
  bool isInterviewTomorrow = false;
  bool isWithinPastFiveMins = false;
  bool isCompleted = false;
  bool isUpcoming = false;
  int startsin = -1;
  String startsinText = '';

  // late Timer _timer;

  setData() {
    final timeDifference = widget.interview.date.difference(DateTime.now());

    final isWithinPastFiveMins = (timeDifference.inMinutes <= 5 && timeDifference.inMinutes >= 0);
    final isWithinNextFiveMins = timeDifference.inMinutes <= 5 && timeDifference.inMinutes >= -5;

    isNow = isWithinPastFiveMins || isWithinNextFiveMins;
    isInterviewTomorrow = timeDifference.inDays == 1;

    if (widget.interview.interviewStatus == 'Completed') {
      isCompleted = true;
    } else if (isNow || !timeDifference.isNegative) {
      isUpcoming = !isNow;
      if (isNow || timeDifference.inMinutes < 60) {
        startsin = timeDifference.inMinutes;
        startsinText = '$startsin minute${startsin > 1 ? 's' : ''}';
      } else if (isSameDay(DateTime.now(), widget.interview.date)) {
        startsin = timeDifference.inHours;
        startsinText = '$startsin hour${startsin > 1 ? 's' : ''}';
      }
    }

    if (mounted) setState(() {});
  }

  setTimer() {
    Timer.periodic(Duration(minutes: 1), (_) => setData());
  }

  @override
  void initState() {
    super.initState();
    setData();
    setTimer();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    // language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: isCompleted || isUpcoming ? white : latestInterviewBoxColor,
        boxShadow: shadow,
        // border
        border: Border.all(
          color: !isCompleted
              ?
              // isUpcoming
              //     ? white
              //     :
              themeBlue
              : greenColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE - dd MMM').format(widget.interview.date),
                style: textTheme.bodySmall!.copyWith(
                  fontSize: tS * 16,
                  color: greyText,
                ),
              ),
              Text(
                DateFormat('h:mm a').format(widget.interview.date).toLowerCase(),
                style: textTheme.bodySmall!.copyWith(
                  fontSize: tS * 16,
                  color: greyText,
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'Interview with ${widget.interview.company}',
            style: textTheme.bodyMedium!.copyWith(
              fontSize: tS * 18,
              color: blackColor,
              letterSpacing: .1,
            ),
          ),
          const SizedBox(height: 12),

          //
          if (!isCompleted) ...[
            if (isNow)
              Row(
                children: [
                  Container(
                    // alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), color: const Color(0xFFFF6B6B),
                      //  : const Color(0xFFF5C542),
                    ),
                    child: Text(
                      'Now',
                      style: textTheme.bodyMedium!.copyWith(
                        fontSize: tS * 14,
                        color: blackColor,
                      ),
                    ),
                  ),
                  if (startsin > 0) ...[
                    Padding(
                      padding: EdgeInsets.only(left: 7.5),
                      child: Text(
                        'Starts in $startsinText ',
                        style: textTheme.bodyMedium!.copyWith(
                          fontSize: tS * 13,
                          color: redColor,
                        ),
                      ),
                    )
                  ],
                ],
              ),

            if (!isNow && isSameDay(DateTime.now(), widget.interview.date)) ...[
              Padding(
                padding: EdgeInsets.only(left: 0),
                child: Text(
                  'Starts in $startsinText ',
                  style: textTheme.bodyMedium!.copyWith(
                    fontSize: tS * 13,
                    color: greenColor,
                  ),
                ),
              ),
            ],
            if (isInterviewTomorrow)
              Container(
                // alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xFFF5C542),
                ),
                child: Text(
                  'Tomorrow',
                  style: textTheme.bodyMedium!.copyWith(
                    fontSize: tS * 14,
                    color: blackColor,
                  ),
                ),
              ),

            const SizedBox(height: 13),
            Text(
              'Started preparation, finish all recommended sections',
              style: textTheme.bodySmall!.copyWith(
                fontSize: tS * 14,
                color: greyText,
              ),
            ),
            if (isNow) ...[
              const SizedBox(height: 10),
              CustomButton(
                width: dW * 0.9,
                buttonTextSyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: tS * 14, color: white),
                buttonColor: tertiary,
                height: dW * 0.1,
                elevation: 0.5,
                onPressed: () => push(NamedRoute.interviewSessionScreen, arguments: InterviewSessionScreenArguments(interview: widget.interview)),
                isLoading: false,
                radius: 5,
                buttonText: 'Start session',
              ),
            ] else ...[
              const SizedBox(height: 10),
              CustomButton(
                width: dW * 0.9,
                buttonTextSyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: tS * 14, color: themeBlack),
                buttonColor: white,
                borderColor: themeBlue,
                height: dW * 0.09,
                elevation: 0.5,
                onPressed: () {},
                isLoading: false,
                radius: 5,
                buttonText: 'Start preparation',
              ),
            ]

            // if Completed
          ] else ...[
            // Container(
            //   // alignment: Alignment.centerLeft,
            //   padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(5),
            //     color: isNow ? const Color(0xFFFF6B6B) : const Color(0xFFF5C542),
            //   ),
            //   child: Text(
            //     '2 days ago',
            //     style: textTheme.bodyMedium!.copyWith(
            //       fontSize: tS * 12,
            //       color: blackColor,
            //     ),
            //   ),
            // ),
            Container(
              // alignment: Alignment.centerLeft,
              // margin: EdgeInsets.only(left: 25),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: getColorFromRating(widget.interview.rating),
              ),
              child: Text(
                widget.interview.overallSuccess,
                style: textTheme.bodyMedium!.copyWith(
                  fontSize: tS * 14,
                  color: white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              width: dW * 0.9,
              buttonTextSyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: tS * 14, color: themeBlack),
              buttonColor: white,
              borderColor: blackColor,
              height: dW * 0.09,
              elevation: 0.5,
              onPressed: () => push(NamedRoute.interviewDetailsScreen, arguments: InterviewDetailsScreenArguments(interview: widget.interview)),
              isLoading: false,
              radius: 5,
              buttonText: 'Review Insights',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/insights.png',
                    // height: dW * 0.05,
                    width: dW * 0.06,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Review Insights',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: tS * 14, color: themeBlack),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
