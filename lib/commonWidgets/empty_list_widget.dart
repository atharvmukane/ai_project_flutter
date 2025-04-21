// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';

import '../colors.dart';

class EmptyListWidget extends StatelessWidget {
  final String text;
  final String subTitle;
  final double topPadding;
  final String image;
  final Color textColor;
  final double? width;
  final double? height;

  EmptyListWidget(
      {Key? key, required this.text, this.subTitle = '', required this.topPadding, this.image = '', this.textColor = white, this.width, this.height})
      : super(key: key);

  double dW = 0.0;
  double tS = 0.0;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;

    return Container(
      margin: EdgeInsets.only(
        top: dW * topPadding,
        left: dW * 0.05,
        right: dW * 0.05,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image != '')
            Container(
              width: width ?? dW * 0.65,
              height: height ?? dW * 0.5,
              margin: EdgeInsets.only(bottom: dW * 0.1),
              child: Image.asset('assets/images/$image.png'),
            ),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: tS * 14,
                  color: textColor,
                ),
            textAlign: TextAlign.center,
          ),
          if (subTitle != '')
            Padding(
              padding: EdgeInsets.only(top: dW * 0.03),
              child: Text(
                subTitle,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: tS * 14,
                      color: const Color(0xff9798A3),
                    ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
