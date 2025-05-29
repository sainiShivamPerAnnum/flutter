import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/chat/bloc/chat_bloc.dart';
import 'package:felloapp/feature/chat/chat_screen.dart';
import 'package:felloapp/feature/chat_home/bloc/chat_history_bloc.dart';
import 'package:felloapp/feature/chat_home/widgets/no_chats.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatHome extends StatelessWidget {
  const ChatHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatHistoryBloc(locator())..add(const LoadChatHistory()),
      child: const _ChatHomeView(),
    );
  }
}

class _ChatHomeView extends StatefulWidget {
  const _ChatHomeView();

  @override
  State<_ChatHomeView> createState() => __ChatHomeViewState();
}

class __ChatHomeViewState extends State<_ChatHomeView> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBackgroundGrid: false,
      backgroundColor: UiConstants.bg,
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        color: UiConstants.primaryColor,
        backgroundColor: Colors.black,
        onRefresh: () async {
          BlocProvider.of<ChatHistoryBloc>(
            context,
            listen: false,
          ).add(const LoadChatHistory());
          return;
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                            'Chat',
                            style: TextStyles.sourceSansSB.body1,
                          ),
                          Text(
                            'Chat with an expert instantly',
                            style: TextStyles.sourceSans.body3.colour(
                              UiConstants.kTextColor.withOpacity(.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 14.h,
            ),
            BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
              builder: (context, state) {
                return switch (state) {
                  LoadingChatHistory() => const FullScreenLoader(),
                  ErrorChatHistory() => NewErrorPage(
                      onTryAgain: () => BlocProvider.of<ChatHistoryBloc>(
                        context,
                        listen: false,
                      ).add(const LoadChatHistory()),
                    ),
                  ChatHistoryData() => state.chatHistory.isEmpty
                      ? const NoChats()
                      : Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            itemCount: state.chatHistory.length,
                            separatorBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                child: Divider(
                                  color:
                                      UiConstants.kTextColor6.withOpacity(0.1),
                                ),
                              );
                            },
                            itemBuilder: (context, index) {
                              final data = state.chatHistory[index];
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  AppState.delegate!.appState.currentAction =
                                      PageAction(
                                    page: ChatsPageConfig,
                                    state: PageState.addWidget,
                                    widget: BlocProvider(
                                      create: (context) =>
                                          ChatBloc(chatRepository: locator()),
                                      child: ChatScreen(
                                        advisorId: data.metadata.id,
                                        advisorAvatar:
                                            data.metadata.advisorProfilePhoto,
                                        advisorName: data.metadata.advisorName,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    // Profile Picture
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 20.r,
                                          backgroundColor: Colors.grey[300],
                                          backgroundImage: NetworkImage(
                                            data.metadata.advisorProfilePhoto,
                                          ),
                                          onBackgroundImageError:
                                              (exception, stackTrace) {},
                                          child: data.metadata
                                                      .advisorProfilePhoto ==
                                                  ''
                                              ? Icon(
                                                  Icons.person,
                                                  size: 24.r,
                                                  color: Colors.grey[600],
                                                )
                                              : null,
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                data.metadata.advisorName,
                                                style: TextStyles
                                                    .sourceSansM.body2
                                                    .colour(
                                                  UiConstants.kTextColor,
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
                                                      ? UiConstants.teal3
                                                      : UiConstants.kTextColor
                                                          .withOpacity(.5),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                  maxWidth: 218.w,
                                                ),
                                                child: Text(
                                                  data.lastMessage,
                                                  style: TextStyles
                                                      .sourceSans.body3
                                                      .colour(
                                                    data.unreadCount > 0
                                                        ? UiConstants.kTextColor
                                                        : UiConstants.kTextColor
                                                            .withOpacity(.5),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              if (data.unreadCount > 0)
                                                Container(
                                                  width: 6.r,
                                                  height: 6.r,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: UiConstants.teal3,
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
          ],
        ),
      ),
    );
  }
}
