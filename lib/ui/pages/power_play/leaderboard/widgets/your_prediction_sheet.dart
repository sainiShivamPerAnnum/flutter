import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/power_play_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class YourPredictionSheet extends StatelessWidget {
  const YourPredictionSheet({
    required this.matchData,
    super.key,
    List<UserTransaction>? transactions,
  }) : _transactions = transactions ?? const [];

  final List<UserTransaction> _transactions;
  final MatchData matchData;

  String _getTime(int index) {
    final t = _transactions[index].timestamp;
    final date = DateTime.fromMillisecondsSinceEpoch(t!.millisecondsSinceEpoch);
    final formatter = DateFormat('hh:mm a');
    String formatted = formatter.format(date);
    return formatted;
  }

  /// Closes the current model and opens prediction sheet.
  Future<void> _onPredict(PowerPlayHomeViewModel model) async {
    await AppState.backButtonDispatcher!.didPopRoute();

    await model.predict();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (AppState.screenStack.last != ScreenItem.page) {
          AppState.screenStack.removeLast();
        }
        return Future.value(true);
      },
      child: BaseView<PowerPlayHomeViewModel>(
        builder: (context, model, child) => Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: SizeConfig.padding40,
              ),
              Text(
                "Your Predictions",
                style: TextStyles.sourceSansSB.body1.colour(Colors.white),
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
              SvgPicture.asset(
                Assets.noPredictions,
                height: 100,
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              // If user haven't made any prediction.
              if (_transactions.isEmpty)
                Text(
                  "You haven’t made any predictions yet. Start predicting now to win exciting prizes!",
                  style: TextStyles.body3.colour(Colors.white54),
                  textAlign: TextAlign.center,
                ),

              // List of prediction done by the user.
              if (_transactions.isNotEmpty)
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '#',
                          style: TextStyles.sourceSans.body3
                              .colour(const Color(0xffB59D9F)),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Prediction',
                          style: TextStyles.sourceSans.body3
                              .colour(const Color(0xffB59D9F)),
                        ),
                        const Spacer(),
                        Text(
                          'Time',
                          style: TextStyles.sourceSans.body3
                              .colour(const Color(0xffB59D9F)),
                        ),
                        const SizedBox(
                          width: 30,
                        )
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.3,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              SizedBox(
                                height: SizeConfig.padding16,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${index + 1}',
                                    style: TextStyles.sourceSans.body3
                                        .colour(Colors.white),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    '${_transactions[index].amount.truncate()} Runs',
                                    style: TextStyles.sourceSans.body3
                                        .colour(Colors.white),
                                  ),
                                  const Spacer(),
                                  Text(
                                    _getTime(index),
                                    style: TextStyles.sourceSans.body3
                                        .colour(Colors.white),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: SizeConfig.padding16,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: SizeConfig.padding40,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                onPressed: () => _onPredict(model),
                child: Center(
                  child: Text(
                    'PREDICT NOW',
                    style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
