import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/model/sdui/sections/home_page_sections.dart';
import 'package:felloapp/core/service/notifier_services/connectivity_service.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/action_resolver.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class AppTextFieldLabel extends StatelessWidget {
  final String text;
  final double? leftPadding;

  const AppTextFieldLabel(this.text, {Key? key, this.leftPadding})
      : super(key: key);

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
  const AppTextField({
    required this.textEditingController,
    this.isEnabled = true,
    this.validator,
    super.key,
    this.onTap,
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
    this.hintStyle,
    this.cursorWidth = 2.0,
    this.focusedBorderColor,
  });

  final TextEditingController? textEditingController;
  final bool isEnabled;
  final FormFieldValidator<String>? validator;
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final bool autoFocus;
  final bool obscure;
  final BorderRadius? borderRadius;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? prefixText;
  final TextStyle? prefixTextStyle;
  final String? suffixText;
  final TextStyle? suffixTextStyle;

  //executes on every change
  final AutovalidateMode? autovalidateMode;
  final int maxLines;
  final Function? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmit;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final Widget? suffix;
  final EdgeInsets? scrollPadding;
  final int? maxLength;
  final EdgeInsets? contentPadding;
  final InputDecoration? inputDecoration;
  final Color? fillColor;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final BoxConstraints? suffixIconConstraints;
  final EdgeInsets? margin;
  final bool readOnly;
  final TextStyle? hintStyle;
  final double cursorWidth;
  final Color? focusedBorderColor;

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
        cursorWidth: cursorWidth,
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
                RegExp(r'[a-zA-Z0-9.@%]'),
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
        onChanged: onChanged as void Function(String)?,
        obscureText: obscure,
        onTap: onTap,
        readOnly: readOnly,
        autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
        decoration: inputDecoration ??
            InputDecoration(
                counterStyle: const TextStyle(color: UiConstants.kTextColor),
                suffixIcon: suffixIcon != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: suffixIcon,
                      )
                    : null,
                prefixText: prefixText,
                prefixStyle: prefixTextStyle,
                suffixText: suffixText,
                suffixStyle: suffixTextStyle,
                suffix: suffix,
                prefixIcon: prefixIcon,
                suffixIconConstraints: suffixIconConstraints ??
                    const BoxConstraints(
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
                errorStyle: const TextStyle(
                  height: 0.75,
                  fontSize: 12,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                  borderSide: BorderSide(
                    color: focusedBorderColor ?? UiConstants.kTabBorderColor,
                    width: SizeConfig.border1,
                  ),
                ),
                hintText: hintText,
                hintStyle: hintStyle ??
                    TextStyles.body3.colour(UiConstants.kTextColor2),
                contentPadding: contentPadding ??
                    EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding16,
                      vertical: SizeConfig.padding2,
                    ),
                counterText: ""),
      ),
    );
  }
}

class AppDropDownField<T> extends StatelessWidget {
  const AppDropDownField({
    required this.onChanged,
    required this.value,
    required this.disabledHintText,
    required this.hintText,
    required this.items,
    required this.isEnabled,
    super.key,
  });

  final ValueChanged<T?> onChanged;
  final T value;
  final String disabledHintText, hintText;
  final List<DropdownMenuItem<T>> items;
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
        child: DropdownButton<T>(
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
    required this.child,
    required this.onTap,
    required this.isEnabled,
    Key? key,
  }) : super(key: key);
  final GestureTapCallback onTap;
  final Widget child;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.screenWidth! * 0.1377,
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
  const AppPositiveBtn(
      {required this.onPressed,
      this.btnText,
      Key? key,
      this.style,
      this.width,
      this.height,
      this.child})
      : super(key: key);
  final String? btnText;
  final VoidCallback onPressed;
  final double? width, height;
  final Widget? child;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height ?? SizeConfig.screenWidth! * 0.1556,
          width: width ?? SizeConfig.screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              SizeConfig.buttonBorderRadius,
            ),
            gradient: const LinearGradient(
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
            child: child ??
                Text(
                  btnText!.toUpperCase(),
                  style: TextStyles.rajdhaniB.title5.merge(style),
                ),
          ),
        ),
      ],
    );
  }
}

