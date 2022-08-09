import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LogInTextField extends StatelessWidget {
  const LogInTextField({
    Key key,
    @required this.controller,
    this.hintText = '',
    this.textInputType = TextInputType.name,
    this.textAlign = TextAlign.start,
    this.inputFormatter,
    this.maxLength = 100,
    this.onTap,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.textFieldKey,
    this.enabled,
    this.focusNode,
  }) : super(key: key);

  final TextAlign textAlign;
  final String hintText;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatter;
  final int maxLength;
  final TextEditingController controller;
  final VoidCallback onTap;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final ValueChanged<String> onChanged;
  final Key textFieldKey;
  final bool enabled;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 39, right: 41),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF161617),
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.3],
            // tileMode: TileMode.repeated,
          ),
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
          // color: UiConstants.kPrimaryColor,
        ),
        child: TextFormField(
          key: key,
          enabled: enabled,
          controller: controller,
          style: TextStyles.body2.colour(
            Color(0xFFFFFFFF).withOpacity(0.5),
          ),
          focusNode: focusNode,
          maxLength: maxLength,
          cursorColor: Colors.grey,
          textAlign: textAlign,
          keyboardType: textInputType,
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.all(12.0),
            hintText: hintText,
            hintStyle: TextStyles.body2.colour(
              Color(0xFFFFFFFF).withOpacity(0.5),
            ),
            filled: true,
            fillColor: Color(0xff6E6E7E).withOpacity(0.5),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFFFFFF).withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFFFFFF).withOpacity(0.5),
              ),
            ),
          ),
          inputFormatters: inputFormatter ?? [],
          onTap: onTap,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
