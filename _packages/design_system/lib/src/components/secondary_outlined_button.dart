import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondaryOutlinedButton extends StatelessWidget {
  const SecondaryOutlinedButton({
    required this.onPressed,
    required this.label,
    this.minWidth,
    this.disabled = false,
    super.key,
  });

  final VoidCallback onPressed;
  final Widget label;
  final double? minWidth;
  final bool disabled;

  void _onTap() {
    if (disabled) return;
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final size = Size(
      minWidth ?? ScreenUtil().screenWidth - 32.w,
      44.h,
    );

    return OutlinedButton(
      style: ButtonStyle(
        iconColor: MaterialStatePropertyAll(
          disabled ? AppColors.white54 : AppColors.white,
        ),
        minimumSize: MaterialStatePropertyAll(size),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
        side: const MaterialStatePropertyAll(
          BorderSide(color: AppColors.white),
        ),
      ),
      onPressed: _onTap,
      child: DefaultTextStyle(
        style: TextStyleV2.sub2.copyWith(
          color: AppColors.white,
        ),
        child: label,
      ),
    );
  }
}
