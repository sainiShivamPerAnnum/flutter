import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FelloRatingDialog extends StatelessWidget {
  final int dailogShowCount;
  FelloRatingDialog({@required this.dailogShowCount});
  double rating = 2;
  static const MAX_DAILOG_SHOW_COUNT = 3;
  @override
  Widget build(BuildContext context) {
    return FelloConfirmationDialog(
        content: Column(
          children: [
            Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Image.asset(
                  "assets/images/rating.png",
                  height: SizeConfig.screenHeight * 0.12,
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.04,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Enjoying the experience",
                    style: TextStyles.title2.bold,
                  ),
                ),
                SizedBox(height: SizeConfig.padding16),
                Text(
                  "Express you feelings by rating us on ${Platform.isAndroid ? "Playstore" : "Appstore"}",
                  textAlign: TextAlign.center,
                  style: TextStyles.body2.colour(Colors.grey),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                RatingBar.builder(
                  initialRating: rating,
                  itemCount: 5,
                  glow: false,
                  unratedColor: Colors.grey.withOpacity(0.4),
                  allowHalfRating: true,
                  itemPadding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding2),
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Icon(
                          Icons.sentiment_very_dissatisfied,
                          color: Colors.red,
                        );
                      case 1:
                        return Icon(
                          Icons.sentiment_dissatisfied,
                          color: Colors.redAccent,
                        );
                      case 2:
                        return Icon(
                          Icons.sentiment_neutral,
                          color: Colors.amber,
                        );
                      case 3:
                        return Icon(
                          Icons.sentiment_satisfied,
                          color: Colors.lightGreen,
                        );
                      case 4:
                        return Icon(
                          Icons.sentiment_very_satisfied,
                          color: Colors.green,
                        );
                      default:
                        return SizedBox();
                    }
                  },
                  onRatingUpdate: (r) {
                    print(r);
                    rating = r;
                  },
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
              ],
            ),
          ],
        ),
        accept: "Rate Now",
        reject: dailogShowCount > MAX_DAILOG_SHOW_COUNT
            ? "Don't ask again"
            : "Maybe later",
        rejectColor: dailogShowCount > MAX_DAILOG_SHOW_COUNT
            ? UiConstants.tertiarySolid
            : Colors.grey.withOpacity(0.7),
        onAccept: () async {
          await CacheManager.writeCache(
              key: 'isUserRated',
              value: true.toString(),
              type: CacheType.string);
          if (rating >= 4) {
            if (Platform.isAndroid)
              BaseUtil.launchUrl(
                  'https://play.google.com/store/apps/details?id=in.fello.felloapp');
            else
              BaseUtil.launchUrl(
                  'https://apps.apple.com/in/app/fello-save-play-win/id1558445254');
          } else {
            BaseUtil.showPositiveAlert("Thanks for rating our app",
                "We'll try to make your experience buttery smooth");
          }
          AppState.backButtonDispatcher.didPopRoute();
        },
        onReject: () async {
          await CacheManager.writeCache(
              key: 'RDShowCount',
              value: (dailogShowCount + 1).toString(),
              type: CacheType.string);
          AppState.backButtonDispatcher.didPopRoute();
        });
  }
}
