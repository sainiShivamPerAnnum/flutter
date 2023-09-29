import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class PageViewWithIndicator extends StatefulWidget {
  const PageViewWithIndicator(
      {Key? key,
      required this.children,
      required this.controller,
      required this.showIndicator})
      : super(key: key);

  final List<Widget>? children;
  final bool showIndicator;
  final PageController controller;

  @override
  State<PageViewWithIndicator> createState() => _PageViewWithIndicatorState();
}

class _PageViewWithIndicatorState extends State<PageViewWithIndicator> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  int ticketsCount = 0;

  @override
  void initState() {
    print("Init called for page controller");
    ticketsCount = widget.children!.length > 5 ? 5 : widget.children!.length;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("Init called for page controller");
    super.didChangeDependencies();
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
    ticketsCount = widget.children!.length > 5 ? 5 : widget.children!.length;
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.screenWidth! * 0.52,
          width: SizeConfig.screenWidth,
          child: PageView(
            physics: const BouncingScrollPhysics(),
            controller: widget.controller,
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
