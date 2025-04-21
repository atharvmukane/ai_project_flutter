// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:project_interview/colors.dart';
import 'package:project_interview/commonWidgets/empty_list_widget.dart';
import 'package:project_interview/navigation/navigators.dart';
import 'package:provider/provider.dart';

import '../../auth_module/models/user_model.dart';
import '../../auth_module/providers/auth_provider.dart';
import '../../commonWidgets/circular_loader.dart';
import '../../commonWidgets/text_widget.dart';
import '../../common_functions.dart';
import '../../navigation/arguments.dart';
import '../../navigation/routes.dart';
import '../models/interview_model.dart';
import '../providers/home_provider.dart';
import '../widgets/interview_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  late User user;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;

  List<Interview> interviews = [];

  String selectedTab = 'Upcoming';

  getInterviews() async {
    final response = await Provider.of<HomeProvider>(context, listen: false).getInterviews(user.accessToken, query: '?status=$selectedTab');

    if (!response['success']) {
      showSnackbar(response['message']);
    }
  }

  myInit() async {
    setState(() => isLoading = true);
    await getInterviews();
    setState(() => isLoading = false);
  }

  selectTab(String tab) async {
    setState(() {
      selectedTab = tab;
      isLoading = true;
    });

    await getInterviews();
    setState(() => isLoading = false);
  }

  refresh() async {
    await getInterviews();
  }

  @override
  void initState() {
    super.initState();

    user = Provider.of<AuthProvider>(context, listen: false).user;
    myInit();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    interviews = Provider.of<HomeProvider>(context).interviews;

    return Scaffold(
      // appBar: CustomAppBar(title: 'Inteview Flow', dW: dW),
      body: SafeArea(child: screenBody(), bottom: false),
      floatingActionButton: GestureDetector(
        onTap: () => push(NamedRoute.addInterviewScreen, arguments: AddInterviewScreenArguments()),
        child: Container(
          margin: EdgeInsets.only(bottom: 15),
          padding: EdgeInsets.all(dW * 0.035),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: const LinearGradient(colors: [
                Color(0XFF019FED),
                Color(0XFF0036B4),
              ])),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.add_rounded,
                color: Color(0xFFFFFFFF),
                size: 19,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: dW * 0.02,
                  right: dW * 0.02,
                ),
                child: Text(
                  'Add Interview',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: tS * 14,
                        color: const Color(0xFFFFFFFF),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 20,
              left: dW * 0.05,
            ),
            alignment: Alignment.centerLeft,
            width: dW * 0.4,
            child: Image.asset(
              'assets/images/interview_flow.png',
              width: dW * 0.4,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: dW * 0.08,
              bottom: dW * 0.025,
              left: dW * horizontalPaddingFactor,
              right: dW * horizontalPaddingFactor,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: dW * 0.01,
              vertical: dW * 0.01,
            ),
            decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(10), boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTab(
                  label: 'Upcoming',
                  isSelected: selectedTab == 'Upcoming',
                  selectTab: () => selectTab('Upcoming'),
                  vpf: 0.03,
                  fW: FontWeight.w600,
                  fS: 16,
                  tC: grayColor,
                ),
                CustomTab(
                  label: 'Completed',
                  isSelected: selectedTab == 'Completed',
                  selectTab: () => selectTab('Completed'),
                  vpf: 0.03,
                  fW: FontWeight.w600,
                  fS: 16,
                  tC: grayColor,
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: greenColor,
              backgroundColor: white,
              onRefresh: () => getInterviews(),
              child: ListView(
                // padding: screenHorizontalPadding(dW),
                children: [
                  SizedBox(height: dW * 0.0),
                  if (isLoading) ...[
                    // Loading
                    Container(
                      width: dW,
                      height: dW * 0.3,
                      padding: EdgeInsets.only(top: dW * 0.2),
                      child: const CircularLoader(),
                    ),
                  ],
                  if (!isLoading) ...[
                    // No Interviews available
                    if (interviews.isEmpty)
                      Container(
                        width: dW,
                        child: EmptyListWidget(
                          width: dW,
                          height: dW * 0.65,
                          image: 'no_interview_scheduled',
                          text: 'No Interviews scheduled yet.\n Start by adding one now.',
                          textColor: themeBlack,
                          topPadding: 0.3,
                        ),
                      ),

                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: interviews.length,
                      padding: screenHorizontalPadding(dW),
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
                            InterviewWidget(
                              key: ValueKey(interviews[i].id),
                              interview: interviews[i],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: dW * 0.2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function selectTab;
  final double vpf;
  final FontWeight fW;
  final double fS;
  final Color tC;
  final int partitions;

  CustomTab({
    super.key,
    required this.label,
    required this.isSelected,
    required this.selectTab,
    this.vpf = 0.04,
    this.fW = FontWeight.w600,
    this.fS = 14,
    this.tC = lightGray,
    this.partitions = 2,
  });

  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  TextTheme get textTheme => Theme.of(bContext).textTheme;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return GestureDetector(
      onTap: () => selectTab(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: dW * vpf),
        width: (dW * (1 - (2 * horizontalPaddingFactor) - (2 * 0.01)) / partitions) - 5,
        decoration: BoxDecoration(
          gradient: isSelected ? linearGradient : null,
          color: white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: TextWidget(
            title: label,
            color: isSelected ? white : tC,
            fontWeight: fW,
            fontSize: fS,
          ),
        ),
      ),
    );
  }
}
