import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.enabled,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.inputFormatters,
    this.validator,
    this.maxLength,
    this.errorMessage,
  });

  final TextEditingController? controller;
  final int? maxLength;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final String? hintText;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: const BorderSide(
        color: AppColors.teal3,
      ),
    );

    final errorBorder = border.copyWith(
      borderSide: const BorderSide(
        color: AppColors.peach3,
      ),
    );

    final inputStyle = GoogleFonts.sourceSansPro(
      color: AppColors.textGray70,
      fontWeight: FontWeight.w600,
      height: 1.2,
    );

    return Column(
      children: [
        TextFormField(
          controller: controller,
          maxLength: maxLength,
          onChanged: onChanged,
          keyboardType: keyboardType,
          enabled: enabled,
          inputFormatters: inputFormatters,
          validator: validator,
          style: inputStyle,
          textCapitalization: textCapitalization,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: border,
            focusedBorder: border,
            enabledBorder: border,
            disabledBorder: border,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.h,
              horizontal: 12.w,
            ),
            hintStyle: inputStyle.copyWith(
              color: AppColors.textGray70.withOpacity(.6),
            ),
            hintText: hintText,
          ),
        ),
        if (errorMessage != null)
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12.h,
            ),
            child: AppText.body2(
              errorMessage!,
              color: AppColors.peach3,
            ),
          ),
      ],
    );
  }
}
