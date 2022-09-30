import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/service/notifier_services/connectivity_service.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AppTextFieldLabel extends StatelessWidget {
  final String text;
  final double leftPadding;
  AppTextFieldLabel(this.text, {this.leftPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: SizeConfig.padding6,
        left: leftPadding ?? SizeConfig.padding16,
      ),
      child: Text(
        text,
        style: TextStyles.sourceSans.body3.colour(UiConstants.kTextColor2),
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
    this.onTap,
    //NOTE: Pass [] If inputformatters are not required
    this.inputFormatters,
    this.hintText = '',
    this.autoFocus = false,
    this.obscure = false,
    this.borderRadius,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixText,
    this.prefixTextStyle,
    this.onChanged,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.maxLines = 1,
    this.suffixText,
    this.suffixTextStyle,
    this.scrollPadding,
    this.suffix,
    this.contentPadding,
    this.inputDecoration,
    this.fillColor,
    this.focusNode,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIconConstraints,
    this.margin,
    this.readOnly = false,
    this.autovalidateMode,
    this.onSubmit,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final bool isEnabled;
  final FormFieldValidator<String> validator;
  final String hintText;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final bool autoFocus;
  final bool obscure;
  final BorderRadius borderRadius;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final String prefixText;
  final TextStyle prefixTextStyle;
  final String suffixText;
  final TextStyle suffixTextStyle;
  //executes on every change
  final AutovalidateMode autovalidateMode;
  final int maxLines;
  final Function onChanged;
  final Function onTap;
  final Function onSubmit;
  final TextAlign textAlign;
  final TextStyle textStyle;
  final Widget suffix;
  final EdgeInsets scrollPadding;
  final int maxLength;
  final EdgeInsets contentPadding;
  final InputDecoration inputDecoration;
  final Color fillColor;
  final FocusNode focusNode;
  final TextCapitalization textCapitalization;
  final BoxConstraints suffixIconConstraints;
  final EdgeInsets margin;
  final bool readOnly;

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
      margin: margin ?? EdgeInsets.zero,
      child: TextFormField(
        validator: validator,
        textCapitalization: textCapitalization,
        focusNode: focusNode,
        enabled: isEnabled,
        scrollPadding: EdgeInsets.zero,
        controller: textEditingController,
        cursorColor: UiConstants.kTextColor,
        onFieldSubmitted: onSubmit,
        inputFormatters: inputFormatters ??
            [
              FilteringTextInputFormatter.allow(
                RegExp(r'[a-zA-Z0-9.@]'),
              )
            ],
        style: textStyle ??
            TextStyles.body2.colour(
              isEnabled
                  ? UiConstants.kTextColor
                  : UiConstants.kTextFieldTextColor,
            ),
        textAlign: textAlign,
        maxLines: maxLines,
        minLines: null,
        maxLength: maxLength,
        autofocus: autoFocus,
        keyboardType: keyboardType,
        onChanged: onChanged,
        obscureText: obscure,
        onTap: onTap ?? () {},
        readOnly: readOnly,
        autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
        decoration: inputDecoration ??
            InputDecoration(
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 10),
                child: suffixIcon,
              ),
              prefixText: prefixText,
              prefixStyle: prefixTextStyle,
              suffixText: suffixText,
              suffixStyle: suffixTextStyle,
              suffix: suffix,
              prefixIcon: prefixIcon,
              suffixIconConstraints: suffixIconConstraints ??
                  BoxConstraints(
                    minWidth: 35,
                    minHeight: 35,
                    maxHeight: 35,
                    maxWidth: 35,
                  ),
              fillColor: fillColor ??
                  (isEnabled
                      ? UiConstants.kTextFieldColor
                      : UiConstants.kTextFieldColor.withOpacity(0.7)),
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
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: SizeConfig.border1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: SizeConfig.border1,
                ),
              ),
              errorStyle: TextStyle(
                height: 0.75,
                fontSize: 12,
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
      // height: 40,
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
            style: TextStyles.body3.colour(
              UiConstants.kTextFieldTextColor,
            ),
          ),
          style: TextStyles.body2.colour(
            UiConstants.kTextColor,
          ),
          dropdownColor: isEnabled
              ? UiConstants.kTextFieldColor
              : UiConstants.kTextFieldColor.withOpacity(0.7),
          hint: Text(
            hintText,
            style: TextStyles.body3.colour(
              UiConstants.kTextColor2,
            ),
          ),

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
    this.width,
    this.height,
  }) : super(key: key);
  final String btnText;
  final VoidCallback onPressed;
  final double width, height;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height ?? SizeConfig.screenWidth * 0.1556,
          width: width ?? SizeConfig.screenWidth,
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
          width: (width ?? SizeConfig.screenWidth) - SizeConfig.padding4,
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

class AppPositiveCustomChildBtn extends StatelessWidget {
  const AppPositiveCustomChildBtn({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.width,
  }) : super(key: key);
  final Widget child;
  final VoidCallback onPressed;
  final double width;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: [
          Container(
            height: SizeConfig.screenWidth * 0.1556,
            width: width ?? SizeConfig.screenWidth,
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
            child: Center(
              child: child,
            ),
          ),
          Container(
            height: SizeConfig.padding2,
            width: (width ?? SizeConfig.screenWidth) - SizeConfig.padding4,
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

class ReactivePositiveAppButton extends StatefulWidget {
  const ReactivePositiveAppButton({
    Key key,
    @required this.btnText,
    @required this.onPressed,
    this.width,
  }) : super(key: key);
  final String btnText;
  final Function onPressed;
  final double width;
  @override
  State<ReactivePositiveAppButton> createState() =>
      _ReactivePositiveAppButtonState();
}

class _ReactivePositiveAppButtonState extends State<ReactivePositiveAppButton> {
  bool _isLoading = false;
  get isLoading => this._isLoading;
  set isLoading(value) {
    if (mounted)
      setState(() {
        this._isLoading = value;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityStatus>(
        builder: (ctx, model, child) => Container(
              height: SizeConfig.screenWidth * 0.1556,
              width: widget.width ??
                  SizeConfig.screenWidth - SizeConfig.pageHorizontalMargins * 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  SizeConfig.buttonBorderRadius,
                ),
                gradient: LinearGradient(
                  colors: model == ConnectivityStatus.Offline
                      ? [
                          UiConstants.kTextColor,
                          Colors.grey,
                          Colors.black,
                        ]
                      : [
                          Color.fromARGB(255, 168, 230, 219),
                          Color(0xff12BC9D),
                          Color(0xff249680),
                        ],
                  stops: [0.01, 0.3, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: MaterialButton(
                // padding: EdgeInsets.zero,
                onPressed: model == ConnectivityStatus.Offline
                    ? BaseUtil.showNoInternetAlert
                    : () async {
                        if (isLoading) return;
                        isLoading = true;
                        await widget.onPressed();
                        isLoading = false;
                      },
                child: isLoading
                    ? SpinKitThreeBounce(
                        size: SizeConfig.title5,
                        color: Colors.white,
                      )
                    : Text(
                        widget.btnText.toUpperCase(),
                        style: TextStyles.rajdhaniB.title5,
                      ),
              ),
            ));
  }
}

class AppNegativeBtn extends StatelessWidget {
  const AppNegativeBtn({
    Key key,
    @required this.btnText,
    @required this.onPressed,
    this.width,
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
        validator: validate,
        cursorColor: UiConstants.primaryColor,
        cursorWidth: 1,
        textAlign: TextAlign.center,
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
            color: Colors.grey[400].withOpacity(0.5),
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
