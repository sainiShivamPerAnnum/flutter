import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/live/live_home.dart';
import 'package:felloapp/feature/live/live_root.dart';
import 'package:felloapp/feature/live/view_all_live.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopLive extends StatelessWidget {
  const TopLive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<SaveViewModel, LiveHome?>(
      builder: (_, liveData, __) {
        return (liveData == null)
            ? const SizedBox.shrink()
            : liveData.recent.isEmpty && liveData.live.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: SizeConfig.padding14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleSubtitleContainer(
                            title: liveData.live.isNotEmpty
                                ? liveData.sections.live.title
                                : liveData.sections.recent.title,
                          ),
                          if (liveData.live.isNotEmpty &&
                              liveData.live.length > 1)
                            TextButton(
                              onPressed: () {
                                AppState.delegate!.appState.currentAction =
                                    PageAction(
                                  page: AllEventsPageConfig,
                                  state: PageState.addWidget,
                                  widget: ViewAllLive(
                                    advisorPast: null,
                                    advisorUpcoming: null,
                                    type: 'live',
                                    appBarTitle: liveData.sections.live.title,
                                    liveList: liveData.live,
                                    upcomingList: null,
                                    recentList: null,
                                    onNotify: null,
                                    notificationState: null,
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'VIEW ALL',
                                    style: TextStyles.sourceSansSB.body3,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: SizeConfig.body3,
                                  ),
                                ],
                              ),
                            ),
                          if (liveData.live.isEmpty &&
                              liveData.recent.length > 1)
                            TextButton(
                              onPressed: () {
                                AppState.delegate!.appState.currentAction =
                                    PageAction(
                                  page: AllEventsPageConfig,
                                  state: PageState.addWidget,
                                  widget: ViewAllLive(
                                    advisorPast: null,
                                    advisorUpcoming: null,
                                    type: 'recent',
                                    appBarTitle: liveData.sections.recent.title,
                                    liveList: null,
                                    upcomingList: null,
                                    recentList: liveData.recent,
                                    onNotify: null,
                                    notificationState: null,
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'VIEW ALL',
                                    style: TextStyles.sourceSansSB.body3,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: SizeConfig.body3,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.padding14),
                      if (liveData.live.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(
                            left: SizeConfig.padding20,
                          ),
                          child: buildLiveSection(liveData.live),
                        ),
                      if (liveData.live.isEmpty)
                        Padding(
                          padding: EdgeInsets.only(
                            left: SizeConfig.padding20,
                          ),
                          child: buildRecentSection(
                            liveData.recent,
                            context,
                            true,
                          ),
                        ),
                    ],
                  );
      },
      selector: (_, model) => model.liveData,
    );
  }
}
