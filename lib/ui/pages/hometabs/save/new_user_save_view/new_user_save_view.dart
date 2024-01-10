import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/sdui/sections/home_page_sections.dart'
    as sections;
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/asset_prefs/asset_prefs.dart';
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

  Widget _getWidgetBySection(sections.HomePageSection? section) {
    final widget = switch (section) {
      sections.StoriesSection(data: final d) => StoriesSection(
          data: d,
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
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator(); // to avoid glow
        return true;
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                AppState.delegate!.appState.currentAction = PageAction(
                  state: PageState.addWidget,
                  page: AssetPrefPageConfig,
                  widget: AssetPrefView(
                    data: locator(),
                  ),
                );
              },
              child: null,
            ),
            for (var i = 0; i < sectionOrder.length; i++)
              _getWidgetBySection(section[sectionOrder[i]]),
          ],
        ),
      ),
    );
  }
}
