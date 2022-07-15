import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class FelloTextField extends StatelessWidget {
  const FelloTextField({
    Key key,
    this.hintText = '',
    this.textInputType = TextInputType.name,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  final TextAlign textAlign;
  final String hintText;
  final TextInputType textInputType;

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
        child: TextField(
          style: TextStyles.body2.colour(
            Color(0xFFFFFFFF).withOpacity(0.5),
          ),
          cursorColor: Colors.grey,
          textAlign: textAlign,
          keyboardType: textInputType,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12.0),
            hintText: hintText,
            hintStyle:
                TextStyles.body2.colour(Color(0xFFFFFFFF).withOpacity(0.5)),
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
        ),
      ),
    );
  }
}
