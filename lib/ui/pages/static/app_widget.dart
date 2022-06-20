import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFieldLabel extends StatelessWidget {
  final String text;
  AppTextFieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: SizeConfig.padding6,
        top: SizeConfig.padding16,
        left: SizeConfig.padding16,
      ),
      child: Text(
        text,
        style: TextStyles.body3.colour(UiConstants.kTextColor2),
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  AppTextField({
    Key key,
    @required this.textEditingController,
    @required this.isEnabled,
    @required this.validator,
    //NOTE: Pass [] If inputformatters are not required
    @required this.inputFormatters,
    this.hintText = '',
  }) : super(key: key);

  final TextEditingController textEditingController;
  final bool isEnabled;
  final FormFieldValidator<String> validator;
  final String hintText;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenWidth * 0.1377,
      child: TextFormField(
        validator: validator,
        enabled: isEnabled,
        controller: textEditingController,
        cursorColor: UiConstants.kTextColor,
        inputFormatters: inputFormatters,
        style: TextStyles.body2.colour(
          isEnabled ? UiConstants.kTextColor : UiConstants.kTextFieldTextColor,
        ),
        expands: true,
        maxLines: null,
        minLines: null,
        decoration: InputDecoration(
          fillColor: isEnabled
              ? UiConstants.kTextFieldColor
              : UiConstants.kTextFieldColor.withOpacity(0.7),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SizeConfig.roundness5),
            borderSide: BorderSide(
              color: UiConstants.kTextColor.withOpacity(0.1),
              width: SizeConfig.border1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SizeConfig.roundness5),
            borderSide: BorderSide(
              color: UiConstants.kTextColor.withOpacity(0.1),
              width: SizeConfig.border1,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SizeConfig.roundness5),
            borderSide: BorderSide(
              color: UiConstants.kTextColor.withOpacity(0.1),
              width: SizeConfig.border1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SizeConfig.roundness5),
            borderSide: BorderSide(
              color: UiConstants.kTabBorderColor,
              width: SizeConfig.border1,
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyles.body3.colour(UiConstants.kTextColor2),
          contentPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding12,
          ),
        ),
      ),
    );
  }
}

class AppDropDownField extends StatelessWidget {
  const AppDropDownField({
    Key key,
    @required this.onChanged,
    @required this.value,
    @required this.disabledHintText,
    @required this.hintText,
    @required this.items,
    @required this.isEnabled,
  }) : super(key: key);

  final ValueChanged<dynamic> onChanged;
  final dynamic value;
  final String disabledHintText, hintText;
  final List<DropdownMenuItem<dynamic>> items;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConfig.screenWidth * 0.1377,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness5),
        border: Border.all(
          color: UiConstants.kTextColor.withOpacity(0.1),
          width: SizeConfig.border1,
        ),
        color: isEnabled
            ? UiConstants.kTextFieldColor
            : UiConstants.kTextFieldColor.withOpacity(0.7),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding12,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          // itemHeight: 40,
          iconSize: 0,
          onChanged: onChanged,
          value: value,
          disabledHint: Text(
            disabledHintText,
            style: TextStyles.body2.colour(
              UiConstants.kTextFieldTextColor,
            ),
          ),
          style: TextStyles.body2.colour(
            UiConstants.kTextColor,
          ),
          dropdownColor: isEnabled
              ? UiConstants.kTextFieldColor
              : UiConstants.kTextFieldColor.withOpacity(0.7),
          hint: Text(hintText),
          items: items,
        ),
      ),
    );
  }
}

class AppDatePickerField extends StatelessWidget {
  const AppDatePickerField({
    Key key,
    @required this.child,
    @required this.onTap,
    @required this.isEnabled,
  }) : super(key: key);
  final GestureTapCallback onTap;
  final Widget child;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.screenWidth * 0.1377,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
          border: Border.all(
            color: UiConstants.kTextColor.withOpacity(0.1),
            width: SizeConfig.border1,
          ),
          color: isEnabled
              ? UiConstants.kTextFieldColor
              : UiConstants.kTextFieldColor.withOpacity(0.7),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: child,
        ),
      ),
    );
  }
}

class AppPositiveBtn extends StatelessWidget {
  const AppPositiveBtn({
    Key key,
    @required this.btnText,
    @required this.onPressed,
  }) : super(key: key);
  final String btnText;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Container(
            height: SizeConfig.screenWidth * 0.1556,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                SizeConfig.buttonBorderRadius,
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xff12BC9D),
                  Color(0xff249680),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: MaterialButton(
              onPressed: onPressed,
              child: Text(
                btnText.toUpperCase(),
                style: TextStyles.rajdhaniB.title5,
              ),
            ),
          ),
          Container(
            height: SizeConfig.padding2,
            margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding2,
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: UiConstants.kTextColor,
                  offset: Offset(0, SizeConfig.padding2),
                  blurRadius: SizeConfig.padding4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppNegativeBtn extends StatelessWidget {
  const AppNegativeBtn({
    Key key,
    @required this.btnText,
    @required this.onPressed,
  }) : super(key: key);
  final String btnText;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: SizeConfig.screenWidth * 0.1556,
        child: OutlinedButton(
          onPressed: onPressed,
          child: Text(
            btnText,
            style: TextStyles.rajdhaniSB.body1,
          ),
          style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: MaterialStateProperty.all<BorderSide>(
              BorderSide(
                color: UiConstants.kTextColor,
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
