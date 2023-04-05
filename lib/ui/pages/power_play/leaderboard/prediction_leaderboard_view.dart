import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/power_play/leaderboard/view_model/leaderboard_view_model.dart';
import 'package:felloapp/ui/pages/power_play/leaderboard/widgets/prize_distribution_sheet.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/ipl_teams_score_widget.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/power_play_bg.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/support/faq/faq_page.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class PredictionLeaderboard extends StatelessWidget {
  const PredictionLeaderboard({Key? key, required this.matchData})
      : super(key: key);

  final MatchData matchData;

  String get image => AppConfig.getValue<Map<String, dynamic>>(
          AppConfigKey.powerplayConfig)['predictScreen']['cardCarousel'][1]
      ['imgUrl'];

  @override
  Widget build(BuildContext context) {
    return BaseView<LeaderBoardViewModel>(
      onModelReady: (model) {
        model.getUserPredictedData();
        model.powerPlayService.getUserTransactionHistory(matchData);
      },
      builder: (context, model, child) {
        return PowerPlayBackgroundUi(
          child: Stack(
            children: [
              Column(
                children: [
                  FAppBar(
                    showAvatar: false,
                    showCoinBar: false,
                    showHelpButton: false,
                    backgroundColor: Colors.transparent,
                    action: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Haptic.vibrate();
                            AppState.delegate!.appState.currentAction =
                                PageAction(
                              state: PageState.addWidget,
                              page: FaqPageConfig,
                              widget: const FAQPage(
                                type: FaqsType.journey,
                              ),
                            );
                          },
                          child: Container(
                              key: const ValueKey(Constants.HELP_FAB),
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding12,
                                  vertical: SizeConfig.padding6),
                              height: SizeConfig.avatarRadius * 2,
                              decoration: BoxDecoration(
                                color: UiConstants.kTextFieldColor
                                    .withOpacity(0.4),
                                border: Border.all(color: Colors.white10),
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Invite Friends',
                                    style: TextStyles.body4
                                        .colour(UiConstants.kTextColor),
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins),
                        child: Column(
                          children: [
                            Text(
                              matchData.matchTitle ?? 'IPL MATCH',
                              style: TextStyles.sourceSansB.body2
                                  .colour(Colors.white),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: IplTeamsScoreWidget(
                                matchData: matchData,
                              ),
                            ),
                            //PREDICTIONS END AFTER 19TH OVER OF 1ST INNINGS
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              matchData.headsUpText ?? '',
                              style: TextStyles.sourceSans.body4
                                  .colour(Colors.white),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 1,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding16,
                                  vertical: SizeConfig.padding14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xff000000).withOpacity(0.3),
                              ),
                              child: Column(
                                children: [
                                  //Prediction Leaderboard
                                  Text(
                                    "Prediction Leaderboard",
                                    style: TextStyles.sourceSans.body1
                                        .colour(Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
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
                                        'Users',
                                        style: TextStyles.sourceSans.body3
                                            .colour(const Color(0xffB59D9F)),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Runs Predicted',
                                        style: TextStyles.sourceSans.body3
                                            .colour(const Color(0xffB59D9F)),
                                      ),
                                    ],
                                  ),

                                  UsersPrediction(
                                    model: model,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                BaseUtil.openModalBottomSheet(
                                    isBarrierDismissible: true,
                                    addToScreenStack: true,
                                    backgroundColor: const Color(0xff21284A),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          SizeConfig.roundness32),
                                      topRight: Radius.circular(
                                          SizeConfig.roundness32),
                                    ),
                                    isScrollControlled: true,
                                    hapticVibrate: true,
                                    content: (model.powerPlayService
                                                    .transactions?.length ??
                                                0) >
                                            0
                                        ? YourPredictionSheet(
                                            transactions: model
                                                .powerPlayService.transactions!,
                                            matchData: matchData,
                                          )
                                        : NoPredictionSheet(
                                            matchData: matchData,
                                          ));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding16,
                                    vertical: SizeConfig.padding16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color(0xff000000).withOpacity(0.3),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Your Predictions (${model.powerPlayService.transactions?.length})",
                                      style: TextStyles.sourceSans.body3
                                          .colour(Colors.white),
                                    ),
                                    // const Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: const Color(0xffB59D9F),
                                      size: SizeConfig.padding16,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                BaseUtil.openModalBottomSheet(
                                    isBarrierDismissible: true,
                                    addToScreenStack: true,
                                    backgroundColor: const Color(0xff21284A),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          SizeConfig.roundness32),
                                      topRight: Radius.circular(
                                          SizeConfig.roundness32),
                                    ),
                                    isScrollControlled: true,
                                    hapticVibrate: true,
                                    content: PrizeDistributionSheet(
                                        matchData: matchData));
                              },
                              child: SizedBox(
                                  width: SizeConfig.screenWidth,
                                  child: SvgPicture.network(
                                    image,
                                    fit: BoxFit.fill,
                                  )),
                            ),

                            SizedBox(
                              height: SizeConfig.padding20,
                            ),
                            // WHAT IS A PREDICTION?
                            GestureDetector(
                              onTap: () {
                                AppState.delegate!.appState.currentAction =
                                    PageAction(
                                        state: PageState.addPage,
                                        page: PowerPlayHowItWorksConfig);
                              },
                              child: Text(
                                "WHAT IS A PREDICTION?",
                                style: TextStyles.rajdhaniB.body1
                                    .colour(Colors.white)
                                    .copyWith(
                                        decoration: TextDecoration.underline),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.navBarHeight,
                            ),
                            // MaterialButton(
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(5)),
                            //   padding: const EdgeInsets.symmetric(vertical: 10),
                            //   color: Colors.white,
                            //   onPressed: () {
                            //     BaseUtil.openModalBottomSheet(
                            //         isBarrierDismissible: true,
                            //         addToScreenStack: true,
                            //         backgroundColor: const Color(0xff21284A),
                            //         borderRadius: BorderRadius.only(
                            //           topLeft: Radius.circular(SizeConfig.roundness32),
                            //           topRight: Radius.circular(SizeConfig.roundness32),
                            //         ),
                            //         isScrollControlled: true,
                            //         hapticVibrate: true,
                            //         content: MakePredictionSheet(
                            //           matchData: matchData,
                            //         ));
                            //   },
                            //   child: Center(
                            //     child: Text(
                            //       'PREDICT NOW',
                            //       style:
                            //           TextStyles.rajdhaniB.body1.colour(Colors.black),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: SizeConfig.padding20,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: SizeConfig.navBarHeight * 0.8,
                  margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  width: SizeConfig.screenWidth,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.white,
                    onPressed: () {
                      BaseUtil.openModalBottomSheet(
                          isBarrierDismissible: true,
                          addToScreenStack: true,
                          backgroundColor: const Color(0xff21284A),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(SizeConfig.roundness32),
                            topRight: Radius.circular(SizeConfig.roundness32),
                          ),
                          isScrollControlled: true,
                          hapticVibrate: true,
                          content: MakePredictionSheet(
                            matchData: matchData,
                          ));
                    },
                    child: Center(
                      child: Text(
                        'PREDICT NOW',
                        style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class UsersPrediction extends StatelessWidget {
  const UsersPrediction({
    super.key,
    required this.model,
  });

  final LeaderBoardViewModel model;

  @override
  Widget build(BuildContext context) {
    return model.state == ViewState.Busy
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: model.userPredictedData.length,
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
                        style: TextStyles.sourceSans.body3.colour(Colors.white),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        '${model.userPredictedData[index].count} user predicted',
                        style: TextStyles.sourceSans.body3.colour(Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        '${model.userPredictedData[index].amount} runs',
                        style: TextStyles.sourceSans.body3.colour(Colors.white),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding16,
                  ),
                  if (index != 2)
                    Container(
                      height: 0.5,
                      color: Colors.white.withOpacity(0.3),
                    ),
                ],
              );
            },
          );
  }
}

