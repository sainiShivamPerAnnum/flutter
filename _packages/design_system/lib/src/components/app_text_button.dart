import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    required this.onPressed,
    required this.label,
    super.key,
    this.disabled = false,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final Widget label;
  final bool disabled;
  final bool isLoading;

  void _onPressed() {
    if (disabled) return;
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? .5 : 1,
      child: TextButton(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: const MaterialStatePropertyAll(AppColors.white),
          textStyle: MaterialStatePropertyAll(
            GoogleFonts.rajdhani(
              fontWeight: FontWeight.w700,
              color: AppColors.white,
              fontSize: 16.sp,
            ),
          ),
        ),
        onPressed: _onPressed,
        child: isLoading
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : label,
      ),
    );
  }
}
