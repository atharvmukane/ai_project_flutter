// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:project_interview/colors.dart';
import 'package:project_interview/commonWidgets/asset_svg_icon.dart';
import 'package:project_interview/commonWidgets/gradient_widget.dart';
import 'package:project_interview/navigation/arguments.dart';
import 'package:provider/provider.dart';

import '../../auth_module/models/user_model.dart';
import '../../auth_module/providers/auth_provider.dart';
import '../../commonWidgets/circular_loader.dart';
import '../../commonWidgets/custom_app_bar.dart';
import '../../common_functions.dart';

class AnswerAnalysisScreen extends StatefulWidget {
  final AnswerAnalysisScreenArguments args;
  const AnswerAnalysisScreen({Key? key, required this.args}) : super(key: key);

  @override
  AnswerAnalysisScreenState createState() => AnswerAnalysisScreenState();
}

class AnswerAnalysisScreenState extends State<AnswerAnalysisScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  late User user;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;

  int currentIndex = 0;

  fetchData() async {
    setState(() => isLoading = true);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    currentIndex = widget.args.index;
    user = Provider.of<AuthProvider>(context, listen: false).user;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Scaffold(
      appBar: CustomAppBar(title: 'Interview Analysis', dW: dW),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: dW * 0.4,
        height: dW * 0.14,
        decoration: commonBoxDecoration(10).copyWith(
          // color: themeBlue.withOpacity(.5),
          border: Border.all(width: 0, color: themeBlue),
          // color: themeBlue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                if (currentIndex > 0) {
                  currentIndex--;
                }
                setState(() {});
              },
              child: Container(
                // color: redColor,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..scale(-1.0, 1.0),
                  child: AssetSvgIcon(
                    'arrow_forward_ios',
                    color: currentIndex > 0 ? themeBlue : grayColor,
                    width: 15,
                  ),
                ),
              ),
            ),
            Container(
              // width: dW * 0.2,
              child: Text(
                'Q.${currentIndex + 1}',
                style: textTheme.bodyMedium!.copyWith(
                  fontSize: tS * 20,
                  color: themeBlack,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (currentIndex < widget.args.interviewQAAs.length - 1) {
                  currentIndex++;
                }
                setState(() {});
              },
              child: Container(
                // color: redColor,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: AssetSvgIcon(
                  'arrow_forward_ios',
                  color: currentIndex < widget.args.interviewQAAs.length - 1 ? themeBlue : grayColor,
                  width: 15,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(child: screenBody(), bottom: false),
    );
  }

  screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? const Center(child: CircularLoader())
          : SingleChildScrollView(
              padding: screenHorizontalPadding(dW),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: dW * 0.05),
                  Text(
                    'Question',
                    style: textTheme.bodyMedium!.copyWith(
                      fontSize: tS * 16,
                      color: const Color(0xFF666666),
                    ),
                  ),
                  Container(
                    height: dH * 0.135,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(10),
                    decoration: commonBoxDecoration(10).copyWith(
                      border: Border.all(width: 0.5, color: const Color(0xFFAAAAAA)),
                      color: white,
                    ),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Text(
                          widget.args.interviewQAAs[currentIndex].question,
                          // maxLines: 4,
                          style: textTheme.bodyMedium!.copyWith(
                            fontSize: tS * 16,
                            color: themeBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Your response',
                        style: textTheme.bodyMedium!.copyWith(
                          fontSize: tS * 16,
                          color: const Color(0xFF666666),
                        ),
                      ),
                      Container(
                        // alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: getColorFromRating(double.parse((widget.args.interviewQAAs[currentIndex].analaysis!['rating']).toString()))
                              .withOpacity(.8),
                        ),
                        child: Text(
                          widget.args.interviewQAAs[currentIndex].analaysis!['answer_success'],
                          style: textTheme.bodyMedium!.copyWith(
                            fontSize: tS * 14,
                            color: blackColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: dH * 0.2,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(10),
                    decoration: commonBoxDecoration(10).copyWith(
                      border: Border.all(width: 0.5, color: const Color(0xFFAAAAAA)),
                      color: white,
                    ),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Text(
                          widget.args.interviewQAAs[currentIndex].answer,
                          // maxLines: 4,
                          style: textTheme.bodyMedium!.copyWith(
                            fontSize: tS * 16,
                            color: themeBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    // margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(10),
                    decoration: commonBoxDecoration(10).copyWith(
                      border: Border.all(width: 0.5, color: const Color(0xFFAAAAAA)),
                      color: white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            AssetSvgIcon('insights', color: themeBlue, width: 24),
                            const SizedBox(width: 5),
                            GradientWidget(
                              gradient: linearGradient,
                              child: Text(
                                'AI Analysis',
                                style: textTheme.bodyLarge!.copyWith(
                                  fontSize: tS * 20,
                                  color: const Color(0xFF666666),
                                ),
                              ),
                            ),
                            const Spacer(),
                            // Text(
                            //   'Rating:  ',
                            //   style: textTheme.bodyLarge!.copyWith(
                            //     fontSize: tS * 16,
                            //     // color: getColorFromRating(widget.args.interviewQAAs[currentIndex].analaysis!['rating']),
                            //     color: themeBlack,
                            //   ),
                            // ),
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              // decoration: BoxDecoration(
                              //   color: getColorFromRating(widget.args.interviewQAAs[currentIndex].analaysis!['rating']),
                              //   // border: Border.all(width: 0, color: transparentColor),
                              //   borderRadius: BorderRadius.circular(10),
                              // ),
                              decoration: commonBoxDecoration(20).copyWith(
                                color: getColorFromRating(widget.args.interviewQAAs[currentIndex].analaysis!['rating'].toDouble()),
                                border: Border.all(width: 0, color: transparentColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.args.interviewQAAs[currentIndex].analaysis!['rating'].toString(),
                                    style: textTheme.bodyLarge!.copyWith(
                                      fontSize: tS * 25,
                                      // color: getColorFromRating(widget.args.interviewQAAs[currentIndex].analaysis!['rating']),
                                      color: white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3),
                                    child: Text(
                                      ' / 10',
                                      textAlign: TextAlign.end,
                                      style: textTheme.bodyLarge!.copyWith(
                                        fontSize: tS * 17,
                                        // color: getColorFromRating(widget.args.interviewQAAs[currentIndex].analaysis!['rating']),
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (widget.args.interviewQAAs[currentIndex].analaysis != null) ...[
                          const SizedBox(height: 30),
                          // TAGS
                          Wrap(
                            runSpacing: 10,
                            spacing: 10,
                            children: widget.args.interviewQAAs[currentIndex].analaysis!['tags']
                                .map<Widget>(
                                  (tag) => Container(
                                    // alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5), color: getColorFromText(tag['color']).withOpacity(.8),
                                      //  : const Color(0xFFF5C542),
                                    ),
                                    child: Text(
                                      tag['label'],
                                      style: textTheme.bodyMedium!.copyWith(
                                        fontSize: tS * 14,
                                        color: blackColor,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),

                          // answer_success_suggestion
                          const SizedBox(height: 20),
                          if (widget.args.interviewQAAs[currentIndex].analaysis!['answer_success_suggestion'] != null &&
                              widget.args.interviewQAAs[currentIndex].analaysis!['answer_success_suggestion'] != '') ...[
                            // Text(
                            //   'Tone and Confidence',
                            //   style: textTheme.bodyLarge!.copyWith(
                            //     fontSize: tS * 14,
                            //     color: const Color(0xFF666666),
                            //   ),
                            // ),
                            // const SizedBox(height: 5),
                            Text(
                              widget.args.interviewQAAs[currentIndex].analaysis!['answer_success_suggestion'],
                              style: textTheme.bodyMedium!.copyWith(
                                fontSize: tS * 15,
                                color: themeBlack,
                              ),
                            ),
                          ],

                          // STRENGTHS
                          const SizedBox(height: 20),
                          if ((widget.args.interviewQAAs[currentIndex].analaysis!['strengths'] as List).isNotEmpty) ...[
                            Text(
                              'Strengths',
                              style: textTheme.bodyLarge!.copyWith(
                                fontSize: tS * 16,
                                color: redColor,
                              ),
                            ),
                            Container(
                              // height: dH * 0.135,
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.all(10),
                              decoration: commonBoxDecoration(10).copyWith(
                                border: Border.all(width: 0.5, color: redColor),
                                color: white,
                              ),
                              child: Scrollbar(
                                child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: widget.args.interviewQAAs[currentIndex].analaysis!['strengths']
                                          .map<Widget>(
                                            (strength) => Container(
                                              width: dW,
                                              // alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),

                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 6),
                                                    child: Icon(Icons.circle, size: 10),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Container(
                                                    width: dW * 0.7,
                                                    child: Text(
                                                      strength,
                                                      style: textTheme.bodyMedium!.copyWith(
                                                        fontSize: tS * 16,
                                                        color: blackColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    )),
                              ),
                            ),
                          ],
                          // IMPROVEMENTS
                          const SizedBox(height: 20),
                          if ((widget.args.interviewQAAs[currentIndex].analaysis!['improvements'] as List).isNotEmpty) ...[
                            Text(
                              'Suggested Improvements',
                              style: textTheme.bodyLarge!.copyWith(
                                fontSize: tS * 16,
                                color: Colors.orange,
                              ),
                            ),
                            Container(
                              // height: dH * 0.135,
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.all(10),
                              decoration: commonBoxDecoration(10).copyWith(
                                border: Border.all(width: 0.5, color: Colors.orange),
                                color: white,
                              ),
                              child: Scrollbar(
                                child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: widget.args.interviewQAAs[currentIndex].analaysis!['improvements']
                                          .map<Widget>(
                                            (improvement) => Container(
                                              width: dW,
                                              // alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),

                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 6),
                                                    child: Icon(Icons.circle, size: 10),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Container(
                                                    width: dW * 0.7,
                                                    child: Text(
                                                      improvement,
                                                      style: textTheme.bodyMedium!.copyWith(
                                                        fontSize: tS * 16,
                                                        color: blackColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    )),
                              ),
                            )
                          ],
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: dH * 0.2),
                ],
              ),
            ),
    );
  }
}
