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
import 'package:in_app_review/in_app_review.dart';
import 'package:logger/logger.dart';

class FelloRatingDialog extends StatelessWidget {
  final int dailogShowCount;
  FelloRatingDialog({@required this.dailogShowCount});
  double rating = 4;
  static const MAX_DAILOG_SHOW_COUNT = 3;
  @override
  Widget build(BuildContext context) {
    return FelloConfirmationDialog(
        content: Column(
          children: [
            Column(
              children: [
                SizedBox(height: SizeConfig.padding20),
                SvgPicture.asset(
                  "assets/vectors/rating.svg",
                  height: SizeConfig.screenHeight * 0.14,
                ),
                SizedBox(
                  height: SizeConfig.padding20,
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
                Container(
                  width: SizeConfig.screenWidth,
                  alignment: Alignment.center,
                  child: RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    glowColor: UiConstants.tertiarySolid.withOpacity(0.5),
                    unratedColor: Colors.grey.withOpacity(0.5),
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemSize: SizeConfig.screenWidth / 8,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: UiConstants.tertiarySolid,
                    ),
                    onRatingUpdate: (r) {
                      print(r);
                      rating = r;
                    },
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
              ],
            ),
          ],
        ),
        accept: "Rate",
        reject: dailogShowCount > MAX_DAILOG_SHOW_COUNT
            ? "Don't ask again"
            : "Maybe later",
        rejectColor: dailogShowCount > MAX_DAILOG_SHOW_COUNT
            ? UiConstants.tertiarySolid
            : Colors.grey.withOpacity(0.5),
        onAccept: () async {
          await CacheManager.writeCache(
              key: CacheManager.CACHE_RATING_IS_RATED,
              value: true.toString(),
              type: CacheType.string);
          if (rating >= 3.5) {
            final InAppReview inAppReview = InAppReview.instance;

            try {
              if (await inAppReview.isAvailable()) {
                inAppReview.requestReview();
              } else {
                Logger().d(
                    "In app review not available, opening native application store");
                inAppReview.openStoreListing(appStoreId: '1558445254');
              }
            } catch (e) {
              Logger().e(e.toString());
              if (Platform.isAndroid)
                BaseUtil.launchUrl(
                    'https://play.google.com/store/apps/details?id=in.fello.felloapp');
              else
                BaseUtil.launchUrl(
                    'https://apps.apple.com/in/app/fello-save-play-win/id1558445254');
            }
          } else {
            BaseUtil.showPositiveAlert("Thanks for rating our app",
                "We'll try to make your experience buttery smooth");
          }
          AppState.backButtonDispatcher.didPopRoute();
        },
        onReject: () async {
          await CacheManager.writeCache(
              key: CacheManager.CACHE_RATING_DIALOG_OPEN_COUNT,
              value: (dailogShowCount + 1).toString(),
              type: CacheType.string);
          AppState.backButtonDispatcher.didPopRoute();
        });
  }
}
