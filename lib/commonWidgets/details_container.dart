// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../colors.dart';

// ignore: must_be_immutable
class DetailsContainer extends StatelessWidget {
  String title;
  Widget widget;
  bool isOptional;
  Widget? rightMost;

  DetailsContainer({
    Key? key,
    required this.title,
    required this.widget,
    this.isOptional = false,
    this.rightMost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double dW = MediaQuery.of(context).size.width;
    final double tS = MediaQuery.of(context).textScaleFactor;

    return Container(
      color: transparentColor,
      padding: EdgeInsets.only(top: dW * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: tS * 14,
                          color: grayColor,
                          letterSpacing: .48,
                        )),
                !isOptional ? const Text('*', style: TextStyle(color: Colors.red)) : const SizedBox.shrink()
              ]),
              if (rightMost != null) rightMost!
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: dW * 0.025),
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(color: greyBorderColor), borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(dW * 0.04),
                child: widget),
          ),
        ],
      ),
    );
  }
}
