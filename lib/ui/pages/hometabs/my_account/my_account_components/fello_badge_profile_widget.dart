import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/fello_badges/shared/sf_level_mapping_extension.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/badges_progress_indicator.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/user_badges_container.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/extensions/string_extension.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class ProfileBadgeWidget extends StatefulWidget {
  const ProfileBadgeWidget({
    required this.superFelloLevel,
    required this.onPickImage,
    super.key,
  });

  final SuperFelloLevel superFelloLevel;
  final VoidCallback onPickImage;

  @override
  State<ProfileBadgeWidget> createState() => _ProfileBadgeWidgetState();
}

class _ProfileBadgeWidgetState extends State<ProfileBadgeWidget> {
  String getContainerText() {
    return widget.superFelloLevel.isSuperFello
        ? "View Your Benefits"
        : "Become a Super Fello";
  }

  void _onTap() {
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: FelloBadgeHomeViewPageConfig,
    );

    locator<AnalyticsService>()
        .track(eventName: AnalyticsEvents.superFelloEntryPoint, properties: {
      'current_level': locator<UserService>().baseUser!.superFelloLevel.name,
      'location': 'account_section',
    });
  }

  @override
  Widget build(BuildContext context) {
    final (url: _, :textColor, :title, borderColor: _) =
        widget.superFelloLevel.getLevelData;

    return GestureDetector(
      onTap: _onTap,
      child: Container(
        height: SizeConfig.padding180,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          gradient: widget.superFelloLevel.isSuperFello
              ? const LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [
                    Color(0x99FFB547),
                    Color(0x458A7948),
                    Color(0x002A484A)
                  ],
                )
              : null,
          color: widget.superFelloLevel.isSuperFello
              ? null
              : const Color(0xFF191919),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.pageHorizontalMargins,
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.padding8),
              child: Transform.scale(
                scale: 1.2,
                child: UserBadgeContainer(
                  level: widget.superFelloLevel,
                  showImagePickIcon: true,
                  onPickImage: widget.onPickImage,
                ),
              ),
            ),
            SizedBox(
              width: SizeConfig.padding20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PropertyChangeConsumer<UserService, UserServiceProperties>(
                    properties: const [UserServiceProperties.myName],
                    builder: (context, model, child) {
                      final baseUser = model!.baseUser!;
                      final kycName = baseUser.kycName;
                      final userName = baseUser.name;
                      return Text(
                        (kycName!.isNotEmpty
                                ? kycName
                                : userName!.isNotEmpty
                                    ? userName
                                    : "User")
                            .trim()
                            .split(' ')
                            .first
                            .capitalize(),
                        style:
                            TextStyles.rajdhaniSB.title4.colour(Colors.white),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      );
                    },
                  ),
                  Text(
                    title,
                    style: TextStyles.sourceSans.body3.colour(
                      textColor,
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding12),
                  if (!widget.superFelloLevel.isSuperFello)
                    BadgesProgressIndicator(
                      level: widget.superFelloLevel,
                    ),
                  SizedBox(height: SizeConfig.padding20),
                  Container(
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
                          getContainerText(),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
