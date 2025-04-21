import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../auth_module/models/user_model.dart';
import '../../auth_module/providers/auth_provider.dart';
import '../../colors.dart';
import '../../commonWidgets/asset_svg_icon.dart';
import '../../commonWidgets/bottom_aligned_widget.dart';
import '../../commonWidgets/circular_loader.dart';
import '../../commonWidgets/custom_app_bar.dart';
import '../../commonWidgets/custom_text_field.dart';
import '../../commonWidgets/details_container.dart';
import '../../commonWidgets/gradient_button.dart';
import '../../commonWidgets/gradient_widget.dart';
import '../../commonWidgets/text_field_bottom_sheet.dart';
import '../../common_functions.dart';
import '../../navigation/navigators.dart';
import '../providers/home_provider.dart';

class AddInterviewScreen extends StatefulWidget {
  const AddInterviewScreen({Key? key}) : super(key: key);

  @override
  AddInterviewScreenState createState() => AddInterviewScreenState();
}

class AddInterviewScreenState extends State<AddInterviewScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  late User user;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;

  final _formKey = GlobalKey<FormState>();

  TextEditingController dateController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController industryController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController resumeController = TextEditingController();

  List _skills = [];
  PlatformFile? selectedResume;
  late DateTime selectedDate;

  Future<TimeOfDay?> _showTimePicker(TimeOfDay time) async {
    return await showTimePicker(
      context: context,
      initialTime: time,
    );
  }

  fetchData() async {
    setState(() => isLoading = true);
    setState(() => isLoading = false);
  }

  void datePicker() async {
    hideKeyBoard();
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(now.year + 100, now.month, now.day);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dateController.text.isEmpty ? firstDate : selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    hideKeyBoard();

    if (pickedDate != null) {
      selectedDate = pickedDate;
      setState(() {
        dateController.text = DateFormat('MM/dd').format(pickedDate);
      });
      timePicker();
    }
  }

  void timePicker() async {
    hideKeyBoard();
    final selectedTime = await _showTimePicker(TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute));
    if (selectedTime != null) {
      selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
      setState(() {
        dateController.text = DateFormat('MM/dd - h:mm a').format(selectedDate);
      });
    }
    hideKeyBoard();
  }

  Future showTextFieldSheet({
    required String title,
    required String value,
    required List<FilteringTextInputFormatter> inputFilter,
    TextInputType? inputType,
    int? maxLength,
    Function? validator,
  }) async {
    hideKeyBoard();

    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      )),
      builder: (BuildContext context) => Wrap(
        children: [
          TextFieldBottomSheet(
            title: title,
            value: value,
            inputFilter: inputFilter,
            inputType: inputType,
            maxLength: maxLength,
            validator: validator,
            addSkill: addSkill,
            pContext: context,
          )
        ],
      ),
    ).then((value) {
      hideKeyBoard();
    });
  }

  addSkill(value) {
    if (value != null) {
      setState(() {
        _skills.add(value);
      });
    }
  }

  showAddSkillSheet() {
    hideKeyBoard();
    Future.delayed(const Duration(milliseconds: 100), () {
      showTextFieldSheet(
        title: 'Add Skill',
        value: '',
        validator: (String? val) {
          if (val!.isEmpty) {
            return 'Please enter a skill';
          }
        },
        inputFilter: [
          // FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        ],
      );
    });
  }

  uploadResume() async {
    hideKeyBoard();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      selectedResume = result.files[0];
      resumeController.text = selectedResume!.name;
    }
  }

  addInterview() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (selectedResume == null) {
      return;
    }
    setState(() => isLoading = true);

    Map<String, String> files = {};
    if (selectedResume != null) {
      files['resume'] = selectedResume!.path!;
    }

    final response = await Provider.of<HomeProvider>(context, listen: false).addInterview(
      accessToken: user.accessToken,
      body: {
        'user': user.id,
        'date': selectedDate.toString(),
        'company': companyController.text.trim(),
        'industry': industryController.text.trim(),
        'jobTitle': jobTitleController.text.trim(),
        'jobDescription': jobDescriptionController.text.trim(),
        'skills': skillController.text.trim(),
      },
      files: files,
    );

    setState(() => isLoading = false);

    if (!response['success']) {
      showSnackbar(response['message']);
    } else {
      pop(response['result']);
    }
  }

  @override
  void initState() {
    super.initState();

    user = Provider.of<AuthProvider>(context, listen: false).user;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    // isLoading = false;
    return Scaffold(
      appBar: CustomAppBar(title: 'Add an Interview', dW: dW),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: screenHorizontalPadding(dW),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: dW * 0.1),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: dW * 0.05,
                      ),
                      child: CustomTextFieldWithLabel(
                        label: 'Select Date',
                        hintText: 'Set a date for the interview',
                        onTap: datePicker,
                        borderColor: greyBorderColor,
                        inputType: TextInputType.none,
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: AssetSvgIcon(
                            'calender',
                          ),
                        ),
                        suffixIconConstraints: const BoxConstraints(maxHeight: 24),
                        controller: dateController,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please select a date!';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: dW * 0.035,
                        bottom: dW * 0.05,
                      ),
                      child: CustomTextFieldWithLabel(
                        label: 'Company Name',
                        hintText: 'Enter the company name you\'re applying to',
                        controller: companyController,
                        borderColor: greyBorderColor,
                        textCapitalization: TextCapitalization.words,
                        inputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the company name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: dW * 0.035,
                        bottom: dW * 0.05,
                      ),
                      child: CustomTextFieldWithLabel(
                        label: 'Industry',
                        hintText: 'Enter the Industry you\'re applying to',
                        controller: industryController,
                        borderColor: greyBorderColor,
                        textCapitalization: TextCapitalization.words,
                        inputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the Industry';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: dW * 0.035,
                        bottom: dW * 0.05,
                      ),
                      child: CustomTextFieldWithLabel(
                        label: 'Job Title',
                        hintText: 'Select the job title you\'re applying for',
                        controller: jobTitleController,
                        borderColor: greyBorderColor,
                        textCapitalization: TextCapitalization.words,
                        inputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please select the job title';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: dW * 0.035,
                        bottom: dW * 0.035,
                      ),
                      child: CustomTextFieldWithLabel(
                        label: 'Job Description',
                        hintText: 'Fill the job description',
                        controller: jobDescriptionController,
                        minLines: 2,
                        maxLines: 5,
                        borderColor: greyBorderColor,
                        textCapitalization: TextCapitalization.sentences,
                        inputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the job description';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: dW * 0.035,
                        bottom: dW * 0.035,
                      ),
                      child: CustomTextFieldWithLabel(
                        label: 'Skills',
                        hintText: 'Enter your skills',
                        controller: skillController,
                        // minLines: 2,
                        // maxLines: 5,
                        borderColor: greyBorderColor,
                        textCapitalization: TextCapitalization.words,
                        inputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the skills';
                          }
                          return null;
                        },
                      ),
                    ),
                    // Padding(
                    //     padding: EdgeInsets.only(bottom: dW * 0.05),
                    //     child: DetailsContainer(
                    //       title: 'Skills',
                    //       rightMost: Padding(
                    //         padding: const EdgeInsets.only(left: 5),
                    //         child: GestureDetector(
                    //           onTap: showAddSkillSheet,
                    //           child: GradientWidget(
                    //             gradient: linearGradient,
                    //             child: const Icon(
                    //               Icons.add_circle_outlined,
                    //               size: 25,
                    //               color: white,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       widget: _skills.isEmpty
                    //           ? Text(
                    //               'No skills added',
                    //               style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: tS * 15, color: lightGray),
                    //             )
                    //           : Wrap(
                    //               runSpacing: 10,
                    //               spacing: 10,
                    //               children: [
                    //                 ..._skills
                    //                     .map((pcode) => Container(
                    //                           decoration: BoxDecoration(
                    //                             borderRadius: BorderRadius.circular(10),
                    //                             gradient: linearGradient,
                    //                           ),
                    //                           padding: EdgeInsets.only(
                    //                             left: dW * 0.03,
                    //                             right: dW * 0.015,
                    //                             top: dW * 0.02,
                    //                             bottom: dW * 0.02,
                    //                           ),
                    //                           child: Row(
                    //                             mainAxisSize: MainAxisSize.min,
                    //                             children: [
                    //                               Text(pcode,
                    //                                   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    //                                         fontSize: tS * 16,
                    //                                         color: white,
                    //                                         letterSpacing: .48,
                    //                                       )),
                    //                               Padding(
                    //                                 padding: const EdgeInsets.only(left: 5),
                    //                                 child: GestureDetector(
                    //                                   onTap: () => setState(() => _skills.remove(pcode)),
                    //                                   child: const Icon(Icons.cancel_rounded, size: 22, color: white),
                    //                                 ),
                    //                               )
                    //                             ],
                    //                           ),
                    //                         ))
                    //                     .toList(),
                    //               ],
                    //             ),
                    //     )),
                    Padding(
                      padding: EdgeInsets.only(top: dW * 0.05),
                      child: CustomTextFieldWithLabel(
                        label: 'Resume',
                        hintText: 'Upload your resume',
                        onTap: uploadResume,
                        borderColor: greyBorderColor,
                        inputType: TextInputType.none,
                        controller: resumeController,
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 12),
                          // child: AssetSvgIcon(
                          //   'upload_resume',
                          //   color: themeBlue,
                          // ),
                          child: Icon(
                            Icons.upload_file_rounded,
                            color: themeBlue,
                          ),
                        ),
                        suffixIconConstraints: const BoxConstraints(maxHeight: 24),
                        // controller: dateController,
                        // textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (selectedResume == null) {
                            return 'Please upload a resume';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: dH * 0.1),
                  ],
                ),
              ),
            ),
          ),
          BottomAlignedWidget(
            dH: dH,
            dW: dW,
            child: GradientButton(
              buttonText: 'Add Interview',
              isLoading: isLoading,
              onPressed: addInterview,
            ),
          )
        ],
      ),
    );
  }
}
