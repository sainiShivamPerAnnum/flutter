import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/chat/chat_history.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/experts_tab_controller.dart';
import 'package:felloapp/feature/chat_home/bloc/chat_history_bloc.dart';
import 'package:felloapp/feature/chat_home/chat_home.dart';
import 'package:felloapp/feature/expert/bloc/expert_bloc.dart';
import 'package:felloapp/feature/expert/expert_root.dart';
import 'package:felloapp/feature/shortsHome/shorts_v2.dart';
import 'package:felloapp/feature/shorts_notifications/shorts_notifications.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../shortsHome/bloc/shorts_home_bloc.dart';

class NewExpertsHome extends StatelessWidget {
  const NewExpertsHome({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => locator<ExpertBloc>()..add(const LoadExpertsData()),
        ),
        BlocProvider(
          create: (context) =>
              ShortsHomeBloc(locator(), locator())..add(const LoadHomeData()),
        ),
        BlocProvider(
          create: (_) =>
              locator<ChatHistoryBloc>()..add(const LoadChatHistory()),
        ),
      ],
      child: const ExpertsViewWrapper(),
    );
  }
}

class ExpertsViewWrapper extends StatefulWidget {
  const ExpertsViewWrapper({super.key});

  @override
  State<ExpertsViewWrapper> createState() => _ExpertsViewWrapperState();
}

class _ExpertsViewWrapperState extends State<ExpertsViewWrapper>
    with TickerProviderStateMixin {
  late GlobalTabController _globalTabController;

  @override
  void initState() {
    super.initState();
    _globalTabController = locator<GlobalTabController>();
    _globalTabController.initialize(this);
    _globalTabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _globalTabController.removeListener(_onTabChanged);
    RootController.autoScrollController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding20,
            vertical: SizeConfig.padding14,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                UiConstants.bg,
                Color(0xff212B2D),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.padding14,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _globalTabController.getTabTitle(),
                        style: TextStyles.sourceSansSB.body1,
                      ),
                      Text(
                        _globalTabController.getTabSubtitle(),
                        style: TextStyles.sourceSans.body3.colour(
                          UiConstants.kTextColor.withOpacity(.7),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      AppState.delegate!.appState.currentAction = PageAction(
                        page: ShortsNotificationPageConfig,
                        state: PageState.addWidget,
                        widget: const ShortsNotificationPage(),
                      );
                      locator<AnalyticsService>().track(
                        eventName: AnalyticsEvents.shortsNotication,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: UiConstants.grey5,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            SizeConfig.roundness12,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.all(SizeConfig.padding10),
                      child: const Icon(
                        Icons.notifications_rounded,
                        color: UiConstants.kTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: SizeConfig.padding8,
                  top: SizeConfig.padding16,
                ),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: const Color(0xff1A1A1A),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TabBar(
                  controller: _globalTabController.tabController,
                  indicator: BoxDecoration(
                    color: const Color(0xff2A2A2A),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyles.sourceSansSB.body3,
                  unselectedLabelStyle: TextStyles.sourceSans.body3,
                  tabs: const [
                    Tab(text: 'Expert'),
                    Tab(text: 'Shorts'),
                    Tab(text: 'Chats'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _globalTabController.tabController,
            children: [
              const ExpertsHomeView(),
              const ShortsNewPage(),
              BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
                builder: (context, state) {
                  List<ChatHistory> currentChatHistory = [];
                  if (state is ChatHistoryData) {
                    currentChatHistory = state.chatHistory;
                  }
                  return ChatHome(
                    currentChatHistory: currentChatHistory,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
