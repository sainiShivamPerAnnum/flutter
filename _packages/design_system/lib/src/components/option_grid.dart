import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionsGrid extends StatelessWidget {
  const OptionsGrid({
    required this.itemBuilder,
    required this.itemCount,
    this.runItemCount = 4,
    super.key,
  });

  final int runItemCount;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 20.0;
        final maxWidth = constraints.biggest.width;
        final containerWidth =
            (maxWidth - ((runItemCount - 1) * spacing)) / runItemCount;
        return Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (int i = 0; i < itemCount; i++)
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  width: containerWidth,
                ),
                child: itemBuilder(context, i),
              )
          ],
        );
      },
    );
  }
}

class DefaultChip extends StatelessWidget {
  const DefaultChip({
    required this.label,
    super.key,
    this.isBest = false,
    this.isSelected = false,
  });

  final String label;
  final bool isBest;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isBest)
          Container(
            decoration: BoxDecoration(
              color: AppColors.teal3,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(2.r),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
            ),
            child: Text(
              'Best',
              style: GoogleFonts.sourceSansPro(
                fontWeight: FontWeight.w700,
                fontSize: 10.sp,
                height: 1.4,
                color: AppColors.grey3,
              ),
            ),
          ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 6.h,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(
              width: .5,
              color: isSelected
                  ? AppColors.teal3
                  : AppColors.yellow1.withOpacity(.2),
            ),
          ),
          child: AppText.caption2(
            label,
            color: isSelected ? AppColors.teal3 : AppColors.white,
          ),
        ),
      ],
    );
  }
}
