// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../commonWidgets/custom_text_field.dart';
import '../../commonWidgets/gradient_button.dart';
import '../../common_functions.dart';
import '../../navigation/arguments.dart';
import '../../navigation/navigators.dart';
import '../../navigation/routes.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  // final SignupScreenArguments args;
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final LocalStorage storage = LocalStorage('interview_flow');
  //
  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;

  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confrimPasswordController = TextEditingController();

  String selectedRole = '';
  List<String> roles = ['Job Seeker', 'Employer'];

  void updateValidity() {
    setState(() {});
  }

  signup() async {
    bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      setState(() {});
      return;
    }

    setState(() => isLoading = true);

    final Map<String, String> body = {
      "fullName": fullNameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      // "role": selectedRole,
      "role": 'Job Seeker',
    };

    final response = await Provider.of<AuthProvider>(context, listen: false).signup(
      body: body,
    );
    setState(() => isLoading = false);

    if (!response['success']) {
      showSnackbar(response['message']);
    } else {
      pushAndRemoveUntil(NamedRoute.dashboardScreen, arguments: DashboardScreenArguments());
    }
  }

  @override
  void initState() {
    super.initState();

    fullNameController.addListener(updateValidity);
    emailController.addListener(updateValidity);
    passwordController.addListener(updateValidity);
    confrimPasswordController.addListener(updateValidity);
  }

  @override
  void dispose() {
    super.dispose();

    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confrimPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    bool valid = fullNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(emailController.text) &&
        passwordController.text.isNotEmpty &&
        confrimPasswordController.text.isNotEmpty;

    return Scaffold(
        backgroundColor: white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: dW * 0.1),
                          child: RichText(
                              text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Create',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: tS * 20,
                                  color: themeBlack,
                                ),
                              ),
                              TextSpan(
                                text: ' Account',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: tS * 20,
                                  color: themeBlue,
                                ),
                              ),
                            ],
                          )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 40,
                            left: 16,
                            right: 16,
                            bottom: dW * 0.05,
                          ),
                          child: CustomTextFieldWithLabel(
                            label: 'Full Name',
                            hintText: 'Enter your full name',
                            controller: fullNameController,
                            borderColor: greyBorderColor,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: dW * 0.05),
                          child: CustomTextFieldWithLabel(
                            label: 'Email',
                            hintText: 'Enter your email',
                            controller: emailController,
                            borderColor: greyBorderColor,
                            inputType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            // textInputType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: dW * 0.05),
                          child: CustomTextFieldWithLabel(
                            obscureText: true,
                            maxLines: 1,
                            label: 'Password',
                            hintText: 'Create a password',
                            controller: passwordController,
                            borderColor: greyBorderColor,
                            inputType: TextInputType.text,
                            textCapitalization: TextCapitalization.none,
                            // textInputType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please create your password';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: dW * 0.05),
                          child: CustomTextFieldWithLabel(
                            obscureText: true,
                            maxLines: 1,
                            label: 'Confirm Password',
                            hintText: 'Re-type your password',
                            controller: confrimPasswordController,
                            borderColor: greyBorderColor,
                            inputType: TextInputType.text,
                            textCapitalization: TextCapitalization.none,
                            // textInputType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please re-type your password';
                              } else if (passwordController.text.trim() != confrimPasswordController.text.trim()) {
                                return 'Password does not match';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Stack(
                  children: [
                    GradientButton(
                      elevation: valid ? 2 : 0,
                      isLoading: isLoading,
                      onPressed: valid ? signup : () {},
                      buttonText: 'Save & Continue',
                    ),
                    if (!valid)
                      Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: Container(
                            color: Colors.white.withOpacity(.7),
                          )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
