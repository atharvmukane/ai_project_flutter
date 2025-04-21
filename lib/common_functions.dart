// ignore_for_file: depend_on_referenced_packages, deprecated_member_use, prefer_const_declarations, avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'colors.dart';
import 'commonWidgets/asset_svg_icon.dart';
import 'commonWidgets/text_widget.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

String networkDummy =
    'https://media.istockphoto.com/vectors/default-avatar-photo-placeholder-icon-grey-profile-picture-business-vector-id1327592449?k=20&m=1327592449&s=612x612&w=0&h=6yFQPGaxmMLgoEKibnVSRIEnnBgelAeIAf8FqpLBNww=';

BuildContext get bContext => navigatorKey.currentContext!;

MediaQueryData get _mediaQuery => MediaQuery.of(bContext);

double get _tS => _mediaQuery.textScaleFactor;

List<Color> get gradientColors => [
      const Color(0xFF4A90E2).withOpacity(1),
      const Color(0xFF4A90E2).withOpacity(0.95),
      const Color(0xFF4A90E2).withOpacity(1),
    ];

Gradient get linearGradient => LinearGradient(
      colors: gradientColors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

hideKeyBoard() => FocusScope.of(bContext).requestFocus(FocusNode());

double horizontalPaddingFactor = 0.05;

screenHorizontalPadding(double dW, {double? verticalF}) =>
    EdgeInsets.symmetric(horizontal: dW * horizontalPaddingFactor, vertical: verticalF != null ? (dW * verticalF) : 0.0);

List<BoxShadow> get shadow => [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        offset: const Offset(0, 3),
        spreadRadius: 0,
        blurRadius: 10,
      )
    ];

Color primaryFadeBorder = const Color(0xFF72CD95).withOpacity(0.4);

BoxDecoration commonBoxDecoration(double radius) => BoxDecoration(
    color: Colors.white, borderRadius: BorderRadius.circular(radius), border: Border.all(width: 1, color: primaryFadeBorder), boxShadow: shadow);

bool iOSCondition(double dH) => Platform.isIOS && dH > 850;

Text subHeaderText(String title, [Color color = lightGray]) => Text(
      title,
      style: Theme.of(bContext).textTheme.bodyLarge!.copyWith(fontSize: _tS * 16, color: color),
    );

BorderSide get greyBorderSide => const BorderSide(width: 1, color: Color(0xFFEAEAEA));

String amountText(double amount) {
  String amountString = amount.toStringAsFixed(2);

  if (amountString.split('.')[1][1] == '0') {
    amountString = amountString.split('.')[0] + '.' + amountString.split('.')[1][0];
    if (amountString.split('.')[1][0] == '0') {
      amountString = amountString.split('.')[0];
    }
  }
  return amountString;
}

BorderSide get dividerBorder => const BorderSide(color: dividerColor, width: 1);

String convertAmountString(double amount) {
  var strToReturn;
  String aS = amount.round().toStringAsFixed(0);
  // if (amount < 100000) {
  //   return regExpText(aS);
  // }
  final list = aS.split('.');
  aS = list[0];
  final length = aS.length;
  if (length < 6) {
    strToReturn = amountText(amount);
  } else if (length == 6) {
    String trail = aS.substring(length - 5, length);
    String lead = aS.substring(0, length - 5);
    if (trail[0] != '0') lead = lead + '.${trail[0]}';
    strToReturn = lead + 'L';
  } else if (length == 7) {
    String trail = aS.substring(length - 6, length);
    String lead = aS.substring(0, length - 6) + '0';
    if (trail[0] != '0') lead = lead + '.${trail[0]}';
    strToReturn = lead + 'L';
  } else if (length > 7) {
    String trail = aS.substring(length - 7, length);
    String lead = aS.substring(0, length - 7);
    if (trail[0] != '0') lead = lead + '.${trail[0]}';
    strToReturn = lead + 'Cr';
  }
  return strToReturn;
}

pickImage(ImageSource source) async {
  try {
    ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    return image;
  } catch (e) {
    return null;
  }
}

showSnackbar(String msg, [Color color = Colors.red, int duration = 2]) {
  ScaffoldMessenger.of(bContext).hideCurrentSnackBar();
  ScaffoldMessenger.of(bContext).showSnackBar(SnackBar(
    content: Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text(
        msg,
        softWrap: true,
        style: Theme.of(bContext).textTheme.bodyLarge!.copyWith(fontSize: _tS * 14.5, color: Colors.white),
      ),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    duration: Duration(seconds: duration),
    dismissDirection: DismissDirection.down,
    margin: const EdgeInsets.only(
      // bottom: _mediaQuery.size.height * 0.8,
      bottom: 40,
      right: 20,
      left: 20,
    ),
  ));
}

showSnackbarWithContext(String msg, [Color color = Colors.red, int duration = 2, BuildContext? pContext]) {
  ScaffoldMessenger.of(pContext ?? bContext).hideCurrentSnackBar();
  ScaffoldMessenger.of(pContext ?? bContext).showSnackBar(SnackBar(
    content: Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text(
        msg,
        softWrap: true,
        style: Theme.of(pContext ?? bContext).textTheme.bodyLarge!.copyWith(fontSize: _tS * 14.5, color: Colors.white),
      ),
    ),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    duration: Duration(seconds: duration),
    dismissDirection: DismissDirection.down,
    margin: EdgeInsets.only(
      bottom: MediaQuery.of(pContext ?? bContext).size.height * 0.9,
      // bottom: 40,
      right: 20,
      left: 20,
    ),
  ));
}

DateTime? getParseDate(String? date) => date != null ? DateTime.parse(date).toLocal() : null;

