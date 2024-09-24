import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Tag extends StatelessWidget {
  const Tag({required this.status, super.key});
  final TagStatus status;

  Color get _getColor {
    return switch (status) {
      _Positive() => AppColors.teal3,
      _Warning() => AppColors.yellow3,
      _Negative() => AppColors.peach3,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: color.withOpacity(.20),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 3.h,
      ),
      child: Text(
        status.label,
        style: GoogleFonts.rajdhani(
          fontWeight: FontWeight.w500,
          color: color,
          height: 1.3,
        ),
      ),
    );
  }
}

sealed class TagStatus {
  const TagStatus(this.label);
  final String label;

  const factory TagStatus.positive(final String label) = _Positive;
  const factory TagStatus.warning(final String label) = _Warning;
  const factory TagStatus.negative(final String label) = _Negative;
}

class _Positive extends TagStatus {
  const _Positive(super.label);
}

class _Warning extends TagStatus {
  const _Warning(super.label);
}

class _Negative extends TagStatus {
  const _Negative(super.label);
}
