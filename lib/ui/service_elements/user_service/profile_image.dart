import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/util/custom_logger.dart';
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
          "MyDpUrl updated in profile image widget, notified from user service.");
    }

    // Listener
    _userService.addListener(_listener, [UserServiceProperties.myUserDpUrl]);

    return PropertyChangeConsumer<UserService, UserServiceProperties>(
        properties: [UserServiceProperties.myUserDpUrl],
        builder: (context, model, properties) {
          return CircleAvatar(
            radius: radius,
            backgroundImage: model.myUserDpUrl == null
                ? AssetImage(
                    Assets.profilePic,
                  )
                : CachedNetworkImageProvider(
                    model.myUserDpUrl,
                  ),
          );
        });
  }
}