class AppPositiveCustomChildBtn extends StatelessWidget {
  const AppPositiveCustomChildBtn({
    required this.child,
    required this.onPressed,
    Key? key,
    this.width,
  }) : super(key: key);
  final Widget child;
  final VoidCallback onPressed;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: [
          Container(
            height: SizeConfig.screenWidth! * 0.1556,
            width: width ?? SizeConfig.screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                SizeConfig.buttonBorderRadius,
              ),
              gradient: const LinearGradient(
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
            width: (width ?? SizeConfig.screenWidth)! - SizeConfig.padding4,
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

class ReactivePositiveAppButton extends HookWidget {
  const ReactivePositiveAppButton({
    required this.onPressed,
    this.btnText = '',
    super.key,
    this.isDisabled = false,
    this.width,
    this.child,
  });
  final String btnText;
  final Function onPressed;
  final double? width;
  final bool isDisabled;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final content = child ??
        Text(
          btnText.toUpperCase(),
          style: TextStyles.rajdhaniB.title5
              .colour(Colors.white.withOpacity(isDisabled ? 0.8 : 1)),
        );

    return Consumer<ConnectivityService>(
        builder: (ctx, model, child) => Container(
              height: SizeConfig.screenWidth! * 0.1556,
              width: width ??
                  SizeConfig.screenWidth! -
                      SizeConfig.pageHorizontalMargins * 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  SizeConfig.buttonBorderRadius,
                ),
                gradient: LinearGradient(
                  colors: model.connectivityStatus == ConnectivityStatus.Offline
                      ? [
                          UiConstants.kTextColor,
                          Colors.grey,
                          Colors.black,
                        ]
                      : [
                          const Color.fromARGB(255, 168, 230, 219)
                              .withOpacity(isDisabled ? 0.8 : 1),
                          const Color(0xff12BC9D)
                              .withOpacity(isDisabled ? 0.8 : 1),
                          const Color(0xff249680)
                              .withOpacity(isDisabled ? 0.8 : 1),
                        ],
                  stops: const [0.01, 0.3, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: MaterialButton(
                // padding: EdgeInsets.zero,
                onPressed:
                    model.connectivityStatus == ConnectivityStatus.Offline
                        ? BaseUtil.showNoInternetAlert
                        : () async {
                            if (isLoading.value) return;
                            isLoading.value = true;
                            await onPressed();
                            isLoading.value = false;
                          },
                child: isLoading.value
                    ? SpinKitThreeBounce(
                        size: SizeConfig.title5,
                        color: Colors.white,
                      )
                    : content,
              ),
            ));
  }
}

class AppNegativeBtn extends StatelessWidget {
  const AppNegativeBtn({
    required this.btnText,
    this.onPressed,
    Key? key,
    this.width,
  }) : super(key: key);
  final String btnText;
  final VoidCallback? onPressed;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenWidth! * 0.1556,
      width: width,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: MaterialStateProperty.all<BorderSide>(
            const BorderSide(
              color: UiConstants.kTextColor,
              width: 1,
            ),
          ),
        ),
        child: Text(
          btnText.toUpperCase(),
          style: TextStyles.rajdhaniSB.body1,
        ),
      ),
    );
  }
}

