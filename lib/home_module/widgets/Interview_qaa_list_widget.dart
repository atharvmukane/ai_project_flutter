import 'package:flutter/material.dart';
import 'package:project_interview/colors.dart';
import 'package:project_interview/commonWidgets/asset_svg_icon.dart';
import 'package:project_interview/common_functions.dart';
import 'package:project_interview/navigation/navigators.dart';
import 'package:project_interview/navigation/routes.dart';
import 'package:provider/provider.dart';

import '../../navigation/arguments.dart';
import '../models/interview_model.dart';
// import '../authModule/providers/auth_provider.dart';

class InterviewQAAListWidget extends StatefulWidget {
  final List<InterviewQAA> interviewQAAs;
  final int index;
  const InterviewQAAListWidget({super.key, required this.interviewQAAs, required this.index});

  @override
  State<InterviewQAAListWidget> createState() => _InterviewQAAListWidgetState();
}

class _InterviewQAAListWidgetState extends State<InterviewQAAListWidget> {
  //
  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    // language = Provider.of<AuthProvider>(context).selectedLanguage;
    return GestureDetector(
      onTap: () => push(NamedRoute.answerAnalysisScreen,
          arguments: AnswerAnalysisScreenArguments(
            interviewQAAs: widget.interviewQAAs,
            index: widget.index,
          )),
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        decoration: commonBoxDecoration(10),
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Q.${widget.index + 1}. ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: tS * 15,
                  color: themeBlack,
                  fontFamily: 'Inter',
                )),
            SizedBox(
              width: dW * 0.65,
              child: Text(
                widget.interviewQAAs[widget.index].question,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: textTheme.bodyMedium!.copyWith(
                  fontSize: tS * 15,
                  color: themeBlack,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: AssetSvgIcon(
                'arrow_forward_ios',
                color: themeBlue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
