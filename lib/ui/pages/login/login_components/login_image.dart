import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginImage extends StatelessWidget {
  const LoginImage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
        height: SizeConfig.screenWidth! * 0.64,
        width: SizeConfig.screenWidth,
        child: Center(
          child: AppConfig.getValue(AppConfigKey.loginAssetUrl) != null
              ? SvgPicture.network(
                  AppConfig.getValue<String>(AppConfigKey.loginAssetUrl),
                  fit: BoxFit.contain,
                )
              : Container(),
        ),
      ),
    );
  }
}