class AppDateField extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final maxlength;
  final double? fieldWidth;
  final FormFieldValidator<String> validate;

  const AppDateField(
      {required this.validate,
      Key? key,
      this.controller,
      this.labelText,
      this.maxlength,
      this.fieldWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          border: const UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          hintText: labelText,
          hintStyle: TextStyle(
            color: Colors.grey[400]!.withOpacity(0.5),
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class AppSwitch extends StatelessWidget {
  const AppSwitch({
    required this.onToggle,
    required this.value,
    Key? key,
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
          duration: const Duration(milliseconds: 300),
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

class CustomKeyboardSubmitButton extends StatelessWidget {
  final Function? onSubmit;

  const CustomKeyboardSubmitButton({Key? key, this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      child: MediaQuery.of(context).viewInsets.bottom >
              SizeConfig.viewInsets.bottom
          ? Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.padding54,
              color: UiConstants.kArrowButtonBackgroundColor,
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins,
              ),
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: onSubmit as void Function()?,
                child: Text(
                  'DONE',
                  style: TextStyles.rajdhaniB.body1
                      .colour(UiConstants.primaryColor),
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}

/// Type of app image.
enum _ImageType {
  normal,
  svg,
  lottie;
}

/// A possible source of image.
enum _ImageSourceType {
  network,
  local;
}

class AppImage extends StatelessWidget {
  final String image;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final Color? color;

  const AppImage(
    this.image, {
    super.key,
    this.fit,
    this.height,
    this.width,
    this.color,
  });

  _ImageType get _getImageType {
    _ImageType appImageType = _ImageType.normal;
    if (image.endsWith('.svg')) appImageType = _ImageType.svg;
    if (image.endsWith('.json')) appImageType = _ImageType.lottie;
    return appImageType;
  }

  _ImageSourceType get _sourceType {
    _ImageSourceType imageSourceType = _ImageSourceType.local;
    if (image.startsWith('http')) imageSourceType = _ImageSourceType.network;
    return imageSourceType;
  }

  @override
  Widget build(BuildContext context) {
    final imageType = _getImageType;

    // to avoid re-computation in switch expression.
    final sourceType = _sourceType;

    switch (imageType) {
      case _ImageType.normal:
        switch (sourceType) {
          case _ImageSourceType.local:
            return Image.asset(
              image,
              fit: fit,
              height: height,
              width: width,
              color: color,
            );

          case _ImageSourceType.network:
            return Image.network(
              image,
              fit: fit,
              height: height,
              width: width,
              color: color,
            );
        }

      case _ImageType.svg:
        switch (sourceType) {
          case _ImageSourceType.local:
            return SvgPicture.asset(
              image,
              fit: fit ?? BoxFit.contain,
              height: height,
              width: width,
              color: color,
            );

          case _ImageSourceType.network:
            return SvgPicture.network(
              image,
              fit: fit ?? BoxFit.contain,
              height: height,
              width: width,
              color: color,
            );
        }

      case _ImageType.lottie:
        switch (sourceType) {
          case _ImageSourceType.local:
            return LottieBuilder.asset(
              image,
              fit: fit ?? BoxFit.contain,
              height: height,
              width: width,
            );

          case _ImageSourceType.network:
            return LottieBuilder.network(
              image,
              fit: fit ?? BoxFit.contain,
              height: height,
              width: width,
            );
        }
    }
  }
}

enum InitialExpandableState {
  collapsed,
  expanded;
}

class Expandable extends StatefulWidget {
  final Widget header;
  final Widget? body;
  final InitialExpandableState initialState;

  const Expandable({
    required this.header,
    this.body,
    this.initialState = InitialExpandableState.collapsed,
    super.key,
  });

  @override
  State<Expandable> createState() => _ExpandableState();
}

class _ExpandableState extends State<Expandable> {
  final _key = Object();
  final _duration = const Duration(
    milliseconds: 300,
  );

  bool _collapsed = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialState == InitialExpandableState.expanded) {
      _collapsed = false;
    }
  }

  void _onToggle() {
    setState(() {
      _collapsed = !_collapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          key: ObjectKey(_key),
          children: [
            Expanded(
              child: widget.header,
            ),
            if (widget.body != null)
              Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.padding8,
                ),
                child: InkWell(
                  onTap: _onToggle,
                  child: AnimatedRotation(
                    turns: _collapsed ? 0 : .5,
                    duration: _duration,
                    child: SvgPicture.asset(
                      Assets.arrow,
                      color: Colors.white,
                      height: SizeConfig.padding12,
                      width: SizeConfig.padding12,
                    ),
                  ),
                ),
              )
          ],
        ),
        if (widget.body != null)
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.padding18),
            child: ClipRRect(
              child: AnimatedAlign(
                alignment: Alignment.topCenter,
                heightFactor: _collapsed ? 0 : 1,
                duration: _duration,
                child: widget.body,
              ),
            ),
          )
      ],
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.onPressed,
    required this.label,
    this.disabled = false,
    super.key,
  });

  final VoidCallback onPressed;
  final String label;
  final bool disabled;

  void _onTap() {
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: SizeConfig.padding44,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.roundness5),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minWidth: SizeConfig.screenWidth! - SizeConfig.pageHorizontalMargins * 2,
      color: disabled ? Colors.white54 : Colors.white,
      onPressed: _onTap,
      child: Text(
        label,
        style: TextStyles.rajdhaniB.body1.colour(
          Colors.black,
        ),
      ),
    );
  }
}

class SecondaryOutlinedButton extends StatelessWidget {
  const SecondaryOutlinedButton({
    required this.onPressed,
    required this.label,
    this.disabled = false,
    super.key,
  });

