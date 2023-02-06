import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/extensions/string_extension.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class Salutation extends StatelessWidget {
  const Salutation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.pageHorizontalMargins,
        right: SizeConfig.pageHorizontalMargins,
        top: SizeConfig.padding10,
      ),
      child: PropertyChangeConsumer<UserService, UserServiceProperties>(
        properties: [UserServiceProperties.myName],
        builder: (context, model, child) {
          return Text(
            "Hi " +
                ((model!.baseUser!.kycName!.isNotEmpty
                        ? model.baseUser!.kycName!
                        : model.baseUser!.name!.isNotEmpty
                            ? model.baseUser!.name!
                            : "User")
                    .trim()
                    .split(' ')
                    .first
                    .capitalize()),
            style: TextStyles.rajdhaniSB.title3.colour(Colors.white),
          );
        },
      ),
    );
  }
}

class AccountInfoTiles extends StatelessWidget {
  const AccountInfoTiles({
    Key? key,
    required this.title,
    required this.uri,
  }) : super(key: key);

  final String title;
  final String uri;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppState.delegate!.parseRoute(Uri.parse(uri)),
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

  RewardsAvatar({this.asset, this.color});

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
    padding: EdgeInsets.only(bottom: 20.0),
    child: Row(
      children: [
        Icon(
          Icons.brightness_1,
          size: 12,
          color: UiConstants.primaryColor,
        ),
        SizedBox(width: 10),
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
