import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class ProfileImageSE extends StatelessWidget {
  final double? radius;
  final bool reactive;
  final bool showBadge;

  const ProfileImageSE(
      {super.key, this.radius, this.reactive = true, this.showBadge = false});

  Color getBorderColor(List<dynamic>? segments) {
    if (segments == null) {
      return Colors.white.withOpacity(0.30);
    }
    if (segments.contains('SuperFello')) {
      return const Color(0xFFFFD979);
    } else if (segments.contains('Intermediate')) {
      return const Color(0xFF93B5FE);
    } else if (segments.contains('Beginner')) {
      return const Color(0xFFF79780);
    } else {
      return Colors.white.withOpacity(0.30);
    }
  }

  String getBadgeUrl(List<dynamic>? segments) {
    if (segments == null) {
      return '';
    }
    if (segments.contains('SuperFello')) {
      return "https://d37gtxigg82zaw.cloudfront.net/loyalty/level-2.svg";
    } else if (segments.contains('Intermediate')) {
      return "https://d37gtxigg82zaw.cloudfront.net/loyalty/level-1.svg";
    } else if (segments.contains('Beginner')) {
      return "https://d37gtxigg82zaw.cloudfront.net/loyalty/level-0.svg";
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final BaseUtil baseUtil = locator<BaseUtil>();

    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: const [
        UserServiceProperties.myUserDpUrl,
        UserServiceProperties.myAvatarId
      ],
      builder: (context, model, properties) {
        var badgeUrl = getBadgeUrl(model?.userSegments);
        return GestureDetector(
          onTap: reactive ? () => baseUtil!.openProfileDetailsScreen() : () {},
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: getBorderColor(model?.userSegments),
                  shape: BoxShape.circle,
                ),
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
              ),
              if (showBadge && badgeUrl.isNotEmpty)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: SvgPicture.network(
                    badgeUrl,
                    height: SizeConfig.padding22,
                    // width: SizeConfig.padding40,
                    fit: BoxFit.fill,
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
