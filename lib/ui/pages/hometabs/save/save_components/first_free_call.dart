import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class FirstFreeCall extends StatelessWidget {
  const FirstFreeCall({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.padding24,
        horizontal: SizeConfig.padding20,
      ),
      padding: EdgeInsets.all(SizeConfig.padding18),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: UiConstants.greyVarient,
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'BOOK A CALL',
            style: TextStyles.sourceSansB.body6.colour(
              UiConstants.kTabBorderColor,
            ),
          ),
          SizedBox(height: SizeConfig.padding4),
          Text(
            'First Call FREE',
            style: TextStyles.sourceSansB.body1,
          ),
          SizedBox(height: SizeConfig.padding4),
          Text(
            'Connect with Our Trusted Advisors Now!',
            style: TextStyles.sourceSans.body3,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SizeConfig.padding18),
          ElevatedButton(
            onPressed: () {
              // Handle the book call action here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: UiConstants.kTextColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.roundness5),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding8,
                vertical: SizeConfig.padding6,
              ),
            ),
            child: Text(
              'Book Now!',
              style: TextStyles.sourceSansSB.body4.colour(
                UiConstants.kTextColor4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
