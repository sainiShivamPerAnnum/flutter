import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/chat/chat_models.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/chat/bloc/chat_bloc.dart';
import 'package:felloapp/feature/chat/bloc/chat_event.dart';
import 'package:felloapp/feature/chat/bloc/chat_state.dart';
import 'package:felloapp/feature/chat/widgets/animated_divider.dart';
import 'package:felloapp/feature/chat/widgets/chat_input.dart';
import 'package:felloapp/feature/chat/widgets/chat_shimmer.dart';
import 'package:felloapp/feature/chat/widgets/chat_welcome.dart';
import 'package:felloapp/feature/chat/widgets/message_bubble.dart';
import 'package:felloapp/feature/chat/widgets/typing_indicator.dart';
import 'package:felloapp/feature/expert/bloc/cart_bloc.dart';
import 'package:felloapp/feature/expert/widgets/scroll_to_index.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  final String advisorId;
  final String? advisorName;
  final String? advisorAvatar;
  final String? price;
  final String? duration;
  final String? sessionId;
  final String? userName;
  final String? userAvatar;

  const ChatScreen({
    required this.advisorId,
    required this.sessionId,
    this.advisorName,
    this.advisorAvatar,
    this.price,
    this.duration,
    this.userName,
    this.userAvatar,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AutoScrollController _scrollController = AutoScrollController();
  final FcmListener _fcmListener = locator<FcmListener>();
  bool _isNearBottom = true;
  final isAdvisor = locator<UserService>().baseUser!.isAdvisor ?? false;
  final String? uid = locator<UserService>().baseUser!.uid;
  bool _isUserScrolling = false;
  // double? _lastScrollOffset;
  Timer? _scrollDebounceTimer;
  String? _lastProcessedUnreadId;
  bool _hasShownUnreadDivider = false;
  bool _shouldShowDivider = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatBloc>().add(
            InitializeChat(
              advisorId: widget.advisorId,
              sessionId: widget.sessionId,
            ),
          );
    });
    _fcmListener.setCurrentChatSession(widget.sessionId);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _fcmListener.setCurrentChatSession(null);
    _scrollDebounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final isNearBottom = _scrollController.offset <= 5;
      _isUserScrolling = !isNearBottom;
      if (_isNearBottom != isNearBottom) {
        setState(() {
          _isNearBottom = isNearBottom;
        });
      }
      if (isNearBottom) {
        _hasShownUnreadDivider = false;
        _shouldShowDivider = false;
        context.read<ChatBloc>().add(MarkAllAsRead());
      }
    }
  }

  void _scrollToUnreadMessages(ChatState state) {
    if (state.firstUnreadMessageId == _lastProcessedUnreadId) {
      return;
    }
    _scrollDebounceTimer?.cancel();
    _scrollDebounceTimer = Timer(const Duration(milliseconds: 200), () {
      if (state.firstUnreadMessageId != null &&
          state.firstUnreadMessageId != 'null' &&
          !_hasShownUnreadDivider) {
        setState(() {
          _shouldShowDivider = true;
          _hasShownUnreadDivider = true;
        });

        if (!_isUserScrolling && _isNearBottom) {
          final unreadIndex = state.messages.indexWhere(
            (msg) => msg.id == state.firstUnreadMessageId,
          );
          if (unreadIndex != -1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                final reversedIndex = state.messages.length - 1 - unreadIndex;
                _scrollController.scrollToIndex(
                  reversedIndex,
                  preferPosition: AutoScrollPosition.end,
                  duration: const Duration(milliseconds: 50),
                );
              }
            });
          }
        }
      }
      _lastProcessedUnreadId = state.firstUnreadMessageId;
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _handleSendMessage(String content, MessageType messagetype) {
    context.read<ChatBloc>().add(
          SendMessage(
            content: content,
            messageType: messagetype,
          ),
        );
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: UiConstants.bg,
      showBackgroundGrid: false,
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
          if (state.messages.isNotEmpty) {
            if (state.showUnreadBanner &&
                state.unreadMessageCount > 0 &&
                state.firstUnreadMessageId != null &&
                state.firstUnreadMessageId != 'null' &&
                !_hasShownUnreadDivider) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _shouldShowDivider = true;
                    _hasShownUnreadDivider = true;
                  });
                }
              });
            }
            _scrollToUnreadMessages(state);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildAppBar(context, widget.userName, widget.userAvatar),
              if (!state.isSocketConnected &&
                  state.loadingState != ChatLoadingState.initial)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.orange.withOpacity(0.15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.orange.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getConnectionStatusText(state.loadingState),
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              if (state.showUnreadBanner && state.unreadMessageCount > 0)
                _buildUnreadBanner(state),
              // Chat content
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      // Loading state for initial setup
                      if (state.loadingState == ChatLoadingState.initial ||
                          state.loadingState ==
                              ChatLoadingState.creatingSession)
                        const Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ChatShimmerLoader(),
                              ],
                            ),
                          ),
                        )
                      else if (state.loadingState == ChatLoadingState.error)
                        Expanded(
                          child: NewErrorPage(
                            onTryAgain: () {
                              context.read<ChatBloc>().add(
                                    InitializeChat(
                                      advisorId: widget.advisorId,
                                      sessionId: widget.sessionId,
                                    ),
                                  );
                            },
                          ),
                        )
                      else if (state.messages.isEmpty)
                        Expanded(
                          child: NewChatWelcome(
                            advisorName:
                                state.advisorName ?? widget.advisorName ?? '',
                            onOptionSelected: (messageText) {
                              _handleSendMessage(
                                messageText,
                                isAdvisor
                                    ? MessageType.advisor
                                    : MessageType.user,
                              );
                            },
                            onWithdrawalSupportTap: () {
                              Haptic.vibrate();
                              AppState.delegate!.appState.currentAction =
                                  PageAction(
                                state: PageState.addPage,
                                page: FreshDeskHelpPageConfig,
                              );
                            },
                          ),
                        )
                      else
                        // Messages list
                        Expanded(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              if (notification is ScrollUpdateNotification) {
                                // if (_lastScrollOffset != null &&
                                //     !_isNearBottom &&
                                //     notification.metrics.pixels !=
                                //         _lastScrollOffset) {
                                //   WidgetsBinding.instance
                                //       .addPostFrameCallback((_) {
                                //     if (_scrollController.hasClients &&
                                //         _lastScrollOffset != null) {
                                //       _scrollController
                                //           .jumpTo(_lastScrollOffset!);
                                //     }
                                //   });
                                // }
                                // _lastScrollOffset = notification.metrics.pixels;
                              }
                              return false;
                            },
                            child: ListView.builder(
                              controller: _scrollController,
                              reverse: true,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              itemCount: state.messages.length,
                              itemBuilder: (context, index) {
                                final reversedIndex =
                                    state.messages.length - 1 - index;
                                final message = state.messages[reversedIndex];
                                final isFirstUnread =
                                    message.id == state.firstUnreadMessageId;

                                final shouldShowDividerForThisMessage =
                                    isFirstUnread &&
                                        _shouldShowDivider &&
                                        state.showUnreadBanner;
                                return AutoScrollTag(
                                  key: ValueKey(index),
                                  controller: _scrollController,
                                  index: index,
                                  child: Column(
                                    children: [
                                      AnimatedUnreadDivider(
                                        isVisible:
                                            shouldShowDividerForThisMessage,
                                      ),
                                      MessageBubble(
                                        key: ValueKey(message.id),
                                        isUserAdvisor: isAdvisor,
                                        userId: uid,
                                        message: message,
                                        advisorProfilePhoto:
                                            widget.advisorAvatar,
                                        advisorName: state.advisorName ??
                                            widget.advisorName,
                                        price: widget.price,
                                        duration: widget.duration,
                                        advisorId: widget.advisorId,
                                        onBookConsultation: (c) {
                                          BaseUtil.openBookAdvisorSheet(
                                            advisorId: c.id,
                                            advisorName: c.advisorName,
                                            advisorImage: c.advisorProfileImage,
                                            isEdit: false,
                                          );
                                          context.read<CartBloc>().add(
                                                AddToCart(
                                                  advisor: Expert(
                                                    advisorId: c.id,
                                                    name: c.advisorName,
                                                    experience: '',
                                                    rating: 0,
                                                    expertise: '',
                                                    qualifications: '',
                                                    rate: 0,
                                                    rateNew: '',
                                                    image:
                                                        c.advisorProfileImage,
                                                    isFree: false,
                                                  ),
                                                ),
                                              );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      if (state.shouldShowTypingIndicator)
                        const SimpleTypingIndicator(),

                      ChatInput(
                        onSendMessage: (message) => _handleSendMessage(
                          message,
                          isAdvisor ? MessageType.advisor : MessageType.user,
                        ),
                        isEnabled: state.isReadyForMessaging,
                        isLoading: state.isSendingMessage,
                        placeholder: 'Type a message...',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUnreadBanner(ChatState state) {
    return GestureDetector(
      onTap: () async {
        if (state.firstUnreadMessageId != null) {
          final unreadIndex = state.messages.indexWhere(
            (msg) => msg.id == state.firstUnreadMessageId,
          );
          if (unreadIndex != -1) {
            final reversedIndex = state.messages.length - 1 - unreadIndex;
            await _scrollController.scrollToIndex(
              reversedIndex,
              preferPosition: AutoScrollPosition.middle,
              duration: const Duration(milliseconds: 500),
            );
          }
        }
        await Future.delayed(
          const Duration(milliseconds: 500),
          () {
            setState(() {
              _hasShownUnreadDivider = false;
              _shouldShowDivider = false;
            });
            context.read<ChatBloc>().add(MarkAllAsRead());
          },
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: const Color(0xFF01656B).withOpacity(0.3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.keyboard_arrow_down,
              color: UiConstants.teal3,
              size: 16.sp,
            ),
            const SizedBox(width: 8),
            Text(
              '${state.unreadMessageCount} unread message${state.unreadMessageCount > 1 ? 's' : ''}',
              style: TextStyles.sourceSans.body4.colour(
                UiConstants.teal3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getConnectionStatusText(ChatLoadingState loadingState) {
    switch (loadingState) {
      case ChatLoadingState.creatingSession:
        return 'Creating session...';
      case ChatLoadingState.joiningRoom:
        return 'Joining chat...';
      case ChatLoadingState.loadingHistory:
        return 'Loading chat history...';
      case ChatLoadingState.error:
        return 'Reconnecting...';
      case ChatLoadingState.reconnecting:
        return 'Reconnecting...';
      default:
        return 'Connecting...';
    }
  }

  Widget _buildAppBar(
    BuildContext context,
    String? userName,
    String? userAvatar,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
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
            height: MediaQuery.of(context).padding.top,
          ),
          SizedBox(
            height: SizeConfig.padding10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => AppState.backButtonDispatcher!.didPopRoute(),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    final displayName =
                        userName ?? state.advisorName ?? widget.advisorName;
                    return Row(
                      children: [
                        Container(
                          width: 28.w,
                          height: 28.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: state.isSocketConnected
                                  ? const Color(0xFF2D7D7D)
                                  : Colors.grey.shade600,
                              width: 2.w,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: userName != null
                                ? widget.userAvatar != null
                                    ? Image.network(
                                        widget.userAvatar!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return _buildDefaultAvatar();
                                        },
                                      )
                                    : _buildDefaultAvatar()
                                : widget.advisorAvatar != null
                                    ? Image.network(
                                        widget.advisorAvatar!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return _buildDefaultAvatar();
                                        },
                                      )
                                    : _buildDefaultAvatar(),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName ?? '',
                              style: TextStyles.sourceSansSB.body1,
                            ),
                            // Row(
                            //   children: [
                            // Container(
                            //   width: 8.w,
                            //   height: 8.h,
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     color: state.isSocketConnected
                            //         ? const Color(0xFF4CAF50)
                            //         : Colors.grey.shade500,
                            //   ),
                            // ),
                            // SizedBox(width: 6.w),
                            // Text(
                            //   state.isSocketConnected
                            //       ? (state.isHumanMode
                            //           ? 'Online'
                            //           : 'AI Assistant')
                            //       : 'Connecting...',
                            //   style: TextStyle(
                            //     color: Colors.white.withOpacity(0.7),
                            //     fontSize: 12.sp,
                            //     fontWeight: FontWeight.w400,
                            //   ),
                            // ),
                            // ],
                            // ),
                          ],
                        ),
                        const Spacer(),
                        if (userName == null)
                          IconButton(
                            onPressed: () {
                              context.read<CartBloc>().add(
                                    AddToCart(
                                      advisor: Expert(
                                        advisorId: widget.advisorId,
                                        name: widget.advisorName ?? '',
                                        experience: '',
                                        rating: 0,
                                        expertise: '',
                                        qualifications: '',
                                        rate: 0,
                                        rateNew: '',
                                        image: widget.advisorAvatar ?? '',
                                        isFree: false,
                                      ),
                                    ),
                                  );
                              BaseUtil.openBookAdvisorSheet(
                                advisorId: widget.advisorId,
                                advisorName: widget.advisorName ?? '',
                                advisorImage: widget.advisorAvatar ?? '',
                                isEdit: false,
                              );
                            },
                            icon: Icon(
                              Icons.call_sharp,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding10,
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF2D7D7D),
      ),
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: 14.sp,
      ),
    );
  }
}
