import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/extensions/string_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class Salutation extends StatelessWidget {
  const Salutation({
    Key? key,
    this.leftMargin,
    this.textStyle,
  }) : super(key: key);

  final double? leftMargin;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Haptic.vibrate();
        AppState.delegate!.parseRoute(Uri.parse('/accounts'));
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: leftMargin ?? SizeConfig.pageHorizontalMargins,
          right: SizeConfig.padding4,
          top: SizeConfig.padding10,
        ),
        child: PropertyChangeConsumer<UserService, UserServiceProperties>(
          properties: const [UserServiceProperties.myName],
          builder: (context, model, child) {
            return Text(
              "Hi ${(model!.baseUser!.kycName!.isNotEmpty ? model.baseUser!.kycName! : model.baseUser!.name!.isNotEmpty ? model.baseUser!.name! : "User").trim().split(' ').first.capitalize()}",
              style: textStyle ??
                  TextStyles.rajdhaniSB.title3.colour(Colors.white),
              overflow: TextOverflow.fade,
              maxLines: 1,
            );
          },
        ),
      ),
    );
  }
}

class AccountInfoTiles extends StatelessWidget {
  const AccountInfoTiles({
    required this.title,
    required this.uri,
    Key? key,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String uri;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap == null) {
          AppState.delegate!.parseRoute(Uri.parse(uri));
        } else {
          onTap!.call();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.pageHorizontalMargins,
            vertical: SizeConfig.padding16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyles.sourceSans.body1.colour(Colors.white),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: SizeConfig.iconSize2, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class RewardsAvatar extends StatelessWidget {
  final Color? color;
  final String? asset;

  const RewardsAvatar({Key? key, this.asset, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth! * 0.24,
      margin: EdgeInsets.only(right: SizeConfig.padding16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness56),
        color: color,
        image: DecorationImage(image: AssetImage(asset!), fit: BoxFit.fitWidth),
      ),
    );
  }
}

Widget referralTile(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20.0),
    child: Row(
      children: [
        const Icon(
          Icons.brightness_1,
          size: 12,
          color: UiConstants.primaryColor,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyles.body3,
          ),
        ),
      ],
    ),
  );
}
