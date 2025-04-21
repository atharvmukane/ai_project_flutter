// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../colors.dart';
import '../common_functions.dart';
import 'asset_svg_icon.dart';

class BtmNavAppBar extends StatelessWidget {
  BtmNavAppBar({super.key});

  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  // late User user;
  TextTheme get textTheme => Theme.of(bContext).textTheme;

  // String get addressText {
  //   String toReturn = '';

  //   if (user.addresses[0].wing != '') {
  //     toReturn = '${user.addresses[0].wing} - ';
  //   }
  //   // toReturn += user.addresses[0].propertyNumber;
  //   toReturn += user.addresses[0].fullAddress;

  //   return toReturn;
  // }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    final dH = MediaQuery.of(context).size.height;
    tS = MediaQuery.of(context).textScaleFactor;
    // language = Provider.of<AuthProvider>(context).selectedLanguage;
    // user = Provider.of<AuthProvider>(context).user;

    return Container(
      width: dW,
      padding: EdgeInsets.only(
        left: dW * horizontalPaddingFactor,
        right: dW * horizontalPaddingFactor,
        top: dW * (iOSCondition(dH) ? 0.01 : 0.03),
        bottom: dW * 0.025,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: dW * 0.5,
                  child: Text(
                    'Hello User',
                    style: textTheme.bodyLarge!.copyWith(
                      fontSize: tS * 16,
                      fontWeight: FontWeight.w700,
                      color: grayColor,
                    ),
                  ),
                ),
                SizedBox(height: dW * 0.01),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            // onTap: () => push(NamedRoute.notificationsScreen),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 9),
              child: const AssetSvgIcon('notification'),
            ),
          ),
        ],
      ),
    );
  }
}

class DateRangeHeader extends StatelessWidget {
  final String dateRangeText;
  final Color? color;
  DateRangeHeader(this.dateRangeText, {super.key, this.color});

  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  TextTheme get textTheme => Theme.of(bContext).textTheme;

  Widget get dash => Expanded(
        child: Container(
          decoration: BoxDecoration(border: Border(top: dividerBorder.copyWith(color: color ?? dividerColor))),
        ),
      );

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    // language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Container(
      margin: EdgeInsets.only(top: dW * 0.055, bottom: dW * 0.045),
      child: Row(
        children: [
          dash,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              dateRangeText,
              style: textTheme.bodyLarge!.copyWith(
                fontSize: tS * 12,
                color: lightGray,
              ),
            ),
          ),
          dash,
        ],
      ),
    );
  }
}
