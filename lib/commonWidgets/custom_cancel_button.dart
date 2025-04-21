import 'package:flutter/material.dart';
import 'package:project_interview/colors.dart';
import 'package:provider/provider.dart';

import '../auth_module/providers/auth_provider.dart';
import '../common_functions.dart';
import 'gradient_widget.dart';

class CustomCancelButton extends StatelessWidget {
  Function ontap;
  final String? btnText;
  CustomCancelButton({
    Key? key,
    this.btnText,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double dH = MediaQuery.of(context).size.height;
    double dW = MediaQuery.of(context).size.width;
    double tS = MediaQuery.of(context).textScaleFactor;
    Map language = Provider.of<AuthProvider>(context).selectedLanguage;
    return SizedBox(
      width: dW * 0.4,
      child: OutlinedButton(
        onPressed: () => ontap(),
        style: OutlinedButton.styleFrom(
          backgroundColor: white,
          elevation: 0,
          foregroundColor: redColor,
          padding: const EdgeInsets.all(0),
          fixedSize: Size(dW * 0.87, dW * 0.145),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            // border: Border.all(color: redColor),
          ),
          child: Center(
            child: Text(btnText ?? language['cancel'],
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: tS * 20, letterSpacing: .48, color: redColor)),
          ),
        ),
      ),
    );
  }
}
