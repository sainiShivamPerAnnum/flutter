import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness5)),
      height: SizeConfig.screenHeight * 0.3,
      width: SizeConfig.navBarWidth,
      child: Center(
          child: BaseRemoteConfig.remoteConfig
                      .getString(BaseRemoteConfig.LOGIN_ASSET_URL) !=
                  ''
              ? SvgPicture.network(
                  BaseRemoteConfig.remoteConfig
                      .getString(BaseRemoteConfig.LOGIN_ASSET_URL),
                  height: SizeConfig.onboardingAssetsDimens,
                  width: SizeConfig.onboardingAssetsDimens,
                )
              : Container()),
    );
  }
}
