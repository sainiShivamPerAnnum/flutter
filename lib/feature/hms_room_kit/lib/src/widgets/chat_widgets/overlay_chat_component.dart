import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/layout_api/hms_room_layout.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_store.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/chat_widgets/action_buttons.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/widgets/chat_widgets/pin_chat_widget.dart';
import 'package:felloapp/util/styles/styles.dart';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tuple/tuple.dart';

///[OverlayChatComponent] is a component that is used to show the chat
class OverlayChatComponent extends StatefulWidget {
  final double? height;
  final String? role;
  const OverlayChatComponent({
    required this.role,
    super.key,
    this.height,
  });

  @override
  State<OverlayChatComponent> createState() => _OverlayChatComponentState();
}

class _OverlayChatComponentState extends State<OverlayChatComponent>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  String currentlySelectedValue = "Everyone";
  String? currentlySelectedpeerId;
  late AnimationController _animationController;
  TextEditingController messageTextController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    messageTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.initState();
    // setRecipientChipValue();
  }

  ///This function scrolls to the end of the list
  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        ),
      );
    }
  }

  ///This function updates the selected value
  void _updateValueChoose(String newValue, String? peerId) {
    currentlySelectedValue = newValue;
    currentlySelectedpeerId = peerId;
  }

  ///This function returns the message type text for public, group and private messages
  String messageTypeText(HMSMessageRecipient? hmsMessageRecipient) {
    if (hmsMessageRecipient == null) return "";
    if ((hmsMessageRecipient.recipientPeer != null) &&
        (hmsMessageRecipient.recipientRoles == null)) {
      if (hmsMessageRecipient.recipientPeer is HMSLocalPeer) {
        return "to You (DM)";
      } else {
        return "to ${hmsMessageRecipient.recipientPeer?.name} (DM)";
      }
    } else if ((hmsMessageRecipient.recipientPeer == null) &&
        (hmsMessageRecipient.recipientRoles != null)) {
      return "to ${hmsMessageRecipient.recipientRoles?.first.name} (Group)";
    }
    return "";
  }

  ///This function sends the message
  Future<void> _sendMessage(TextEditingController messageTextController) async {
    MeetingStore meetingStore = context.read<MeetingStore>();
    List<HMSRole> hmsRoles = meetingStore.roles;
    String message = messageTextController.text.trim();
    if (message.isEmpty) return;

    List<String> rolesName = <String>[];
    for (int i = 0; i < hmsRoles.length; i++) {
      rolesName.add(hmsRoles[i].name);
    }

    if (currentlySelectedValue == "Everyone") {
      meetingStore.sendBroadcastMessage(message);
    } else if (rolesName.contains(currentlySelectedValue)) {
      List<HMSRole> selectedRoles = [];
      selectedRoles.add(
        hmsRoles.firstWhere((role) => role.name == currentlySelectedValue),
      );
      meetingStore.sendGroupMessage(message, selectedRoles);
    } else if (currentlySelectedpeerId != null &&
        meetingStore.localPeer!.peerId != currentlySelectedpeerId) {
      var peer = await meetingStore.getPeer(peerId: currentlySelectedpeerId!);
      if (peer != null) {
        meetingStore.sendDirectMessage(message, peer);
      }
    }
  }

  void _toggleExpansion() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  bool _isExpanded = false;
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    _toggleExpansion();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.padding8),
      child: Selector<MeetingStore, bool>(
        selector: (_, meetingStore) => meetingStore.pinnedMessages.isNotEmpty,
        builder: (_, isPinnedMessage, __) {
          return Column(
            children: [
              PinChatWidget(
                backgroundColor: HMSThemeColors.backgroundDim.withAlpha(64),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Selector<MeetingStore, Tuple2<List<HMSMessage>, int>>(
                    selector: (_, meetingStore) => Tuple2(
                      meetingStore.messages,
                      meetingStore.messages.length,
                    ),
                    builder: (context, data, _) {
                      return _buildComments(_scrollController, data.item1);
                    },
                  ),
                  if (widget.role != 'broadcaster')
                    Padding(
                      padding: EdgeInsets.only(right: SizeConfig.padding8),
                      child: const ChatActionButtons(),
                    ),
                ],
              ),
              if ((HMSRoomLayout.chatData?.isPrivateChatEnabled ?? false) ||
                  (HMSRoomLayout.chatData?.isPublicChatEnabled ?? false) ||
                  (HMSRoomLayout.chatData?.rolesWhitelist.isNotEmpty ?? false))
                SizedBox(
                  width: SizeConfig.screenWidth! * 0.95,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.role == 'viewer-realtime')
                        SizedBox(
                          height: SizeConfig.padding8,
                        ),
                      if (widget.role == 'viewer-realtime')
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: SizeConfig.screenWidth! * 0.95,
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding12,
                          ),
                          height: _isExpanded
                              ? SizeConfig.padding120
                              : SizeConfig.padding46,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness5),
                          ),
                          child: GestureDetector(
                            onTap: _toggleExpanded,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(SizeConfig.padding8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.info,
                                        color: Colors.white,
                                        size: SizeConfig.body4,
                                      ),
                                      SizedBox(width: SizeConfig.padding8),
                                      Expanded(
                                        child: Text(
                                          'Live Video',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: SizeConfig.body4,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        _isExpanded
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                        color: Colors.white,
                                        size: SizeConfig.body2,
                                      ),
                                    ],
                                  ),
                                ),
                                _isExpanded
                                    ? Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              SizeConfig.padding8),
                                          child: const SingleChildScrollView(
                                            physics: BouncingScrollPhysics(),
                                            child: Text(
                                              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
                                              style: TextStyle(
                                                  color: Colors.white70),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ),
                      if (widget.role == 'viewer-realtime')
                        SizedBox(
                          height: SizeConfig.padding8,
                        ),
                      Selector<MeetingStore, bool>(
                        selector: (_, meetingStore) =>
                            meetingStore.chatControls["enabled"],
                        builder: (_, isChatEnabled, __) {
                          return TextField(
                            enabled: isChatEnabled,
                            controller: messageTextController,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.body4,
                            ),
                            decoration: InputDecoration(
                              hintText: isChatEnabled
                                  ? 'Add a comment'
                                  : 'Chat Paused',
                              hintStyle: const TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness12),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: SizeConfig.body3,
                                ),
                                onPressed: () {
                                  if (messageTextController.text
                                      .trim()
                                      .isEmpty) {
                                    Utilities.showToast(
                                        "Message can't be empty", 'Try Again!');
                                  }
                                  _sendMessage(messageTextController);
                                  messageTextController.clear();
                                },
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding4,
                                  horizontal: SizeConfig.padding12),
                            ),
                          );
                        },
                      ),
                      if (widget.role == 'viewer-realtime')
                        SizedBox(
                          height: SizeConfig.padding10,
                        ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildComments(
      ScrollController scrollController, List<HMSMessage>? comments) {
    void scrollToEnd() {
      if (scrollController.hasClients) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => scrollController.jumpTo(
            scrollController.position.maxScrollExtent,
          ),
        );
      }
    }

    return SizedBox(
      width: SizeConfig.padding252,
      height:
          (comments == null || comments.isEmpty) ? 0 : SizeConfig.padding200,
      child: (comments == null || comments.isEmpty)
          ? const SizedBox.shrink()
          : ListView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                scrollToEnd();
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: SizeConfig.padding10,
                      backgroundColor: Colors.black,
                      // backgroundImage:
                      // (comments[index].sender?.metadata !=
                      //             null &&
                      //         comments[index].sender?.metadata == 'CUSTOM' &&
                      //         model.myUserDpUrl != null &&
                      //         model.myUserDpUrl!.isNotEmpty)
                      //     ? CachedNetworkImageProvider(
                      //         model.myUserDpUrl!,
                      //       )
                      //     : const AssetImage(
                      //         Assets.profilePic,
                      //       ) as ImageProvider<Object>?,
                      child: comments[index].sender?.metadata != null &&
                              comments[index].sender?.metadata != 'CUSTOM'
                          ? SvgPicture.asset(
                              "assets/vectors/userAvatars/${comments[index].sender?.metadata}.svg",
                              fit: BoxFit.cover,
                            )
                          : const SizedBox(),
                    ),
                    SizedBox(
                      width: SizeConfig.padding6,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: SizeConfig.padding2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  comments[index].sender?.name ?? '',
                                  style: TextStyles.sourceSansSB.body4,
                                  maxLines: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding4,
                                  ),
                                  child: const Icon(
                                    Icons.circle,
                                    size: 4,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  timeago.format(
                                    comments[index].time,
                                  ),
                                  style: TextStyles.sourceSans.body4,
                                ),
                              ],
                            ),
                            Text(
                              comments[index].message,
                              style: TextStyles.sourceSans.body4,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
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
}
