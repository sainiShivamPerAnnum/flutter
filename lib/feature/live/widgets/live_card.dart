import 'dart:async';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timeago/timeago.dart' as timeago;

class LiveCardWidget extends StatefulWidget {
  final String status;
  final String title;
  final String subTitle;
  final String author;
  final String category;
  final String bgImage;
  final int? liveCount;
  final String? duration;
  final String? startTime;
  final String advisorCode;
  final String? viewerCode;
  final VoidCallback? onTap;
  final double? maxWidth;
  final String? eventId;

  const LiveCardWidget({
    required this.status,
    required this.title,
    required this.subTitle,
    required this.author,
    required this.category,
    required this.bgImage,
    required this.advisorCode,
    super.key,
    this.liveCount,
    this.duration,
    this.startTime,
    this.viewerCode,
    this.onTap,
    this.maxWidth,
    this.eventId,
  });

  @override
  State<LiveCardWidget> createState() => _LiveCardWidgetState();
}

class _LiveCardWidgetState extends State<LiveCardWidget> {
  Timer? _timer;
  String _remainingTime = '';
  @override
  void initState() {
    super.initState();
    if (widget.status == 'upcoming' && widget.startTime != null) {
      _startCountdown();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _updateRemainingTime(); // Initial update
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    final start = DateTime.parse(widget.startTime!);
    final difference = start.difference(now);

    if (difference.isNegative) {
      // Stop the timer if the start time has passed
      _timer?.cancel();
      setState(() {
        _remainingTime = 'SOON';
      });
    } else {
      setState(() {
        _remainingTime = "IN ${_formatDuration(difference)}";
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  Future<bool> getPermissions() async {
    if (Platform.isIOS) return true;
    await Permission.bluetoothConnect.request();
    await Permission.microphone.request();
    await Permission.camera.request();

    while (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }

    while (await Permission.microphone.isDenied) {
      await Permission.microphone.request();
    }

    while (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ??
          () async {
            if (widget.status == 'live') {
              if (widget.viewerCode != null) {
                final String? name =
                    locator<UserService>().baseUser!.kycName!.isNotEmpty
                        ? locator<UserService>().baseUser!.kycName!
                        : locator<UserService>().baseUser!.name!.isNotEmpty
                            ? locator<UserService>().baseUser!.name
                            : locator<UserService>().baseUser!.username;
                final userId = locator<UserService>().baseUser!.uid;
                bool res = await getPermissions();
                if (res) {
                  AppState.delegate!.appState.currentAction = PageAction(
                    page: LivePreviewPageConfig,
                    state: PageState.addWidget,
                    widget: HMSPrebuilt(
                      roomCode: widget.viewerCode,
                      // id: widget.eventId,
                      onLeave: () async{
                          await AppState.backButtonDispatcher!.didPopRoute();
                        },
                      advisorId: widget.advisorCode,
                      title: widget.title,
                      description: widget.subTitle,
                      options: HMSPrebuiltOptions(
                        userName: name,
                        userId: userId,
                      ),
                    ),
                  );
                }
              }
            }
          },
      child: Container(
        constraints:
            BoxConstraints(maxWidth: widget.maxWidth ?? SizeConfig.padding300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness8),
          color: UiConstants.greyVarient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: double.infinity,
                  height: SizeConfig.padding152,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.roundness8),
                      topRight: Radius.circular(SizeConfig.roundness8),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(widget.bgImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (widget.status == 'live') ...[
                  buildLiveIndicator(),
                  buildPlayIcon(),
                ],
                if (widget.status == 'upcoming') buildUpcomingIndicator(),
                if (widget.status == 'recent') buildRecentIndicator(),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(SizeConfig.padding16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(SizeConfig.padding4),
                    decoration: BoxDecoration(
                      color: UiConstants.kblue2.withOpacity(.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.category.toUpperCase(),
                      style: TextStyles.sourceSansSB.body4.colour(
                        UiConstants.kblue1,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding4),
                  // Title
                  Text(
                    widget.title,
                    style: TextStyles.sourceSansSB.body2.colour(
                      UiConstants.kTextColor,
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding4),

                  if (widget.status == 'upcoming')
                    Text(
                      'Starts on ${BaseUtil.formatDateTime(
                        DateTime.parse(
                          widget.startTime!,
                        ),
                      )}',
                      style: TextStyles.sourceSans.body4.colour(
                        UiConstants.kTextColor5,
                      ),
                    )
                  else if (widget.status == 'recent')
                    Text(
                      '${widget.liveCount} views  •  ${timeago.format(
                        DateTime.tryParse(widget.startTime ?? '') ??
                            DateTime.now(),
                      )}',
                      style: TextStyles.sourceSans.body4.colour(
                        UiConstants.kTextColor5,
                      ),
                    )
                  else
                    Text(
                      'Started at ${BaseUtil.formatTime(
                        DateTime.tryParse(
                              widget.startTime ?? '',
                            ) ??
                            DateTime.now(),
                      )}',
                      style: TextStyles.sourceSans.body4.colour(
                        UiConstants.kTextColor5,
                      ),
                    ),
                  SizedBox(height: SizeConfig.padding20),

                  // Author's name
                  Text(
                    widget.author,
                    style: TextStyles.sourceSans.body4.colour(
                      UiConstants.kTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLiveIndicator() {
    return Positioned(
      bottom: SizeConfig.padding10,
      left: SizeConfig.padding10,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding8,
              vertical: SizeConfig.padding4,
            ),
            decoration: BoxDecoration(
              color: UiConstants.kred1,
              borderRadius: BorderRadius.circular(
                SizeConfig.roundness5,
              ),
            ),
            child: Text(
              'LIVE',
              style: TextStyles.sourceSansSB.body4.colour(
                UiConstants.titleTextColor,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: SizeConfig.padding4),
            decoration: BoxDecoration(
              color: UiConstants.kTextColor4,
              borderRadius: BorderRadius.circular(
                SizeConfig.roundness5,
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding8,
              vertical: SizeConfig.padding4,
            ),
            child: Row(
              children: [
                if (widget.liveCount != null)
                  Icon(
                    Icons.visibility,
                    color: Colors.white,
                    size: SizeConfig.body4,
                  ),
                if (widget.liveCount != null)
                  SizedBox(
                    width: SizeConfig.padding4,
                  ),
                if (widget.liveCount != null)
                  Text(
                    widget.liveCount! >= 1000
                        ? '${widget.liveCount! ~/ 1000}K'
                        : '${widget.liveCount}',
                    style: TextStyles.sourceSansSB.body4.colour(
                      UiConstants.titleTextColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPlayIcon() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.padding8),
        decoration: BoxDecoration(
          color: UiConstants.kTextColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.play_arrow_rounded,
          color: Colors.white,
          size: SizeConfig.iconSize5,
        ),
      ),
    );
  }

  Widget buildUpcomingIndicator() {
    return Positioned(
      bottom: SizeConfig.padding10,
      left: SizeConfig.padding10,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding8,
          vertical: SizeConfig.padding4,
        ),
        decoration: BoxDecoration(
          color: UiConstants.kTextColor4,
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
        ),
        child: Text(
          'STARTS $_remainingTime',
          style: TextStyles.sourceSansSB.body4.colour(
            UiConstants.titleTextColor,
          ),
        ),
      ),
    );
  }

  Widget buildRecentIndicator() {
    return Positioned(
      bottom: SizeConfig.padding10,
      left: SizeConfig.padding10,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding8,
          vertical: SizeConfig.padding4,
        ),
        decoration: BoxDecoration(
          color: UiConstants.kTextColor4,
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
        ),
        child: Text(
          '${widget.duration} MINS',
          style: TextStyles.sourceSansSB.body4.colour(
            UiConstants.titleTextColor,
          ),
        ),
      ),
    );
  }
}
