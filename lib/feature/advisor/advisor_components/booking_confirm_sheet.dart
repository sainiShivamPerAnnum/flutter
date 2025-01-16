import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class BookingConfirmSheet extends StatelessWidget {
  final String name;
  final String date;
  const BookingConfirmSheet({
    required this.name,
    required this.date,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding20,
          ).copyWith(
            top: SizeConfig.padding14,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Live Scheduled',
                style: TextStyles.sourceSansSB.body1,
              ),
            ],
          ),
        ),
        const Divider(
          color: UiConstants.greyVarient,
        ),
        AppImage(Assets.confirm_payment, height: SizeConfig.padding112),
        Text(
          name,
          style: TextStyles.sourceSansSB.title4,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding42,
            vertical: SizeConfig.padding12,
          ),
          child: Text(
            'Your session has been successfully scheduled on ${BaseUtil.formatDateTime(
              DateTime.parse(date),
            )} ',
            style: TextStyles.sourceSans.body3.colour(UiConstants.kTextColor5),
            textAlign: TextAlign.center,
          ),
        ),
        const Divider(
          color: UiConstants.greyVarient,
        ),
        Padding(
          padding: EdgeInsets.all(SizeConfig.padding18),
          child: SizedBox(
            width: double.infinity,
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
                  borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                ),
              ),
              child: Text(
                'Done',
                style:
                    TextStyles.sourceSans.body3.colour(UiConstants.kTextColor4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