PopupMenuEntry popupMenuItem({
  required int position,
  required String title,
  String? icon,
  required double dW,
}) {
  return PopupMenuItem(
    value: position,
    height: dW * 0.07,
    child: Container(
      margin: EdgeInsets.only(bottom: dW * 0.02, top: dW * 0.02),
      child: Row(
        children: [
          if (icon != null) ...[
            AssetSvgIcon(icon),
            SizedBox(width: dW * 0.03),
          ],
          TextWidget(
            title: title,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: lightBlack,
          ),
        ],
      ),
    ),
  );
}

selectDateRange(String selectedFilter, DateTime startDate, DateTime endDate) async {
  return await showDateRangePicker(
      context: bContext,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
      initialDateRange: selectedFilter == 'customDateRange' ? DateTimeRange(start: startDate, end: endDate) : null,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            //Header background color
            primaryColor: Colors.blue,
            //Background color
            scaffoldBackgroundColor: Colors.grey[50],
            //Divider color
            dividerColor: Colors.grey,
            //Non selected days of the month color
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.black),
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              //Selected dates background color
              primary: Colors.blue,
              //Month title and week days color
              onSurface: Colors.black,
              //Header elements and selected dates text color
              //onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      });
}

bool isSameDay(DateTime date1, DateTime date2) => date1.day == date2.day && date1.month == date2.month && date1.year == date2.year;

// Future getStoragePermission() async {
//   if (await Permission.storage.request().isGranted) {
//     return true;
//   }
//   return false;
// }

Widget getProfilePic(
    {required BuildContext context,
    required String? name,
    required String? avatar,
    required double radius,
    Color? backgroundColor,
    double fontSize = 18,
    FontWeight? fontWeight,
    Color? fontColor,
    required double tS}) {
  return Container(
    width: radius,
    height: radius,
    alignment: Alignment.center,
    decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.2)),
    child: avatar == null || avatar == ''
        ? Text(name != null ? getInitials(name) : '',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: tS * fontSize, fontWeight: fontWeight ?? FontWeight.w600, color: fontColor ?? Theme.of(context).primaryColor))
        : Container(
            width: radius,
            height: radius,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                repeat: ImageRepeat.repeat,
                fit: BoxFit.cover,
                width: 32,
                height: 32,
                imageUrl: avatar,
                placeholder: (_, __) => Image.asset('assets/placeholders/placeholder.png', fit: BoxFit.cover),
              ),
            ),
          ),
  );
}

String getInitials(String inputString) {
  String toReturn = '';
  final List<String> sep = inputString.split(' ');
  for (String s in sep) {
    if (toReturn.length < 2) {
      toReturn += s != '' ? s[0] : '';
    }
  }
  return toReturn;
}

InputBorder get chatFieldBorder =>
    const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.all(Radius.circular(18)));

String convertToTime(num num) {
  String toReturn = '';

  if (num.toString().contains('.')) {
    final split = num.toString().split('.');
    late int hour;
    if (int.parse(split[0]) > 12) {
      hour = int.parse(split[0]) - 12;
    } else {
      hour = int.parse(split[0]);
    }
    toReturn = '${hour.toString().padLeft(2, '0')}:${split[1].padRight(2, '0')}';
    if (int.parse(split[0]) > 12) {
      toReturn += ' PM';
    } else {
      toReturn += ' AM';
    }
  } else {
    if (num > 12) {
      toReturn = '${(num - 12).toString().padLeft(2, '0')}:00';
      toReturn += ' PM';
    } else {
      toReturn = '${num.toString().padLeft(2, '0')}:00';
      toReturn += ' AM';
    }
  }
  return toReturn;
}

num convertDateToNumber(DateTime dateTime) {
  if (dateTime.minute > 0) {
    String minute = '0';
    if (dateTime.minute < 10) {
      minute = '0${dateTime.minute}';
    } else {
      minute = dateTime.minute.toString();
    }
    return double.parse('${dateTime.hour.toString()}.$minute');
  } else {
    return dateTime.hour;
  }
}

DateTime convertNumberToDate(num element) {
  final today = DateTime.now();
  if (element.toString().contains('.')) {
    final split = element.toString().split('.');

    return DateTime(today.year, today.month, today.day, int.parse(split[0]), int.parse(split[1]));
  } else {
    return DateTime(today.year, today.month, today.day, element.toInt());
  }
}

cacheImages(List images) async {
  final Directory cacheDir = await getTemporaryDirectory();

  images.forEach((img) async {
    final String fileName = img.split('/').last;
    final File imageFile = File('${cacheDir.path}/$fileName');

    if (!await imageFile.exists()) {
      final response = await http.get(Uri.parse(img));
      if (response.statusCode == 200) {
        await imageFile.writeAsBytes(response.bodyBytes);
      }
    }
  });
}

Color getColorFromText(String text) {
  switch (text) {
    case 'red':
      return redColor;
    case 'yellow':
      return const Color(0xFFF5C542);
    case 'green':
      return greenColor;

    default:
      return const Color(0xFFF5C542);
  }
}

Color getColorFromRating(double i) {
  if (i >= 0 && i < 4) {
    return redColor;
  }
  if (i >= 4 && i <= 7) {
    return const Color(0xFFF5C542);
  } else {
    return greenColor;
  }
}

// Convert to list
commaSeparatedToList(String input) {
  List<String> skillsList = input
      .split(',') // Split by comma
      .map((item) => item.trim()) // Remove leading/trailing spaces
      .where((item) => item.isNotEmpty) // Filter out empty strings
      .toList();

  print(skillsList);
}
