// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../commonWidgets/custom_button.dart';
import '../../common_functions.dart';
import '../../navigation/navigators.dart';
import '../auth_module/providers/auth_provider.dart';
import 'custom_text_field.dart';
import 'gradient_button.dart';

class TextFieldBottomSheet extends StatefulWidget {
  final String title;
  final String value;
  final List<FilteringTextInputFormatter> inputFilter;
  final TextInputType? inputType;
  final int? maxLength;
  final Function? validator;
  final Function addSkill;
  final BuildContext? pContext;

  const TextFieldBottomSheet({
    required this.title,
    required this.value,
    required this.inputFilter,
    this.inputType,
    this.maxLength,
    this.validator,
    required this.addSkill,
    this.pContext,
    Key? key,
  }) : super(key: key);

  @override
  State<TextFieldBottomSheet> createState() => _TextFieldBottomSheetState();
}

class _TextFieldBottomSheetState extends State<TextFieldBottomSheet> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  Map language = {};

  final GlobalKey<FormState> _formKey = GlobalKey();
  late TextEditingController _tController;
  late FocusNode _tFocusNode;

  add() {
    widget.addSkill(_tController.text.trim());
    _tController.clear();
    pop();

    // ScaffoldMessenger.of(widget.pContext ?? bContext).showSnackBar(SnackBar(
    //   content: Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 3),
    //     child: Text(
    //       'Skill Added',
    //       softWrap: true,
    //       style: Theme.of(widget.pContext ?? bContext).textTheme.bodyLarge!.copyWith(fontSize: tS * 14.5, color: Colors.white),
    //     ),
    //   ),
    //   backgroundColor: greenColor,
    //   behavior: SnackBarBehavior.floating,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    //   duration: Duration(seconds: 2),
    //   dismissDirection: DismissDirection.down,
    //   margin: EdgeInsets.only(
    //     bottom: MediaQuery.of(widget.pContext ?? bContext).size.height * 0.9,
    //     // bottom: 40,
    //     right: 20,
    //     left: 20,
    //   ),
    // ));
  }

  @override
  void initState() {
    super.initState();

    _tController = TextEditingController(text: widget.value);
    _tFocusNode = FocusNode();

    _tFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Container(
      width: dW,
      // height: height,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      margin: EdgeInsets.symmetric(vertical: dW * 0.05),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(left: dW * 0.05, right: dW * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title.replaceAll('\n', ' '),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: tS * 18,
                        color: const Color(0xFF3E3E3E),
                      ),
                ),
                GestureDetector(
                  onTap: pop,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: themeBlue),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      child: Text(
                        'Done',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: tS * 12,
                              color: themeBlue,
                            ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(
                horizontal: dW * horizontalPaddingFactor,
                vertical: dW * 0.07,
              ),
              child: Form(
                key: _formKey,
                child: CustomTextFieldWithLabel(
                  controller: _tController,
                  focusNode: _tFocusNode,
                  maxLength: widget.maxLength,
                  suffixIconConstraints: const BoxConstraints(minWidth: 24),
                  textCapitalization: TextCapitalization.words,
                  inputFormatter: widget.inputFilter,
                  inputType: TextInputType.text,
                  hintFS: tS * 16,
                  labelColor: const Color(0xFF3E3E3E),
                  labelFS: 14,
                  borderColor: dividerColor,
                  optional: true,
                  label: 'Enter ${widget.title.toLowerCase().replaceAll('\n', ' ').replaceAll('add ', '')}',
                  hintText: '',
                  validator: widget.validator,
                ),
              )),
          // const Spacer(),
          Container(
            padding: screenHorizontalPadding(dW),
            height: dW * 0.14,
            child: GradientButton(
              buttonText: 'Add',
              onPressed: widget.validator != null
                  ? () {
                      if (_formKey.currentState!.validate()) {
                        add();
                      }
                    }
                  : () {
                      add();
                    },
              // width: dW - (dW * horizontalPaddingFactor * 2),
            ),
          ),
          SizedBox(height: dW * 0.03),
        ],
      ),
    );
  }
}
