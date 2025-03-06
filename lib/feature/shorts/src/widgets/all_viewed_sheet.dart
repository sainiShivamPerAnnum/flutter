import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllShortsViewed extends StatelessWidget {
  const AllShortsViewed({
    required this.category,
    super.key,
  });
  final String category;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.removeOverlay();
        return true;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding20,
            ).copyWith(
              top: SizeConfig.padding12,
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'You’ve watched it all',
                      style: TextStyles.sourceSansSB.body1,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        AppState.backButtonDispatcher!.didPopRoute();
                      },
                      child: Icon(
                        Icons.close,
                        size: SizeConfig.body1,
                        color: UiConstants.kTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: const Color(0xffA2A0A2).withOpacity(.3),
          ),
          AppImage(
            Assets.done,
            height: 82.r,
            width: 82.r,
            color: UiConstants.primaryColor,
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Text(
            'That’s all in $category!',
            style: TextStyles.sourceSansM.body0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding18),
            child: Text(
              'Swipe right to watch more.',
              style:
                  TextStyles.sourceSans.body2.colour(UiConstants.kTextColor5),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          const Divider(
            color: UiConstants.greyVarient,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding18)
                .copyWith(top: SizeConfig.padding18),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      AppState.backButtonDispatcher!.didPopRoute();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UiConstants.kTextColor,
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.padding16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness8),
                      ),
                    ),
                    child: Text(
                      'Got it!',
                      style: TextStyles.sourceSans.body3
                          .colour(UiConstants.kTextColor4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.padding40),
        ],
      ),
    );
  }
}
