// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import '../colors.dart';
import '../navigation/navigators.dart';
import 'asset_svg_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final double? leadingWidth;
  final Icon? backIcon;
  final double dW;
  final double elevation;
  final Function? actionMethod;
  final List<Widget>? actions;
  final Color? bgColor;
  final bool? centerTitle;
  final Widget? titleWidget;
  final Function? dragDown;

  CustomAppBar({
    super.key,
    this.title = '',
    this.leading,
    this.leadingWidth,
    this.backIcon,
    required this.dW,
    this.elevation = 2,
    this.actionMethod,
    this.actions,
    this.bgColor,
    this.centerTitle,
    this.titleWidget,
    this.dragDown,
  });

  final double topMargin = Platform.isIOS ? 0 : 0.03;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Container(
      margin: EdgeInsets.only(top: dW * topMargin),
      child: AppBar(
        centerTitle: false,
        shadowColor: const Color(0xFF975EFF).withOpacity(0.1),
        backgroundColor: bgColor ?? white,
        elevation: elevation,
        leadingWidth: leadingWidth ?? (dW * 0.18),
        leading: leading ??
            GestureDetector(
              onTap: () {
                if (actionMethod != null) {
                  actionMethod!();
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: AssetSvgIcon('back_arrow'),
              ),
            ),
        title: titleWidget ??
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: lightBlack,
                    fontSize: textScale * 16,
                  ),
            ),
        titleSpacing: 0,
        actions: actions ?? [],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(dW * (0.145 + topMargin));
}
