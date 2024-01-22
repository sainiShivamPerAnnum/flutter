import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCaseView extends StatelessWidget {
  const ShowCaseView(
      {required this.globalKey,
      required this.description,
      required this.child,
      this.title,
      this.shapeBorder = const CircleBorder(),
      this.onTargetClick,
      this.toolTipPosition,
      this.targetBorderRadius,
      super.key});
  final GlobalKey globalKey;
  final String? title;
  final String description;
  final Widget child;
  final ShapeBorder shapeBorder;
  final BorderRadius? targetBorderRadius;
  final TooltipPosition? toolTipPosition;
  final VoidCallback? onTargetClick;

  @override
  Widget build(BuildContext context) {
    return Showcase(
      targetBorderRadius: targetBorderRadius,
      title: title,
      tooltipPosition: toolTipPosition,
      descriptionAlignment: TextAlign.start,
      scrollLoadingWidget: const SizedBox.shrink(),
      description: description,
      key: globalKey,
      targetShapeBorder: shapeBorder,
      child: child,
    );
  }
}
