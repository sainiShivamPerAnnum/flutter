import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_dialog.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:felloapp/util/custom_logger.dart';

class FelloRatingDialog extends StatefulWidget {
  final int dailogShowCount;
  FelloRatingDialog({@required this.dailogShowCount});
  static const MAX_DAILOG_SHOW_COUNT = 3;

  @override
  State<FelloRatingDialog> createState() => _FelloRatingDialogState();
}

class _FelloRatingDialogState extends State<FelloRatingDialog> {
  double rating = 0;
  Logger logger = locator<CustomLogger>();
  bool showEmptyRatingError = false;
  bool showButtons = true;

  showLoading(bool value) {
    setState(() {
      showButtons = !value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FelloDialog(
      content: Column(
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
              "Enjoying Fello?",
              style: TextStyles.title2.bold,
            ),
          ),
          SizedBox(height: SizeConfig.padding16),
          Text(
            "We are constantly improving the app and your feedback would be really valuable.",
            textAlign: TextAlign.center,
            style: TextStyles.body2.colour(Colors.grey),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.025),
          Container(
            width: SizeConfig.screenWidth,
            alignment: Alignment.center,
            child: RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              glowColor: UiConstants.tertiarySolid.withOpacity(0.5),
              unratedColor: Colors.grey.withOpacity(0.5),
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemSize: SizeConfig.screenWidth / 10,
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
          SizedBox(height: SizeConfig.screenHeight * 0.025),
          if (showEmptyRatingError)
            Padding(
              padding: EdgeInsets.all(SizeConfig.padding4),
              child: Text(
                "Please select a rating",
                style: TextStyles.body3.bold.colour(UiConstants.tertiarySolid),
              ),
            ),
          SizedBox(height: SizeConfig.padding12),
          !showButtons
              ? Container(
                  alignment: Alignment.center,
                  height: SizeConfig.padding64,
                  child: Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: UiConstants.primaryColor,
                      backgroundColor: UiConstants.tertiarySolid,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      width: SizeConfig.screenWidth,
                      child: FelloButtonLg(
                        child: Text(
                          "Rate",
                          style: TextStyles.body3.bold.colour(Colors.white),
                        ),
                        color: UiConstants.primaryColor,
                        height: SizeConfig.padding54,
                        onPressed: () async {
                          if (rating == 0) {
                            setState(() {
                              showEmptyRatingError = true;
                            });
                            return;
                          }
                          showLoading(true);
                          try {
                            await CacheManager.writeCache(
                                key: CacheManager.CACHE_RATING_IS_RATED,
                                value: FcmHandler.COMMAND_USER_PRIZE_WIN,
                                type: CacheType.string);
                          } catch (e) {
                            showLoading(false);
                            logger.e(e.toString());
                            logger.e(
                                "Unable to save the rating completed preference");
                          }
                          if (rating >= 4) {
                            final InAppReview inAppReview =
                                InAppReview.instance;

                            try {
                              if (await inAppReview.isAvailable()) {
                                inAppReview.requestReview();
                              } else {
                                logger.d(
                                    "In app review not available, opening native application store");
                                inAppReview.openStoreListing(
                                    appStoreId: '1558445254');
                              }
                            } catch (e) {
                              logger.e(e.toString());
                              if (Platform.isAndroid)
                                BaseUtil.launchUrl(
                                    'https://play.google.com/store/apps/details?id=in.fello.felloapp');
                              else
                                BaseUtil.launchUrl(
                                    'https://apps.apple.com/in/app/fello-save-play-win/id1558445254');
                            }
                          } else {
                            BaseUtil.showPositiveAlert(
                                "Thank you for your feedback",
                                "We hope to serve you better");
                          }
                          AppState.backButtonDispatcher.didPopRoute();
                        },
                      ),
                    ),
                    SizedBox(height: SizeConfig.padding12),
                    Container(
                      width: SizeConfig.screenWidth,
                      child: FelloButtonLg(
                        child: Text(
                          widget.dailogShowCount >
                                  FelloRatingDialog.MAX_DAILOG_SHOW_COUNT
                              ? "Don't ask again"
                              : "Maybe later",
                          style: TextStyles.body3.bold,
                        ),
                        color: widget.dailogShowCount >
                                FelloRatingDialog.MAX_DAILOG_SHOW_COUNT
                            ? UiConstants.tertiarySolid
                            : Colors.grey.withOpacity(0.5),
                        height: SizeConfig.padding54,
                        onPressed: () async {
                          await CacheManager.writeCache(
                              key: CacheManager.CACHE_RATING_DIALOG_OPEN_COUNT,
                              value: (widget.dailogShowCount + 1).toString(),
                              type: CacheType.string);
                          AppState.backButtonDispatcher.didPopRoute();
                        },
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
