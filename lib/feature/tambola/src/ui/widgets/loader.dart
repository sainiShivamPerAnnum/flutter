import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class FullScreenCircularLoader extends StatelessWidget {
  final double? size;
  final bool bottomPadding;

  const FullScreenCircularLoader(
      {Key? key, this.size, this.bottomPadding = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircularProgressIndicator(strokeWidth: 1, color: Colors.white),
        if (bottomPadding) SizedBox(height: SizeConfig.screenHeight! * 0.1)
      ],
    );
  }
}
