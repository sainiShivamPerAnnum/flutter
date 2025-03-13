import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/live/live_home.dart';
import 'package:felloapp/feature/live/live_root.dart';
import 'package:felloapp/feature/live/view_all_live.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TopLive extends StatelessWidget {
  const TopLive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<SaveViewModel, LiveHome?>(
      builder: (_, liveData, __) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: (liveData == null) || liveData.live.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(top: 20.h, bottom: 24.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: Text(
                              "Live webinar",
                              style: TextStyles.sourceSansSB.body2,
                            ),
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
                                    fromHome: true,
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'VIEW ALL',
                                    style: TextStyles.sourceSans.body4,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 10.r,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      if (liveData.live.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20.w,
                          ),
                          child: buildLiveSection(liveData.live, true),
                        ),
                    ],
                  ),
                ),
        );
      },
      selector: (_, model) => model.liveData,
    );
  }
}
