import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class DEVBanner extends StatelessWidget {
  const DEVBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlavorConfig.isDevelopment()
        ? Container(
            width: SizeConfig.screenWidth,
            child: Banner(
              message: FlavorConfig.getStage(),
              location: BannerLocation.topEnd,
              color: FlavorConfig.instance!.color,
            ),
          )
        : SizedBox();
  }
}

class QABanner extends StatelessWidget {
  const QABanner({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlavorConfig.isQA()
        ? Container(
            width: SizeConfig.screenWidth,
            child: Banner(
              message: FlavorConfig.getStage(),
              location: BannerLocation.topEnd,
              color: FlavorConfig.instance!.color,
            ),
          )
        : SizedBox();
  }
}
