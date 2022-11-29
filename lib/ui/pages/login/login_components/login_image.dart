import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginImage extends StatelessWidget {
  final AppConfig _appConfig;

  LoginImage({Key? key, AppConfig? appConfig})
      : _appConfig = appConfig ?? locator(),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
        height: SizeConfig.screenWidth! * 0.64,
        width: SizeConfig.screenWidth,
        child: Center(
          child: _appConfig.data[AppConfigKey.loginAssetUrl] != null
              ? SvgPicture.network(
                  _appConfig.data[AppConfigKey.loginAssetUrl] as String,
                  fit: BoxFit.contain,
                )
              : Container(),
        ),
      ),
    );
  }
}