class MakePredictionSheet extends StatefulWidget {
  const MakePredictionSheet({Key? key, required this.matchData})
      : super(key: key);

  final MatchData matchData;

  @override
  State<MakePredictionSheet> createState() => _MakePredictionSheetState();
}

class _MakePredictionSheetState extends State<MakePredictionSheet> {
  late TextEditingController _textController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    // _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.pageHorizontalMargins,
          right: SizeConfig.pageHorizontalMargins,
          bottom: MediaQuery.of(context).viewInsets.bottom),
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
            "Make your Prediction",
            style: TextStyles.sourceSansSB.body1.colour(Colors.white),
          ),
          SizedBox(
            height: SizeConfig.padding10,
          ),
          Text(
            "Enter a Prediction for the Chasing Score of the Match",
            style: TextStyles.sourceSans.body3.colour(Colors.white),
          ),

          SizedBox(
            height: SizeConfig.padding28,
          ),
          Container(
            // height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withOpacity(0.3),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.padding20,
                ),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
                    child: IplTeamsScoreWidget(
                      matchData: widget.matchData,
                    )),
                SizedBox(
                  height: SizeConfig.padding20,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // Your Prediction
          Text(
            "Your Prediction",
            style: TextStyles.sourceSansSB.body0.colour(Colors.white),
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),

          Form(
            key: _formKey,
            child: AppTextField(
              margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding12,
              ),
              autoFocus: true,
              textEditingController: _textController,
              isEnabled: true,
              maxLength: 256,
              keyboardType: TextInputType.number,
              hintText: 'Enter your prediction',
              textStyle:
                  TextStyles.sourceSansSB.body2.colour(const Color(0xff21284A)),
              hintStyle:
                  TextStyles.sourceSans.body3.colour(const Color(0xff21284A)),
              inputFormatters: [
                //limit of 3 digits
                LengthLimitingTextInputFormatter(3),

                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              fillColor: const Color(0xffD9D9D9).withOpacity(0.8),
              prefixIcon: const Icon(
                Icons.star,
                color: Color(0xff21284A),
                size: 25,
              ),
              suffixText: 'Runs',
              suffixTextStyle:
                  TextStyles.sourceSansSB.body3.colour(const Color(0xff21284A)),
              onSubmit: (_) => BaseUtil.openDepositOptionsModalSheet(
                title:
                    'To predict, Save ₹${_textController.text} in Gold or Flo',
                subtitle: 'Make as many predictions as you can, to win',
                amount: int.tryParse(_textController.text),
              ),
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  return null;
                } else {
                  return 'Please enter your prediction';
                }
              },
            ),
          ),
          SizedBox(
            height: SizeConfig.padding40,
          ),
          //What is a Prediction?
          GestureDetector(
            onTap: () {
              AppState.backButtonDispatcher!.didPopRoute();

              AppState.delegate!.appState.currentAction = PageAction(
                state: PageState.addPage,
                page: PowerPlayHowItWorksConfig,
              );
            },
            child: Text(
              "What is Chasing Score?",
              style: TextStyles.sourceSans.body2
                  .colour(Colors.white)
                  .copyWith(decoration: TextDecoration.underline),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding10,
          ),

          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.white,
            onPressed: () {
              if (_formKey.currentState!.validate() == false) return;

              AppState.backButtonDispatcher!.didPopRoute();

              BaseUtil.openDepositOptionsModalSheet(
                  title:
                      'To predict, Save ₹${_textController.text} in Gold or Flo',
                  subtitle: 'Make as many predictions as you can, to win',
                  amount: int.tryParse(_textController.text),
                  timer: 0);
            },
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
    );
  }
}

