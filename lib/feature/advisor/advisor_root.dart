import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/advisor/advisor_components/call.dart';
import 'package:felloapp/feature/advisor/advisor_components/live.dart';
import 'package:felloapp/feature/advisor/bloc/advisor_bloc.dart';
import 'package:felloapp/feature/chat/bloc/chat_bloc.dart';
import 'package:felloapp/feature/chat/chat_screen.dart';
import 'package:felloapp/feature/chat_home/bloc/chat_history_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdvisorPage extends StatelessWidget {
  const AdvisorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              locator<AdvisorBloc>()..add(const LoadAdvisorData()),
        ),
        BlocProvider(
          create: (context) =>
              ChatHistoryBloc(locator())..add(const LoadChatHistory()),
        ),
      ],
      child: const AdvisorViewWrapper(),
    );
  }
}

class AdvisorViewWrapper extends StatefulWidget {
  const AdvisorViewWrapper({super.key});

  @override
  State<AdvisorViewWrapper> createState() => _AdvisorViewWrapperState();
}

class _AdvisorViewWrapperState extends State<AdvisorViewWrapper>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      color: UiConstants.primaryColor,
      backgroundColor: Colors.black,
      onRefresh: () async {
        BlocProvider.of<AdvisorBloc>(
          context,
          listen: false,
        ).add(const LoadAdvisorData());
        return;
      },
      child: BlocBuilder<AdvisorBloc, AdvisorState>(
        builder: (context, state) {
          return switch (state) {
            LoadingAdvisorData() => const FullScreenLoader(),
            ErrorAdvisorData() => NewErrorPage(
                onTryAgain: () {
                  BlocProvider.of<AdvisorBloc>(
                    context,
                    listen: false,
                  ).add(
                    const LoadAdvisorData(),
                  );
                },
              ),
            AdvisorData() => Column(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Advisor Section',
                                  style: TextStyles.sourceSansSB.body1,
                                ),
                              ],
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
                            controller: _tabController,
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
                              Tab(text: 'Chats'),
                              Tab(text: 'Calls'),
                              Tab(text: 'Live'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tab Bar View
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
                          builder: (context, state) {
                            return switch (state) {
                              LoadingChatHistory() => const FullScreenLoader(),
                              ErrorChatHistory() => NewErrorPage(
                                  onTryAgain: () =>
                                      BlocProvider.of<ChatHistoryBloc>(
                                    context,
                                    listen: false,
                                  ).add(const LoadChatHistory()),
                                ),
                              ChatHistoryData() => Padding(
                                  padding: EdgeInsets.only(top: 14.h),
                                  child: ListView.separated(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                    ),
                                    separatorBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.h,
                                        ),
                                        child: Divider(
                                          color: UiConstants.kTextColor6
                                              .withOpacity(0.1),
                                        ),
                                      );
                                    },
                                    itemCount: state.chatHistory.length,
                                    itemBuilder: (context, index) {
                                      final data = state.chatHistory[index];
                                      return GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          AppState.delegate!.appState
                                              .currentAction = PageAction(
                                            page: ChatsPageConfig,
                                            state: PageState.addWidget,
                                            widget: BlocProvider(
                                              create: (context) => ChatBloc(
                                                chatRepository: locator(),
                                              ),
                                              child: ChatScreen(
                                                advisorId: data.metadata.id,
                                                advisorAvatar: data.metadata
                                                    .advisorProfilePhoto,
                                                advisorName:
                                                    data.metadata.advisorName,
                                                price: data.metadata.price,
                                                duration:
                                                    data.metadata.duration,
                                                sessionId: data.sessionId,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: 20.r,
                                                  backgroundColor:
                                                      Colors.grey[300],
                                                  backgroundImage: NetworkImage(
                                                    data.metadata.userImage ??
                                                        '',
                                                  ),
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 24.r,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        data.metadata
                                                                .userName ??
                                                            '',
                                                        style: TextStyles
                                                            .sourceSansM.body2
                                                            .colour(
                                                          UiConstants
                                                              .kTextColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        BaseUtil.formatOnlyDate(
                                                          DateTime.tryParse(
                                                                data.lastMessageTimestamp,
                                                              ) ??
                                                              DateTime.now(),
                                                        ),
                                                        style: TextStyles
                                                            .sourceSansM.body4
                                                            .colour(
                                                          data.unreadCount > 0
                                                              ? UiConstants
                                                                  .teal3
                                                              : UiConstants
                                                                  .kTextColor
                                                                  .withOpacity(
                                                                      .5),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        constraints:
                                                            BoxConstraints(
                                                          maxWidth: 218.w,
                                                        ),
                                                        child: Text(
                                                          data.lastMessage,
                                                          style: TextStyles
                                                              .sourceSans.body3
                                                              .colour(
                                                            data.unreadCount > 0
                                                                ? UiConstants
                                                                    .kTextColor
                                                                : UiConstants
                                                                    .kTextColor
                                                                    .withOpacity(
                                                                        .5),
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      if (data.unreadCount > 0)
                                                        Container(
                                                          width: 6.r,
                                                          height: 6.r,
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: UiConstants
                                                                .teal3,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                            };
                          },
                        ),
                        // Calls Tab
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding20,
                          ),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                const Call(callType: "upcoming"),
                                const Call(callType: "past"),
                                SizedBox(height: 80.h),
                              ],
                            ),
                          ),
                        ),

                        // // Live Tab
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding20,
                          ),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                const Live(),
                                SizedBox(height: 80.h),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          };
        },
      ),
    );
  }
}
