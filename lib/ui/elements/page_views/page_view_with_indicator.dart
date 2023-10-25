import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class PageViewWithIndicator extends StatefulWidget {
  const PageViewWithIndicator(
      {required this.children, required this.showIndicator, Key? key})
      : super(key: key);

  final List<Widget>? children;
  final bool showIndicator;

  @override
  State<PageViewWithIndicator> createState() => _PageViewWithIndicatorState();
}

class _PageViewWithIndicatorState extends State<PageViewWithIndicator> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  PageController? controller;
  int ticketsCount = 0;

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    ticketsCount = widget.children!.length > 5 ? 5 : widget.children!.length;
    super.initState();
  }

  Padding _buildCircleIndicator() {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.padding4),
      child: CirclePageIndicator(
        itemCount: ticketsCount,
        currentPageNotifier: _currentPageNotifier,
        selectedDotColor: UiConstants.kSelectedDotColor,
        dotColor: Colors.white.withOpacity(0.5),
        selectedSize: SizeConfig.padding8,
        size: SizeConfig.padding6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.screenWidth! * 0.52,
          width: SizeConfig.screenWidth,
          child: PageView(
            physics: const BouncingScrollPhysics(),
            controller: controller,
            scrollDirection: Axis.horizontal,
            children: List.generate(
                widget.children!.sublist(0, ticketsCount).length,
                (index) => widget.children![index]),
            onPageChanged: (index) {
              _currentPageNotifier.value = index;
            },
          ),
        ),
        SizedBox(
          height: SizeConfig.padding8,
        ),
        if (widget.showIndicator) _buildCircleIndicator(),
      ],
    );
  }
}
