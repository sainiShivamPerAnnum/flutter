import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class FullScreenLoader extends StatelessWidget {
  final double? size;
  final bool bottomPadding;
  const FullScreenLoader({Key? key, this.size, this.bottomPadding = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.network(
            Assets.fullScreenLoaderLottie,
            height: size ?? SizeConfig.screenWidth! / 2,
          ),
          if (bottomPadding) SizedBox(height: SizeConfig.screenHeight! * 0.1)
        ],
      ),
    );
  }
}
