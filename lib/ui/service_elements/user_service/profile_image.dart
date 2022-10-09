import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class ProfileImageSE extends StatelessWidget {
  final double radius;
  final bool reactive;
  ProfileImageSE({this.radius, this.reactive = true});

  @override
  Widget build(BuildContext context) {
    final _logger = locator<CustomLogger>();
    final _userService = locator<UserService>();
    final _baseUtil = locator<BaseUtil>();

    // Listener

    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
      properties: [JourneyServiceProperties.AvatarRemoteMilestoneIndex],
      builder: (context, journeyModel, properties) {
        return PropertyChangeConsumer<UserService, UserServiceProperties>(
          properties: [
            UserServiceProperties.myUserDpUrl,
            UserServiceProperties.myAvatarId
          ],
          builder: (context, model, properties) {
            return GestureDetector(
              onTap:
                  reactive ? () => _baseUtil.openProfileDetailsScreen() : () {},
              child: CircleAvatar(
                radius: radius ?? SizeConfig.avatarRadius,
                backgroundColor: Colors.black,
                child: model.myUserDpUrl == null
                    ? (model.avatarId != null && model.avatarId != 'CUSTOM'
                        ? SvgPicture.asset(
                            "assets/vectors/userAvatars/${model.avatarId}.svg",
                            fit: BoxFit.cover,
                          )
                        : SizedBox())
                    : SizedBox(),
                backgroundImage:
                    (model.avatarId != null && model.avatarId == 'CUSTOM') ||
                            model.myUserDpUrl != null
                        ? CachedNetworkImageProvider(
                            model.myUserDpUrl,
                          )
                        : AssetImage(
                            Assets.profilePic,
                          ),
              ),
            );
          },
        );
      },
    );
  }
}