class MatchBriefDetailsWidget extends StatelessWidget {
  final MatchData matchData;

  const MatchBriefDetailsWidget({super.key, required this.matchData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          matchData.matchTitle ?? "",
          style: TextStyles.sourceSansB.body2.colour(Colors.white),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: IplTeamsScoreWidget(
            matchData: matchData,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          matchData.verdictText ?? "",
          style: TextStyles.sourceSans.body4.colour(Colors.white),
        ),
        SizedBox(height: SizeConfig.padding4),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Chasing score: ",
                style: TextStyles.sourceSansSB
                    .copyWith(fontSize: SizeConfig.screenWidth! * 0.030),
              ),
              Text(
                "${matchData.target}",
                style: TextStyles.sourceSans
                    .copyWith(fontSize: SizeConfig.screenWidth! * 0.030),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class YourPredictionSheet extends StatelessWidget {
  const YourPredictionSheet(
      {Key? key, this.transactions, required this.matchData})
      : super(key: key);

  final List<UserTransaction>? transactions;
  final MatchData matchData;

  String getTime(int index) {
    var time = transactions![index].timestamp;

    var date =
        DateTime.fromMillisecondsSinceEpoch(time!.millisecondsSinceEpoch);
    var formatter = DateFormat('hh:mm a');
    String formatted = formatter.format(date);
    log(formatted);
    return formatted;
  }

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
            const SizedBox(
              height: 20,
            ),
            (transactions ?? []).isEmpty
                ? Text(
                    "You haven’t made any predictions yet. Start predicting now to win exciting prizes!",
                    style: TextStyles.body3.colour(Colors.white54),
                    textAlign: TextAlign.center,
                  )
                : Column(
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
                            itemCount: transactions?.length,
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
                                        '${transactions![index].amount.truncate()} Runs',
                                        style: TextStyles.sourceSans.body3
                                            .colour(Colors.white),
                                      ),
                                      const Spacer(),
                                      Text(
                                        getTime(index),
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
                                  if (index != 2)
                                    Container(
                                      height: 0.5,
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                ],
                              );
                            }),
                      ),
                    ],
                  ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              onPressed: () {
                AppState.backButtonDispatcher!.didPopRoute();

                BaseUtil.openModalBottomSheet(
                    isBarrierDismissible: true,
                    addToScreenStack: true,
                    backgroundColor: const Color(0xff21284A),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.roundness32),
                      topRight: Radius.circular(SizeConfig.roundness32),
                    ),
                    isScrollControlled: true,
                    hapticVibrate: true,
                    content: MakePredictionSheet(
                      matchData: matchData,
                    ));
              },
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
        ));
  }
}

class NoPredictionSheet extends StatelessWidget {
  const NoPredictionSheet({Key? key, required this.matchData})
      : super(key: key);

  final MatchData matchData;

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
                  backgroundColor: const Color(0xff21284A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.roundness32),
                    topRight: Radius.circular(SizeConfig.roundness32),
                  ),
                  isScrollControlled: true,
                  hapticVibrate: true,
                  content: MakePredictionSheet(
                    matchData: matchData,
                  ));
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
