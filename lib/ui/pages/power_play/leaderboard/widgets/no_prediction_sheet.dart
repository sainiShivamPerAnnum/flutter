import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/ui/pages/power_play/leaderboard/widgets/make_prediction_sheet.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoPredictionSheet extends StatelessWidget {
  final MatchData matchData;

  const NoPredictionSheet({
    required this.matchData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Container(
            height: 2,
            width: 100,
            color: Colors.white,
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          Text(
            "Your Predictions",
            style: TextStyles.sourceSansSB.body1.colour(Colors.white),
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          SvgPicture.asset(
            'assets/svg/prediction_ball.svg',
            height: 100,
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Text(
            "You haven’t made any predictions yet.\nStart predicting now to win exciting prizes!",
            style: TextStyles.sourceSans.body3.colour(Colors.white),
          ),
          SizedBox(
            height: SizeConfig.padding32,
          ),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.white,
            onPressed: () {
              BaseUtil.openModalBottomSheet(
                isBarrierDismissible: true,
                addToScreenStack: true,
                backgroundColor: UiConstants.kGoldProBgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.roundness32),
                  topRight: Radius.circular(SizeConfig.roundness32),
                ),
                isScrollControlled: true,
                hapticVibrate: true,
                content: MakePredictionSheet(
                  matchData: matchData,
                ),
              );
            },
            child: Center(
              child: Text(
                'PREDICT NOW',
                style: TextStyles.rajdhaniB.body1.colour(Colors.black),
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding16,
          )
        ],
      ),
    );
  }
}
