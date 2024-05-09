import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

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
        border: Border.all(color: UiConstants.textGray50),
        borderRadius: BorderRadius.circular(SizeConfig.padding100),
      ),
      child: TabBar(
        controller: controller,
        splashFactory: NoSplash.splashFactory,
        splashBorderRadius: BorderRadius.circular(SizeConfig.padding32),
        labelStyle: TextStyles.sourceSansSB.body3.copyWith(
          fontWeight: FontWeight.w700,
          color: UiConstants.kTextColor,
        ),
        unselectedLabelStyle: TextStyles.sourceSansSB.body3.copyWith(
          fontWeight: FontWeight.w700,
          color: UiConstants.textGray70,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        indicatorPadding: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.padding32),
          color: UiConstants.teal6,
        ),
        onTap: (i) => onTap(tabs[i], i),
        tabs: [
          for (var i = 0; i < tabs.length; i++)
            Tab(
              text: labelBuilder(tabs[i]),
              height: SizeConfig.padding32,
            )
        ],
      ),
    );
  }
}
