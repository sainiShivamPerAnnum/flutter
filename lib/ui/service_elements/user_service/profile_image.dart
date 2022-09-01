import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class ProfileImageSE extends StatelessWidget {
  final radius;
  ProfileImageSE({@required this.radius});

  @override
  Widget build(BuildContext context) {
    final _logger = locator<CustomLogger>();
    final _userService = locator<UserService>();

    void _listener() {
      _logger.d(
        "MyDpUrl updated in profile image widget, notified from user service.",
      );
    }

    // Listener
    _userService.addListener(_listener, [UserServiceProperties.myUserDpUrl]);

    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
        properties: [JourneyServiceProperties.AvatarRemoteMilestoneIndex],
        builder: (context, journeyModel, properties) {
          return PropertyChangeConsumer<UserService, UserServiceProperties>(
            properties: [UserServiceProperties.myUserDpUrl],
            builder: (context, model, properties) {
              log("Avatar Id: ${model?.baseUser?.avatarId}");
              return CircleAvatar(
                radius: radius,
                backgroundColor: Colors.black,
                child: model?.baseUser?.avatarId != 'CUSTOM' ||
                        model.myUserDpUrl == null
                    ? SvgPicture.asset(
                        "assets/svg/userAvatars/${model?.baseUser?.avatarId ?? 'AV2'}.svg",
                        height: radius * 2,
                        width: radius * 2,
                      )
                    : SizedBox(),
                backgroundImage: model?.baseUser?.avatarId == 'CUSTOM' ||
                        model.myUserDpUrl != null
                    ? CachedNetworkImageProvider(
                        model.myUserDpUrl,
                      )
                    : AssetImage(
                        Assets.profilePic,
                      ),
              );
            },
          );
        });
  }
}
