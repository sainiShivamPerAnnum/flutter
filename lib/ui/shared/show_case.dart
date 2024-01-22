import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCaseView extends StatelessWidget {
  const ShowCaseView(
      {required this.globalKey,
      required this.title,
      required this.description,
      required this.child,
      this.shapeBorder = const CircleBorder(),
      this.onTargetClick,
      super.key});
  final GlobalKey globalKey;
  final String title;
  final String description;
  final Widget child;
  final ShapeBorder shapeBorder;
  final VoidCallback? onTargetClick;

  @override
  Widget build(BuildContext context) {
    return Showcase(
      // container: Container(
      //   child: Text(title),
      // ),
      // height: 140,
      // width: 140,
      //showArrow: true,
      disposeOnTap: false,
      // onTargetClick: () {},
      title: null,
      // disableDefaultTargetGestures: false,
      onTargetClick: onTargetClick ?? () {},
      // onBarrierClick: () {

      // },
      descriptionAlignment: TextAlign.start,
      scrollLoadingWidget: const SizedBox.shrink(),
      description:
          "Sit cupidatat cupidatat qui eu velit aliquip elit consectetur irure cillum nulla. Dolore elit id ut laborum excepteur commodo sit fugiat cupidatat aute exercitation labore ut. Ex ipsum amet officia adipisicing.",
      key: globalKey,
      targetShapeBorder: shapeBorder,
      child: child,
    );
  }
}