  final VoidCallback onPressed;
  final String label;
  final bool disabled;

  void _onTap() {
    if (disabled) return;
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final size = Size(
      SizeConfig.screenWidth! - SizeConfig.pageHorizontalMargins * 2,
      SizeConfig.padding44,
    );

    return OutlinedButton(
      style: ButtonStyle(
        iconColor: MaterialStatePropertyAll(
          disabled ? Colors.white54 : Colors.white,
        ),
        minimumSize: MaterialStatePropertyAll(size),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConfig.roundness5),
          ),
        ),
        side: const MaterialStatePropertyAll(
          BorderSide(color: Colors.white),
        ),
      ),
      onPressed: _onTap,
      child: Text(
        label,
        style: TextStyles.rajdhaniB.body1.colour(
          Colors.white,
        ),
      ),
    );
  }
}

class DSLButtonResolver extends StatelessWidget {
  const DSLButtonResolver({
    required this.cta,
    super.key,
    this.preResolve,
    this.postResolve,
  });

  final Cta cta;
  final FutureOr<void> Function()? preResolve;
  final FutureOr<void> Function()? postResolve;

  FutureOr<void> _onPressed() async {
    await preResolve?.call();
    final action = cta.action;
    if (action == null) return;
    await ActionResolver.instance.resolve(action);
    await postResolve?.call();
  }

  @override
  Widget build(BuildContext context) {
    return switch (cta.style) {
      CTAType.secondary => SecondaryButton(
          onPressed: _onPressed,
          label: cta.label,
        ),
      CTAType.secondaryOutline => SecondaryOutlinedButton(
          onPressed: _onPressed,
          label: cta.label,
        ),
    };
  }
}

class GradientBoxBorder extends BoxBorder {
  const GradientBoxBorder({required this.gradient, this.width = 1.0});

  final Gradient gradient;

  final double width;

  @override
  BorderSide get bottom => BorderSide.none;

  @override
  BorderSide get top => BorderSide.none;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  bool get isUniform => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    switch (shape) {
      case BoxShape.circle:
        assert(
          borderRadius == null,
          'A borderRadius can only be given for rectangular boxes.',
        );
        _paintCircle(canvas, rect);
        break;
      case BoxShape.rectangle:
        if (borderRadius != null) {
          _paintRRect(canvas, rect, borderRadius);
          return;
        }
        _paintRect(canvas, rect);
        break;
    }
  }

  void _paintRect(Canvas canvas, Rect rect) {
    canvas.drawRect(rect.deflate(width / 2), _getPaint(rect));
  }

  void _paintRRect(Canvas canvas, Rect rect, BorderRadius borderRadius) {
    final rrect = borderRadius.toRRect(rect).deflate(width / 2);
    canvas.drawRRect(rrect, _getPaint(rect));
  }

  void _paintCircle(Canvas canvas, Rect rect) {
    final paint = _getPaint(rect);
    final radius = (rect.shortestSide - width) / 2.0;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return this;
  }

  Paint _getPaint(Rect rect) {
    return Paint()
      ..strokeWidth = width
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke;
  }
}

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.showBackgroundGrid = true,
    this.restorationId,
  });

  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final DrawerCallback? onDrawerChanged;
  final Widget? endDrawer;
  final DrawerCallback? onEndDrawerChanged;
  final Color? drawerScrimColor;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;
  final bool showBackgroundGrid;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Stack(
        children: [
          // Background of scaffold with grid pattern.
          if (showBackgroundGrid) const NewSquareBackground(),

          // For scaffold configuration.
          Scaffold(
            extendBody: extendBody,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            appBar: appBar,
            body: body,
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
            floatingActionButtonAnimator: floatingActionButtonAnimator,
            persistentFooterButtons: persistentFooterButtons,
            drawer: drawer,
            onDrawerChanged: onDrawerChanged,
            endDrawer: endDrawer,
            onEndDrawerChanged: onEndDrawerChanged,
            drawerScrimColor: drawerScrimColor,
            backgroundColor: backgroundColor ?? Colors.transparent,
            bottomNavigationBar: bottomNavigationBar,
            bottomSheet: bottomSheet,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            primary: primary,
            drawerDragStartBehavior: drawerDragStartBehavior,
            drawerEdgeDragWidth: drawerEdgeDragWidth,
            drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
            restorationId: restorationId,
          ),
        ],
      ),
    );
  }
}
