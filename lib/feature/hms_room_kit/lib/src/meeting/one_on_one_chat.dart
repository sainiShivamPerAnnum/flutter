import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_store.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tuple/tuple.dart';

class OneOnOneChat extends StatefulWidget {
  const OneOnOneChat({super.key});

  @override
  State<OneOnOneChat> createState() => _OneOnOneChatState();
}

class _OneOnOneChatState extends State<OneOnOneChat> {
  String currentlySelectedValue = "Everyone";
  TextEditingController messageTextController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  Future<void> _sendMessage(TextEditingController messageTextController) async {
    MeetingStore meetingStore = context.read<MeetingStore>();
    List<HMSRole> hmsRoles = meetingStore.roles;
    String message = messageTextController.text.trim();
    if (message.isEmpty) return;

    List<String> rolesName = <String>[];
    for (int i = 0; i < hmsRoles.length; i++) {
      rolesName.add(hmsRoles[i].name);
    }
    meetingStore.sendBroadcastMessage(message);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    messageTextController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          _scrollController.positions.isNotEmpty
              ? _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut)
              : null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBackgroundGrid: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text('Meeting Chat', style: TextStyles.rajdhaniSB.body1),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding18,
        ).copyWith(bottom: SizeConfig.padding40),
        child: Column(
          children: [
            Expanded(
              child: Selector<MeetingStore, Tuple2<List<HMSMessage>, int>>(
                selector: (_, meetingStore) => Tuple2(
                  meetingStore.messages,
                  meetingStore.messages.length,
                ),
                builder: (context, data, _) {
                  _scrollToEnd();
                  return _buildComments(_scrollController, data.item1);
                },
              ),
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
                    hintText: isChatEnabled ? 'Add a comment' : 'Chat Paused',
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: SizeConfig.body3,
                      ),
                      onPressed: () {
                        if (messageTextController.text.trim().isEmpty) {
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
          ],
        ),
      ),
    );
  }

  Widget _buildComments(
    ScrollController scrollController,
    List<HMSMessage>? comments,
  ) {
    return SizedBox(
      child: (comments == null || comments.isEmpty)
          ? const SizedBox.shrink()
          : Expanded(
              flex: 3,
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        var metaData = jsonDecode(
                          comments[index].sender?.metadata != ''
                              ? comments[index].sender?.metadata ??
                                  '{"avatar": "","dpurl":""}'
                              : '{"avatar": "","dpurl":""}',
                        );
                        return Padding(
                          padding:
                              EdgeInsets.only(bottom: SizeConfig.padding18),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: SizeConfig.padding10,
                                backgroundColor: Colors.black,
                                child: metaData != null &&
                                        metaData['avatar'] != '' &&
                                        metaData['avatar'] != 'CUSTOM'
                                    ? ClipOval(
                                        child: SizedBox(
                                          width: 2 * SizeConfig.padding10,
                                          height: 2 * SizeConfig.padding10,
                                          child: SvgPicture.asset(
                                            "assets/vectors/userAvatars/${metaData['avatar']}.svg",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : (metaData != null &&
                                            metaData['avatar'] != '' &&
                                            metaData!['avatar'] == 'CUSTOM' &&
                                            metaData!['dpurl'] != '')
                                        ? ClipOval(
                                            child: SizedBox(
                                              width: 2 * SizeConfig.padding10,
                                              height: 2 * SizeConfig.padding10,
                                              child: CachedNetworkImage(
                                                imageUrl: metaData['dpurl'],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : ClipOval(
                                            child: SizedBox(
                                              width: 2 * SizeConfig.padding10,
                                              height: 2 * SizeConfig.padding10,
                                              child: Image.asset(
                                                Assets.profilePic,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                              ),
                              SizedBox(
                                width: SizeConfig.padding6,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: SizeConfig.padding2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            comments[index].sender?.name ?? '',
                                            style:
                                                TextStyles.sourceSansSB.body4,
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
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
