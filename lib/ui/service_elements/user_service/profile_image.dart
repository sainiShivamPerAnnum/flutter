import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class ProfileImageSE extends StatelessWidget {
  final double? radius;
  final bool reactive;
  const ProfileImageSE({super.key, this.radius, this.reactive = true});

  @override
  Widget build(BuildContext context) {
    final CustomLogger _logger = locator<CustomLogger>();
    final UserService _userService = locator<UserService>();
    final BaseUtil _baseUtil = locator<BaseUtil>();

    // Listener

    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: const [
        UserServiceProperties.myUserDpUrl,
        UserServiceProperties.myAvatarId
      ],
      builder: (context, model, properties) {
        return GestureDetector(
          onTap: reactive ? () => _baseUtil.openProfileDetailsScreen() : () {},
          child: CircleAvatar(
            key: const ValueKey(Constants.PROFILE),
            radius: radius ?? SizeConfig.avatarRadius,
            backgroundColor: Colors.black,
            child: model!.avatarId != null && model.avatarId != 'CUSTOM'
                ? SvgPicture.asset(
                    "assets/vectors/userAvatars/${model.avatarId}.svg",
                    fit: BoxFit.cover,
                  )
                : const SizedBox(),
            backgroundImage: (model.avatarId != null &&
                    model.avatarId == 'CUSTOM' &&
                    model.myUserDpUrl != null &&
                    model.myUserDpUrl!.isNotEmpty)
                ? CachedNetworkImageProvider(
                    model.myUserDpUrl!,
                  )
                : const AssetImage(
                    Assets.profilePic,
                  ) as ImageProvider<Object>?,
          ),
        );
      },
    );
  }
}
