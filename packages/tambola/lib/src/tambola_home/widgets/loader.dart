import 'package:flutter/material.dart';
import 'package:tambola/src/utils/styles/size_config.dart';

class FullScreenLoader extends StatelessWidget {
  final double? size;
  final bool bottomPadding;
  const FullScreenLoader({Key? key, this.size, this.bottomPadding = false})
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
