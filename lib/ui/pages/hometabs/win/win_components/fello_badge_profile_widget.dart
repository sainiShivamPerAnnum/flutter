import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/badges_progress_indicator.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/user_badges_container.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/extensions/string_extension.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class ProfileBadgeWidget extends StatelessWidget {
  const ProfileBadgeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppState.delegate!.appState.currentAction = PageAction(
          state: PageState.addPage,
          page: FelloBadgeHomeViewPageConfig,
        );
      },
      child: Container(
        height: SizeConfig.padding180,
        width: SizeConfig.screenWidth,
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment(0.00, -1.00),
          //   end: Alignment(0, 1),
          //   colors: [Color(0x99FFB547), Color(0x458A7948), Color(0x002A484A)],
          // ),
          color: Color(0xFF191919),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.pageHorizontalMargins,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.padding8),
              child: Stack(
                children: [
                  Transform.scale(
                    scale: 1.2,
                    child: const UserBadgeContainer(
                      badgeColor: Color(0xFFFFD979),
                      badgeUrl:
                          'https://d37gtxigg82zaw.cloudfront.net/loyalty/level-2.svg',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //  BaseUtil.openDialog(
                      //   addToScreenStack: true,
                      //   isBarrierDismissible: false,
                      //   hapticVibrate: true,
                      //   content: UserAvatarSelectionDialog(
                      //     onCustomAvatarSelection: handleDPOperation,
                      //     onPresetAvatarSelection: updateUserAvatar,
                      //   ),
                      // );
                    },
                    child: Positioned(
                      top: 10,
                      right: 15,
                      child: Container(
                        width: SizeConfig.padding28,
                        height: SizeConfig.padding28,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          // make icon bold

                          child: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: SizeConfig.padding22,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PropertyChangeConsumer<UserService, UserServiceProperties>(
                  properties: const [UserServiceProperties.myName],
                  builder: (context, model, child) {
                    return Text(
                      (model!.baseUser!.kycName!.isNotEmpty
                          ? model.baseUser!.kycName!
                          : model.baseUser!.name!.isNotEmpty
                          ? model.baseUser!.name!
                          : "User")
                          .trim()
                          .split(' ')
                          .first
                          .capitalize(),
                      style: TextStyles.rajdhaniSB.title4.colour(Colors.white),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    );
                  },
                ),
                Text(
                  'Beginner Fello',
                  style: TextStyles.sourceSans.body3.colour(
                    const Color(0xFFF79780),
                  ),
                ),
                SizedBox(height: SizeConfig.padding12),
                BadgesProgressIndicator(
                  level: 3,
                  isSuperFello: false,
                  width: SizeConfig.padding50,
                ),
                SizedBox(height: SizeConfig.padding20),
                Container(
                  // width: 141.11,
                  // height: SizeC,
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding8,
                    vertical: SizeConfig.padding4,
                  ),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.69),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Become a Super Fello',
                        style: TextStyles.sourceSansSB.body4.colour(
                          const Color(0xFF191919),
                        ),
                      ),
                      SizedBox(width: SizeConfig.padding6),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: SizeConfig.padding12,
                        color: Colors.black,
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
