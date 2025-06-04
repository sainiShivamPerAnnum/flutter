import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/chat/chat_history.dart';
import 'package:felloapp/feature/advisor/advisor_components/call.dart';
import 'package:felloapp/feature/advisor/advisor_components/live.dart';
import 'package:felloapp/feature/advisor/bloc/advisor_bloc.dart';
import 'package:felloapp/feature/chat/bloc/chat_bloc.dart';
import 'package:felloapp/feature/chat/chat_screen.dart';
import 'package:felloapp/feature/chat_home/bloc/chat_history_bloc.dart';
import 'package:felloapp/feature/chat_home/widgets/no_chats.dart';
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
              locator<ChatHistoryBloc>()..add(const LoadChatHistory()),
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
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<ChatHistory> _currentChatHistory = [];

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
        BlocProvider.of<ChatHistoryBloc>(
          context,
          listen: false,
        ).add(const StopChatHistoryStream());
        BlocProvider.of<ChatHistoryBloc>(
          context,
          listen: false,
        ).add(const LoadChatHistory());
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
                        BlocConsumer<ChatHistoryBloc, ChatHistoryState>(
                          listener: (context, state) {
                            if (state is ChatHistoryData) {
                              _updateAnimatedList(state.chatHistory);
                            }
                          },
                          builder: (context, state) {
                            return switch (state) {
                              LoadingChatHistory() => const FullScreenLoader(),
                              ReconnectingChatHistory() => Column(
                                  children: [
                                    const FullScreenLoader(),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Reconnecting... (${state.attempts}/${state.maxAttempts})',
                                      style: TextStyles.sourceSans.body3.colour(
                                        UiConstants.kTextColor.withOpacity(.7),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ErrorChatHistory() => NewErrorPage(
                                  onTryAgain: () =>
                                      BlocProvider.of<ChatHistoryBloc>(
                                    context,
                                    listen: false,
                                  ).add(const LoadChatHistory()),
                                ),
                              ChatHistoryData() => _currentChatHistory.isEmpty
                                  ? const NoChats()
                                  : Padding(
                                      padding: EdgeInsets.only(top: 14.h),
                                      child: AnimatedList(
                                        scrollDirection: Axis.vertical,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        key: _listKey,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.w,
                                        ),
                                        initialItemCount:
                                            _currentChatHistory.length,
                                        itemBuilder:
                                            (context, index, animation) {
                                          if (index >=
                                              _currentChatHistory.length) {
                                            return const SizedBox.shrink();
                                          }
                                          return _buildAnimatedChatItem(
                                            _currentChatHistory[index],
                                            animation,
                                            index,
                                          );
                                        },
                                      ),
                                    ),
                            };
                          },
                        ),
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

  void _updateAnimatedList(List<ChatHistory> newChatHistory) {
    if (_listsAreEqual(_currentChatHistory, newChatHistory)) {
      return;
    }

    if (_currentChatHistory.isEmpty) {
      _currentChatHistory = List.from(newChatHistory);
      return;
    }

    final removedIndices = <int>[];
    final addedItems = <MapEntry<int, ChatHistory>>[];
    final updatedItems = <MapEntry<int, ChatHistory>>[];

    final newItemsMap = <String, int>{
      for (int i = 0; i < newChatHistory.length; i++)
        newChatHistory[i].sessionId: i,
    };

    for (int i = _currentChatHistory.length - 1; i >= 0; i--) {
      if (!newItemsMap.containsKey(_currentChatHistory[i].sessionId)) {
        removedIndices.add(i);
      }
    }

    for (final index in removedIndices) {
      final removedItem = _currentChatHistory.removeAt(index);
      _listKey.currentState?.removeItem(
        index,
        (context, animation) =>
            _buildAnimatedChatItem(removedItem, animation, index),
        duration: const Duration(milliseconds: 200),
      );
    }

    for (int i = 0; i < newChatHistory.length; i++) {
      final newItem = newChatHistory[i];
      final existingIndex = _currentChatHistory.indexWhere(
        (item) => item.sessionId == newItem.sessionId,
      );

      if (existingIndex == -1) {
        addedItems.add(MapEntry(i, newItem));
      } else {
        final existingItem = _currentChatHistory[existingIndex];
        if (!_itemsAreEqual(existingItem, newItem) || existingIndex != i) {
          updatedItems.add(MapEntry(i, newItem));
        }
      }
    }

    _currentChatHistory.clear();
    _currentChatHistory.addAll(newChatHistory);

    for (final entry in addedItems) {
      final index = entry.key;
      Timer(const Duration(milliseconds: 100), () {
        if (_listKey.currentState != null &&
            index <= _currentChatHistory.length) {
          _listKey.currentState!.insertItem(
            index,
            duration: const Duration(milliseconds: 300),
          );
        }
      });
    }

    if (updatedItems.isNotEmpty || addedItems.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  bool _listsAreEqual(List<ChatHistory> list1, List<ChatHistory> list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (!_itemsAreEqual(list1[i], list2[i])) {
        return false;
      }
    }
    return true;
  }

  bool _itemsAreEqual(ChatHistory item1, ChatHistory item2) {
    return item1.sessionId == item2.sessionId &&
        item1.lastMessage == item2.lastMessage &&
        item1.lastMessageTimestamp == item2.lastMessageTimestamp &&
        item1.unreadCount == item2.unreadCount;
  }

  Widget _buildAnimatedChatItem(
    ChatHistory data,
    Animation<double> animation,
    int index,
  ) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
      ),
      child: FadeTransition(
        opacity: animation.drive(
          Tween<double>(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
        ),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                AppState.delegate!.appState.currentAction = PageAction(
                  page: ChatsPageConfig,
                  state: PageState.addWidget,
                  widget: BlocProvider(
                    create: (context) => ChatBloc(chatRepository: locator()),
                    child: ChatScreen(
                      advisorId: data.metadata.id,
                      advisorAvatar: data.metadata.advisorProfilePhoto,
                      advisorName: data.metadata.advisorName,
                      price: data.metadata.price,
                      duration: data.metadata.duration,
                      sessionId: data.sessionId,
                      userName: data.metadata.userName,
                      userAvatar: data.metadata.userImage,
                    ),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: CircleAvatar(
                            radius: 20.r,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: NetworkImage(
                              data.metadata.userImage ?? '',
                            ),
                            child: Icon(
                              Icons.person,
                              size: 24.r,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.metadata.userName ?? '',
                                style: TextStyles.sourceSansM.body2.colour(
                                  UiConstants.kTextColor,
                                ),
                              ),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyles.sourceSansM.body4.colour(
                                  data.unreadCount > 0
                                      ? UiConstants.teal3
                                      : UiConstants.kTextColor.withOpacity(.5),
                                ),
                                child: Text(
                                  BaseUtil.formatOnlyDate(
                                    DateTime.tryParse(
                                          data.lastMessageTimestamp,
                                        ) ??
                                        DateTime.now(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: 218.w,
                                ),
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: TextStyles.sourceSans.body3.colour(
                                    data.unreadCount > 0
                                        ? UiConstants.kTextColor
                                        : UiConstants.kTextColor
                                            .withOpacity(.5),
                                  ),
                                  child: Text(
                                    data.lastMessage,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              AnimatedScale(
                                duration: const Duration(milliseconds: 200),
                                scale: data.unreadCount > 0 ? 1.0 : 0.0,
                                child: Container(
                                  width: 6.r,
                                  height: 6.r,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: UiConstants.teal3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (index < _currentChatHistory.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Divider(
                  color: UiConstants.kTextColor6.withOpacity(0.1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
