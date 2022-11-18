import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.roundness5)),
        height: SizeConfig.screenWidth! * 0.6,
        width: SizeConfig.navBarWidth,
        child: Center(
            child: BaseRemoteConfig.remoteConfig
                        .getString(BaseRemoteConfig.LOGIN_ASSET_URL) !=
                    ''
                ? SvgPicture.network(
                    BaseRemoteConfig.remoteConfig
                        .getString(BaseRemoteConfig.LOGIN_ASSET_URL),
                    fit: BoxFit.contain,
                  )
                : Container()),
      ),
    );
  }
}
