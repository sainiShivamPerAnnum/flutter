import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({Key key,this.size}) : super(key: key);
final double size;
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(Assets.fullScreenLoaderLottie,
        height:size?? SizeConfig.screenWidth / 2);
  }
}
