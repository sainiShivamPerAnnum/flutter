import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabSlider<T> extends StatelessWidget {
  const TabSlider({
    required this.tabs,
    required this.labelBuilder,
    required this.onTap,
    this.controller,
    super.key,
  });

  final List<T> tabs;
  final String Function(T) labelBuilder;
  final void Function(T, int index) onTap;
  final TabController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textGray50White),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: TabBar(
        controller: controller,
        splashFactory: NoSplash.splashFactory,
        splashBorderRadius: BorderRadius.circular(32.r),
        labelStyle: TextStyleV2.body1.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
        unselectedLabelStyle: TextStyleV2.body1.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textGray70,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        indicatorPadding: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(32.r),
          color: AppColors.teal6,
        ),
        onTap: (i) => onTap(tabs[i], i),
        tabs: [
          for (var i = 0; i < tabs.length; i++)
            Tab(
              text: labelBuilder(tabs[i]),
              height: 32.h,
            )
        ],
      ),
    );
  }
}
