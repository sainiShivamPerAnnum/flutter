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
      padding: EdgeInsets.all(SizeConfig.padding3),
      decoration: BoxDecoration(
        border: Border.all(color: UiConstants.kDividerColor),
        borderRadius: BorderRadius.circular(100),
      ),
      child: TabBar(
        controller: controller,
        splashFactory: NoSplash.splashFactory,
        splashBorderRadius: BorderRadius.circular(SizeConfig.roundness32),
        labelStyle: TextStyles.sourceSansB.body3,
        unselectedLabelStyle: TextStyles.sourceSans.body3.colour(
          UiConstants.textGray70,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        indicatorPadding: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness32),
          color: UiConstants.primaryColor,
        ),
        onTap: (i) => onTap(tabs[i], i),
        tabs: [
          for (var i = 0; i < tabs.length; i++)
            Tab(
              text: labelBuilder(tabs[i]),
              height: 35,
            )
        ],
      ),
    );
  }
}
