import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class LoginImage extends StatelessWidget {
  const LoginImage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      width: SizeConfig.screenWidth,
      child: AppConfig.getValue(AppConfigKey.loginAssetUrl) != null
          ? AppImage(
              AppConfig.getValue<String>(AppConfigKey.loginAssetUrl),
              fit: BoxFit.fill,
            )
          : Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding26,
                vertical: SizeConfig.padding44,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    UiConstants.kblue2.withOpacity(.4),
                    UiConstants.kblue1.withOpacity(.4),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppImage(
                    Assets.logoWhite,
                    width: SizeConfig.padding74,
                  ),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  Text(
                    'Welcome to fello',
                    style: TextStyles.sourceSansB.title3,
                  ),
                  SizedBox(
                    height: SizeConfig.padding6,
                  ),
                  Text(
                    'Let’s start your financial journey',
                    style: TextStyles.sourceSans.body1
                        .colour(UiConstants.kTextColor.withOpacity(.9)),
                  ),
                ],
              ),
            ),
    );
  }
}
