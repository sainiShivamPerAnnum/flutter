import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/constants/strings.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class FelloInAppReview extends HookWidget {
  const FelloInAppReview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emojis = useState([
      "😞",
      "😒",
      "😐",
      "🙂",
      "😍",
    ]);
    final selected = useState(-1);
    final submitted = useState(false);
    final textController = useTextEditingController();

    if (submitted.value) {
      return FelloInAppReviewSuccess(
        emoji: emojis.value[selected.value],
        showButton: selected.value > 2,
      );
    }

    return WillPopScope(
      onWillPop: () async {
        AppState.backButtonDispatcher?.didPopRoute();
        return true;
      },
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
          decoration: BoxDecoration(
            color: const Color(0xff39393C),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.padding16),
              topRight: Radius.circular(SizeConfig.padding16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeConfig.padding16,
              ),
              Container(
                width: SizeConfig.padding90 + SizeConfig.padding6,
                height: SizeConfig.padding4,
                decoration: BoxDecoration(
                  color: const Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(SizeConfig.padding4),
                ),
              ),
              SizedBox(
                height: SizeConfig.padding24,
              ),
              Text(
                "How was your experience?",
                textAlign: TextAlign.center,
                style: TextStyles.sourceSansSB.title5.colour(Colors.white),
              ),
              SizedBox(
                height: SizeConfig.padding24,
              ),
              Text(
                "Your feedback would help make Fello better!",
                textAlign: TextAlign.center,
                style: TextStyles.sourceSans.body2.colour(
                  Colors.white.withOpacity(0.6),
                ),
              ),
              SizedBox(
                height: SizeConfig.padding24,
              ),
              SizedBox(
                height: SizeConfig.padding54,
                child: ListView.separated(
                  itemCount: emojis.value.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Emoji(
                      emoji: emojis.value[index],
                      onTap: () {
                        selected.value = index;
                      },
                      selected: selected.value == index,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: SizeConfig.padding1,
                    );
                  },
                ),
              ),
              if (selected.value <= 2 && selected.value >= 0)
                ReasonWidget(textController: textController),
              if (selected.value >= 0)
                SizedBox(
                  height: SizeConfig.padding24,
                ),
              if (selected.value >= 0)
                AppPositiveBtn(
                  btnText: 'SUBMIT',
                  onPressed: () {
                    submitted.value = true;

                    // debugPrint("Rating given: ${selected.value + 1}");
                    // debugPrint("Reason: ${textController.text}");

                    if (selected.value > 2) {
                      PreferenceHelper.setBool(
                          PreferenceHelper.APP_RATING_SUBMITTED, true);
                    }

                    locator<AnalyticsService>().track(
                      eventName: AnalyticsEvents.reviewPopupSuccess,
                      properties: {
                        "Rating given": selected.value + 1,
                        "Reason": textController.text,
                      },
                    );
                  },
                ),
              SizedBox(
                height: SizeConfig.padding54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Emoji extends StatelessWidget {
  const Emoji({
    required this.emoji,
    required this.onTap,
    required this.selected,
    super.key,
  });

  final String emoji;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: SizeConfig.padding64,
        height: SizeConfig.padding70,
        decoration: BoxDecoration(
          color: selected ? const Color(0xff62E3C4) : const Color(0xff323232),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            emoji,
            style: TextStyles.sourceSansB.title3.colour(Colors.white),
          ),
        ),
      ),
    );
  }
}

class ReasonWidget extends StatelessWidget {
  const ReasonWidget({required this.textController, Key? key})
      : super(key: key);

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: SizeConfig.padding24,
        ),
        Text(
          "Let us know what went wrong",
          textAlign: TextAlign.center,
          style:
              TextStyles.sourceSans.body2.colour(Colors.white.withOpacity(0.6)),
        ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
        //Text Field
        Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.padding90 + SizeConfig.padding12,
          decoration: BoxDecoration(
            color: const Color(0xff1A1A1A),
            borderRadius: BorderRadius.circular(SizeConfig.padding8),
          ),
          child: TextFormField(
            controller: textController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Start typing here...',
              hintStyle: TextStyles.sourceSans.body3
                  .colour(Colors.white.withOpacity(0.2)),
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.all(SizeConfig.padding16),
            ),
            style: TextStyles.sourceSans.body3.colour(
              UiConstants.kTextColor,
            ),
          ),
        ),
      ],
    );
  }
}

class FelloInAppReviewSuccess extends StatelessWidget {
  const FelloInAppReviewSuccess(
      {required this.emoji, required this.showButton, Key? key})
      : super(key: key);

  final String emoji;
  final bool showButton;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.backButtonDispatcher?.didPopRoute();
        return true;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
            decoration: BoxDecoration(
              color: const Color(0xff39393C),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.padding16),
                topRight: Radius.circular(SizeConfig.padding16),
              ),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                    Container(
                      width: SizeConfig.padding90 + SizeConfig.padding6,
                      height: SizeConfig.padding4,
                      decoration: BoxDecoration(
                        color: const Color(0xffD9D9D9),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.padding4),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding54,
                    ),
                    Container(
                      width: SizeConfig.padding54 - SizeConfig.padding4,
                      height: SizeConfig.padding54 - SizeConfig.padding4,
                      decoration: const BoxDecoration(
                        color: Color(0xff62E3C4),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          showButton ? "😍" : '🙂',
                          style: TextStyles.sourceSansB.title4
                              .colour(Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding24,
                    ),
                    Text(
                      "Thanks for your feedback!",
                      textAlign: TextAlign.center,
                      style:
                          TextStyles.sourceSansSB.title5.colour(Colors.white),
                    ),
                    SizedBox(
                      height: SizeConfig.padding24,
                    ),
                    Text(
                      showButton
                          ? "We’re so glad you’re enjoying Fello!\nPlease take a few seconds to rate us on the Store."
                          : "We will try our best to live upto your expectation\nand make your experience better on fello",
                      textAlign: TextAlign.center,
                      style: TextStyles.sourceSans.body2.colour(
                        Colors.white.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding24,
                    ),
                    if (showButton)
                      AppPositiveBtn(
                        btnText: 'Rate us on play store'.toUpperCase(),
                        onPressed: () async {
                          if (Platform.isAndroid) {
                            BaseUtil.launchUrl(Strings.playStoreUrl);
                          } else {
                            BaseUtil.launchUrl(Strings.appStoreUrl);
                          }
                          // final InAppReview inAppReview = InAppReview.instance;
                          //
                          // try {
                          //   if (await inAppReview.isAvailable()) {
                          //     await inAppReview.requestReview();
                          //   } else {
                          //     log("In app review not available, opening native application store");
                          //     await inAppReview.openStoreListing(
                          //         appStoreId: Strings.appStoreId);
                          //   }
                          // } catch (e) {
                          //   log(e.toString());
                          //   if (Platform.isAndroid) {
                          //     BaseUtil.launchUrl(Strings.playStoreUrl);
                          //   } else {
                          //     BaseUtil.launchUrl(Strings.appStoreUrl);
                          //   }
                          // }

                          AppState.backButtonDispatcher?.didPopRoute();

                          locator<AnalyticsService>().track(
                            eventName: AnalyticsEvents.rateOnPlayStoreTapped,
                          );
                        },
                      ),
                    if (showButton)
                      SizedBox(
                        height: SizeConfig.padding24,
                      ),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: SizeConfig.padding32,
                      ),
                      SvgPicture.asset(
                        Assets.inAppReviewBg,
                        width: SizeConfig.screenWidth! * 0.6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
