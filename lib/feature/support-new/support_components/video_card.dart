import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/ui/pages/static/youtube_player_view.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class VideoCardWidget extends StatelessWidget {
  final String title;
  final String bgImage;
  final String duration;
  final String videoLink;

  const VideoCardWidget({
    required this.title,
    required this.bgImage,
    required this.duration,
    required this.videoLink,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        locator<AnalyticsService>().track(
          eventName: title,
        );
        BaseUtil.openDialog(
          isBarrierDismissible: true,
          addToScreenStack: true,
          hapticVibrate: true,
          barrierColor: Colors.black54,
          content: Dialog(
            child: YoutubePlayerView(url: videoLink),
          ),
        );
      },
      child: Container(
        width: SizeConfig.padding300,
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
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.play_circle_filled,
                    color: Colors.white,
                    size: SizeConfig.title50,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(SizeConfig.padding16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.sourceSansSB.body2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: SizeConfig.padding6),
                  Text(
                    duration,
                    style: TextStyles.sourceSansSB.body4
                        .colour(UiConstants.kTabBorderColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
