import 'package:felloapp/util/flavor_config.dart';
import 'package:flutter/material.dart';

class FlavorBanner extends StatelessWidget {
  final Widget child;
  BannerConfig bannerConfig;
  FlavorBanner({@required this.child});

  @override
  Widget build(BuildContext context) {
    if (FlavorConfig.isProduction()) return child;
    bannerConfig ??= _getDefaultBanner();
    return Stack(
      children: <Widget>[child, SafeArea(child: _buildBanner(context))],
    );
  }

  BannerConfig _getDefaultBanner() {
    return BannerConfig(
        bannerName: FlavorConfig.instance.name,
        bannerColor: FlavorConfig.instance.color);
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      child: CustomPaint(
        painter: BannerPainter(
            message: bannerConfig.bannerName,
            textDirection: Directionality.of(context),
            layoutDirection: Directionality.of(context),
            location: BannerLocation.topStart,
            color: bannerConfig.bannerColor),
      ),
    );
  }
}

class BannerConfig {
  final String bannerName;
  final Color bannerColor;
  BannerConfig(
      {@required String this.bannerName, @required Color this.bannerColor});
}
