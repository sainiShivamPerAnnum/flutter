import 'dart:io';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveCardWidget extends StatelessWidget {
  final String status;
  final String title;
  final String subTitle;
  final String author;
  final String category;
  final String bgImage;
  final int? liveCount;
  final String? duration;
  final String? startTime;
  final String? advisorCode;
  final String? viewerCode;

  const LiveCardWidget({
    required this.status,
    required this.title,
    required this.subTitle,
    required this.author,
    required this.category,
    required this.bgImage,
    super.key,
    this.liveCount,
    this.duration,
    this.startTime,
    this.advisorCode,
    this.viewerCode,
  });
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
      onTap: () async {
        if (status == 'live') {
          if (viewerCode != null) {
            final String? name =
                locator<UserService>().baseUser!.kycName!.isNotEmpty
                    ? locator<UserService>().baseUser!.kycName!
                    : locator<UserService>().baseUser!.name!.isNotEmpty
                        ? locator<UserService>().baseUser!.name
                        : locator<UserService>().baseUser!.username;
                        final userId =  locator<UserService>().baseUser!.uid;
            bool res = await getPermissions();
            if (res) {
              AppState.delegate!.appState.currentAction = PageAction(
                page: LivePreviewPageConfig,
                state: PageState.addWidget,
                widget: HMSPrebuilt(
                  roomCode: viewerCode,
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
        constraints: BoxConstraints(maxWidth: SizeConfig.padding300),
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
                      image: NetworkImage(bgImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (status == 'live') ...[
                  buildLiveIndicator(),
                  buildPlayIcon(),
                ],
                if (status == 'upcoming') buildUpcomingIndicator(),
                if (status == 'recent') buildRecentIndicator(),
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
                      category.toUpperCase(),
                      style: TextStyles.sourceSansSB.body4.colour(
                        UiConstants.kblue1,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding4),
                  // Title
                  Text(
                    title,
                    style: TextStyles.sourceSansSB.body2.colour(
                      UiConstants.kTextColor,
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding4),

                  // Subtitle (time started or duration)
                  Text(
                    subTitle,
                    style: TextStyles.sourceSans.body4.colour(
                      UiConstants.kTextColor5,
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding20),

                  // Author's name
                  Text(
                    author,
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
                if (liveCount != null)
                  Icon(
                    Icons.visibility,
                    color: Colors.white,
                    size: SizeConfig.body4,
                  ),
                if (liveCount != null)
                  SizedBox(
                    width: SizeConfig.padding4,
                  ),
                if (liveCount != null)
                  Text(
                    liveCount! >= 1000
                        ? '${liveCount! ~/ 1000}K'
                        : '$liveCount',
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
          'STARTS IN ${_calculateStartTimeDifference()}',
          style: TextStyles.sourceSansSB.body4.colour(
            UiConstants.titleTextColor,
          ),
        ),
      ),
    );
  }

  String _calculateStartTimeDifference() {
    if (startTime == null) return '';
    final now = DateTime.now();
    final start = DateTime.parse(startTime!);
    final difference = start.difference(now);
    return formatDuration(difference);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
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
          '$duration MINS',
          style: TextStyles.sourceSansSB.body4.colour(
            UiConstants.titleTextColor,
          ),
        ),
      ),
    );
  }
}
