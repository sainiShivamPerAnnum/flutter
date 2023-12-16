import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/fello_badges/shared/sf_level_mapping_extension.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class ProfileImageSE extends StatefulWidget {
  final double? radius;
  final bool reactive;
  final bool showBadge;
  final bool highLightNewUser;

  const ProfileImageSE({
    super.key,
    this.radius,
    this.reactive = true,
    this.showBadge = false,
    this.highLightNewUser = false,
  });

  @override
  State<ProfileImageSE> createState() => _ProfileImageSEState();
}

class _ProfileImageSEState extends State<ProfileImageSE> {
  Color? _getColorFromLevel(SuperFelloLevel level) {
    if (widget.showBadge && level.isNewFello) {
      return UiConstants.primaryColor; // for highlighting for new user.
    }

    if (widget.showBadge) {
      return level.getLevelData.borderColor; // if user have achieved any level.
    }

    return null;
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
        final data = model!.baseUser!.superFelloLevel.getLevelData;
        return GestureDetector(
          onTap: widget.reactive ? baseUtil.openProfileDetailsScreen : null,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getColorFromLevel(model.baseUser!.superFelloLevel),
                ),
                child: CircleAvatar(
                  key: const ValueKey(Constants.PROFILE),
                  radius: widget.radius ?? SizeConfig.avatarRadius,
                  backgroundColor: Colors.black,
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
                  child: model.avatarId != null && model.avatarId != 'CUSTOM'
                      ? SvgPicture.asset(
                          "assets/vectors/userAvatars/${model.avatarId}.svg",
                          fit: BoxFit.cover,
                        )
                      : const SizedBox(),
                ),
              ),
              if (widget.showBadge && data.url.isNotEmpty)
                Positioned(
                  right: -02,
                  bottom: -03,
                  child: SvgPicture.network(
                    data.url,
                    height: SizeConfig.padding20,
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
