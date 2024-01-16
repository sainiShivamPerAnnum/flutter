import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/sdui/sections/home_page_sections.dart'
    as sections;
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/hometabs/save/stories/stories_section/stories_section_view.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart' hide Action;

import '../../../../../util/styles/styles.dart';
import 'sections/sections.dart';

class NewUserSaveView extends StatelessWidget {
  const NewUserSaveView({
    required this.data,
    super.key,
  });
  final sections.PageData data;

  Widget _getWidgetBySection(
      sections.HomePageSection? section, bool hasReferred) {
    // ⛔️ hack because of static things on backend 🤷🏻.
    if (section is sections.NudgeSection && !hasReferred) {
      return const SizedBox.shrink();
    }

    final widget = switch (section) {
      sections.StoriesSection(data: final d) => StoriesSection(
          data: d,
          style: data.styles.stories,
        ),
      sections.StepsSection(data: final d) => StepsSection(
          data: d,
          styles: data.styles.steps,
        ),
      sections.QuickActions(data: final d) => QuickActionsSection(
          data: d,
          styles: data.styles.infoCards,
        ),
      sections.ImageSection(data: final d) => ImageSection(
          data: d,
        ),
      sections.NudgeSection() => const NudgeSection(),
      _ => const SizedBox.shrink()
    };

    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.padding30),
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final homePageData = data.screens.home;
    final sectionOrder = homePageData.sectionOrder;
    final section = homePageData.sections;
    final showReferral = (BaseUtil.referrerUserId != null ||
            BaseUtil.manualReferralCode != null) &&
        locator<UserService>().userPortfolio.absolute.balance <= 0;

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator(); // to avoid glow
        return true;
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < sectionOrder.length; i++)
              _getWidgetBySection(section[sectionOrder[i]], showReferral),
          ],
        ),
      ),
    );
  }
}
