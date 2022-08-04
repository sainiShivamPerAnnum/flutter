import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class AppTextFieldLabel extends StatelessWidget {
  final String text;
  final double leftPadding;
  AppTextFieldLabel(this.text, {this.leftPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: SizeConfig.padding6,
        top: SizeConfig.padding16,
        left: leftPadding ?? SizeConfig.padding16,
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
    this.inputFormatters,
    this.hintText = '',
    this.autoFocus = false,
    this.borderRadius,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixText,
    this.prefixTextStyle,
    this.onChanged,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.suffixText,
    this.suffixTextStyle,
    this.suffix,
    this.contentPadding,
    this.inputDecoration,
    this.fillColor,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIconConstraints,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final bool isEnabled;
  final FormFieldValidator<String> validator;
  final String hintText;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final bool autoFocus;
  final BorderRadius borderRadius;
  final Widget suffixIcon;
  final String prefixText;
  final TextStyle prefixTextStyle;
  final String suffixText;
  final TextStyle suffixTextStyle;
  final Function onChanged;
  final TextAlign textAlign;
  final TextStyle textStyle;
  final Widget suffix;
  final EdgeInsets contentPadding;
  final InputDecoration inputDecoration;
  final Color fillColor;
  final FocusNode focusNode;
  final TextCapitalization textCapitalization;
  final BoxConstraints suffixIconConstraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        gradient: UiConstants.kTextFieldGradient1,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ??
              BorderRadius.all(
                Radius.circular(SizeConfig.roundness5),
              ),
        ),
      ),
      child: TextFormField(
        validator: validator,
        textCapitalization: textCapitalization,
        focusNode: focusNode,
        enabled: isEnabled,
        controller: textEditingController,
        cursorColor: UiConstants.kTextColor,
        inputFormatters: inputFormatters ?? [],
        style: textStyle ??
            TextStyles.body2.colour(
              isEnabled
                  ? UiConstants.kTextColor
                  : UiConstants.kTextFieldTextColor,
            ),
        textAlign: textAlign,
        maxLines: null,
        minLines: null,
        autofocus: autoFocus,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixText: prefixText,
          prefixStyle: prefixTextStyle,
          suffixText: suffixText,
          suffixStyle: suffixTextStyle,
          suffix: suffix,
          suffixIconConstraints: suffixIconConstraints ??
              BoxConstraints(
                minWidth: 35,
                minHeight: 35,
                maxHeight: 35,
                maxWidth: 35,
              ),
          errorStyle: TextStyle(
            height: 0.75,
            fontSize: 12,
          ),
          fillColor: UiConstants.kTextFieldColor,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyles.body3.colour(UiConstants.kTextColor2),
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(
                horizontal: SizeConfig.padding16,
                vertical: SizeConfig.padding2,
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
        gradient: UiConstants.kTextFieldGradient2,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding16,
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
          horizontal: SizeConfig.padding16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
          border: Border.all(
            color: UiConstants.kTextColor.withOpacity(0.1),
            width: SizeConfig.border1,
          ),
          gradient: UiConstants.kTextFieldGradient2,
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
    @required this.width,
  }) : super(key: key);
  final String btnText;
  final VoidCallback onPressed;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: SizeConfig.screenWidth * 0.1556,
          width: width,
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
            // padding: EdgeInsets.zero,
            onPressed: onPressed,
            child: Text(
              btnText.toUpperCase(),
              style: TextStyles.rajdhaniB.title5,
            ),
          ),
        ),
        Container(
          height: SizeConfig.padding2,
          width: width - SizeConfig.padding4,
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
    );
  }
}

class AppNegativeBtn extends StatelessWidget {
  const AppNegativeBtn({
    Key key,
    @required this.btnText,
    @required this.onPressed,
    @required this.width,
  }) : super(key: key);
  final String btnText;
  final VoidCallback onPressed;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenWidth * 0.1556,
      width: width,
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
    );
  }
}

class AppDateField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final maxlength;
  final double fieldWidth;
  final Function validate;

  AppDateField(
      {this.controller,
      this.labelText,
      this.maxlength,
      this.fieldWidth,
      this.validate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fieldWidth,
      child: TextFormField(
        controller: controller,
        maxLength: maxlength,
        cursorColor: UiConstants.primaryColor,
        cursorWidth: 1,
        onChanged: (val) {
          if (val.length == maxlength && maxlength == 2) {
            FocusScope.of(context).nextFocus();
          } else if (val.length == maxlength && maxlength == 4) {
            FocusScope.of(context).unfocus();
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.datetime,
        style: TextStyles.sourceSans.body2,
        decoration: InputDecoration(
          counterText: "",
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          hintText: labelText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class AppSwitch extends StatelessWidget {
  const AppSwitch({
    Key key,
    @required this.onToggle,
    @required this.value,
    this.isLoading = false,
    this.height = 22,
    this.width = 32,
    this.toggleSize = 12.0,
    this.activeColor = UiConstants.kSwitchColor,
    this.inactiveColor = UiConstants.kSwitchColor,
    this.activeToggleColor = UiConstants.kTabBorderColor,
    this.inactiveToggleColor = Colors.white,
  }) : super(key: key);

  final ValueChanged<bool> onToggle;
  final bool value;
  final bool isLoading;
  final double width, height;
  final double toggleSize;
  final Color activeColor,
      inactiveColor,
      activeToggleColor,
      inactiveToggleColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onToggle(!value);
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            SizeConfig.padding24,
          ),
          color: value ? activeColor : inactiveColor,
          border: Border.all(
            color: UiConstants.kSecondaryBackgroundColor,
            width: SizeConfig.border4,
          ),
        ),
        child: AnimatedAlign(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          duration: Duration(milliseconds: 300),
          child: isLoading
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding2,
                  ),
                  child: SizedBox(
                    width: toggleSize,
                    height: toggleSize,
                    child: CircularProgressIndicator(
                      strokeWidth: SizeConfig.border3,
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(
                    left: SizeConfig.padding2,
                    right: SizeConfig.padding2,
                  ),
                  width: toggleSize,
                  height: toggleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: value ? activeToggleColor : inactiveToggleColor,
                  ),
                ),
        ),
      ),
    );
  }
}
