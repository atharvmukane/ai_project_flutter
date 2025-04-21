// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_interview/colors.dart';
import 'package:project_interview/commonWidgets/asset_svg_icon.dart';
import 'package:project_interview/navigation/arguments.dart';
import 'package:provider/provider.dart';

import '../../auth_module/models/user_model.dart';
import '../../auth_module/providers/auth_provider.dart';
import '../../commonWidgets/circular_loader.dart';
import '../../commonWidgets/custom_app_bar.dart';
import '../../common_functions.dart';
import '../models/interview_model.dart';
import '../widgets/Interview_qaa_list_widget.dart';

class InterviewDetailsScreen extends StatefulWidget {
  final InterviewDetailsScreenArguments args;
  const InterviewDetailsScreen({Key? key, required this.args}) : super(key: key);

  @override
  InterviewDetailsScreenState createState() => InterviewDetailsScreenState();
}

class InterviewDetailsScreenState extends State<InterviewDetailsScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  late User user;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;

  late Interview interview;

  fetchData() async {
    setState(() => isLoading = true);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    user = Provider.of<AuthProvider>(context, listen: false).user;
    interview = widget.args.interview;
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
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(12),
                    decoration: commonBoxDecoration(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Interview with ${interview.company}',
                          style: textTheme.bodyLarge!.copyWith(fontSize: tS * 20, color: themeBlack, letterSpacing: .1),
                        ),
                        Text(
                          DateFormat('mm/dd/yyyy').format(interview.date),
                          style: textTheme.bodyMedium!.copyWith(
                            fontSize: tS * 15,
                            color: themeBlue,
                          ),
                        ),
                        SizedBox(height: dW * 0.05),

                        Text(
                          'Interview duration',
                          style: textTheme.bodyMedium!.copyWith(
                            fontSize: tS * 16,
                            color: grayColor,
                            letterSpacing: .3,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          interview.duration,
                          style: textTheme.bodyMedium!.copyWith(
                            fontSize: tS * 18,
                            color: blackColor,
                            letterSpacing: .3,
                          ),
                        ),
                        SizedBox(height: 30),

                        Row(
                          children: [
                            AssetSvgIcon(
                              'insights',
                              color: themeBlue,
                              width: 25,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'AI Analysis',
                              style: textTheme.bodyMedium!.copyWith(
                                fontSize: tS * 18,
                                color: grayColor,
                                letterSpacing: .3,
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 10),
                            //   child: const Icon(
                            //     Icons.circle,
                            //     size: 5,
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            'Overall interview success',
                            style: textTheme.bodyMedium!.copyWith(
                              fontSize: tS * 14,
                              color: grayColor,
                              letterSpacing: .3,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              // alignment: Alignment.centerLeft,
                              constraints: BoxConstraints(
                                minWidth: dW * 0.2,
                                maxWidth: dW * 0.51,
                              ),
                              margin: EdgeInsets.only(left: 20),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: getColorFromRating(interview.rating),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  interview.overallSuccess,
                                  style: textTheme.bodyMedium!.copyWith(
                                    fontSize: tS * 20,
                                    color: white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 5, left: 10),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              // decoration: BoxDecoration(
                              //   color: getColorFromRating(widget.args.interviewQAAs[currentIndex].analaysis!['rating']),
                              //   // border: Border.all(width: 0, color: transparentColor),
                              //   borderRadius: BorderRadius.circular(10),
                              // ),
                              decoration: commonBoxDecoration(20).copyWith(
                                color: getColorFromRating(interview.rating),
                                border: Border.all(width: 0, color: transparentColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const SizedBox(width: 10),
                                  Text(
                                    interview.rating.toString(),
                                    style: textTheme.bodyLarge!.copyWith(
                                      fontSize: tS * 23,
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
                        //
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: interview.interviewQAA.length,
                    // padding: screenHorizontalPadding(dW),
                    padding: EdgeInsets.only(top: 30),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) => GestureDetector(
                      // onTap: () => push(
                      //   NamedRoute.societyDetailsScreen,
                      //   arguments: SocietyDetailScreenArguments(
                      //     society: societies[i],
                      //   ),
                      // ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // if (i == 0) ...[
                          //   Text(
                          //     'Upcoming Interviews',
                          //     style: textTheme.bodyLarge!.copyWith(
                          //       fontSize: tS * 20,
                          //       color: themeBlack,
                          //       letterSpacing: .1,
                          //     ),
                          //   ),
                          //   const SizedBox(height: 20),
                          // ],
                          InterviewQAAListWidget(
                            key: ValueKey(interview.interviewQAA[i].index),
                            interviewQAAs: interview.interviewQAA,
                            index: i,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
