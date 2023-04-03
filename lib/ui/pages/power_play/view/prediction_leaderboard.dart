import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PredictionLeaderboard extends StatelessWidget {
  const PredictionLeaderboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff21284A),
                  Color(0xff3C2840),
                  Color(0xff772828),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.3, 0.6, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins),
                child: Column(
                  children: [
                    FAppBar(
                      // type: FaqsType.play,
                      showAvatar: false,
                      showCoinBar: false,
                      showHelpButton: false,
                      backgroundColor: Colors.transparent,
                      action: Row(
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              onSurface: Colors.white,
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 0.5),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            onPressed: () {},
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: Text(
                                "Invite Friends",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.body5,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.padding12,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  // color: UiConstants.kArrowButtonBackgroundColor,
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.5))),
                              padding: const EdgeInsets.all(6),
                              child: Icon(
                                Icons.question_mark,
                                color: Colors.white,
                                size: SizeConfig.padding20,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/powerplay_logo.png',
                        height: 95,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //IPL Match 4
                    Text(
                      "IPL Match 4",
                      style: TextStyles.sourceSansB.body2.colour(Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        children: [
                          Container(
                            height: 30,
                            width: 35,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white)),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bengaluru',
                                style: TextStyles.sourceSansB.body4,
                              ),
                              Text(
                                '140/2 (19)',
                                style: TextStyles.sourceSans.copyWith(
                                    fontSize: SizeConfig.screenWidth! * 0.030),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            'VS',
                            style: TextStyles.sourceSansB.body4,
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chennai',
                                style: TextStyles.sourceSansB.body4,
                              ),
                              Text(
                                'YET TO BAT',
                                style: TextStyles.sourceSans.copyWith(
                                    fontSize: SizeConfig.screenWidth! * 0.030),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 30,
                            width: 35,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    //PREDICTIONS END AFTER 19TH OVER OF 1ST INNINGS
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "PREDICTIONS END AFTER 19TH OVER OF 1ST INNINGS",
                      style: TextStyles.sourceSans.body4.colour(Colors.white),
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
                                style: TextStyles.sourceSans.body4
                                    .colour(const Color(0xffB59D9F)),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Users',
                                style: TextStyles.sourceSans.body4
                                    .colour(const Color(0xffB59D9F)),
                              ),
                              const Spacer(),
                              Text(
                                'Runs Predicted',
                                style: TextStyles.sourceSans.body4
                                    .colour(const Color(0xffB59D9F)),
                              ),
                            ],
                          ),

                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: 3,
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
                                          style: TextStyles.sourceSans.body4
                                              .colour(Colors.white),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          '100 user predicted',
                                          style: TextStyles.sourceSans.body4
                                              .colour(Colors.white),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '140 runs',
                                          style: TextStyles.sourceSans.body4
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
                              topLeft: Radius.circular(SizeConfig.roundness32),
                              topRight: Radius.circular(SizeConfig.roundness32),
                            ),
                            isScrollControlled: true,
                            hapticVibrate: true,
                            content: const YourPredictionSheet());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding16,
                            vertical: SizeConfig.padding16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xff000000).withOpacity(0.3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Your Predictions (10)",
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
                    Container(
                      // margin: EdgeInsets.only(
                      //     left: SizeConfig.pageHorizontalMargins),
                      height: 85,
                      // width: 275,
                      padding: const EdgeInsets.symmetric(
                          vertical: 11, horizontal: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xffA5E4FF),
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color: Colors.white, width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'How it Works?',
                            style: TextStyles.sourceSansSB.body1
                                .colour(Colors.black),
                          ),
                          Expanded(
                            child: Text(
                              'Predict the winning score of today’s match and get a chance to win digital gold equal to the Winning score!',
                              style: TextStyles.sourceSans.body4
                                  .colour(Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: SizeConfig.padding20,
                    ),
                    // WHAT IS A PREDICTION?
                    Text(
                      "WHAT IS A PREDICTION?",
                      style: TextStyles.rajdhaniB.body1
                          .colour(Colors.white)
                          .copyWith(decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: SizeConfig.padding20,
                    ),
                    MaterialButton(
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
                            content: const PrizeDistributionSheet());
                      },
                      child: Center(
                        child: Text(
                          'PREDICT NOW',
                          style:
                              TextStyles.rajdhaniB.body1.colour(Colors.black),
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
          ),
        ],
      ),
    );
  }
}

class PrizeDistributionSheet extends StatelessWidget {
  const PrizeDistributionSheet({Key? key}) : super(key: key);

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
              "Prize Distribution",
              style: TextStyles.sourceSansSB.body1.colour(Colors.white),
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            SvgPicture.asset(
              'assets/svg/prize_dist.svg',
              height: 100,
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            //Correct Predictors of the Match
            Text(
              "Correct Predictors of the Match",
              style: TextStyles.sourceSansSB.body3.colour(Colors.white),
            ),
            SizedBox(
              height: 7,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding16,
                  vertical: SizeConfig.padding16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.3),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Rank
                      Text('Rank',
                          style:
                              TextStyles.sourceSans.body4.colour(Colors.white)),
                      //Prize
                      Text('Prize',
                          style:
                              TextStyles.sourceSans.body4.colour(Colors.white)),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Rank
                      Text('1 to 10',
                          style:
                              TextStyles.sourceSans.body4.colour(Colors.white)),
                      //Prize
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/digital_gold.svg',
                            height: 25,
                          ),
                          Text('Digital Gold worth the Chasing Score',
                              style: TextStyles.sourceSans.body4
                                  .colour(Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Rank
                      Text('10 to 100',
                          style:
                              TextStyles.sourceSans.body4.colour(Colors.white)),
                      //Prize
                      Text('Tambola tickets & Tokens',
                          style:
                              TextStyles.sourceSans.body4.colour(Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            // Your Prediction
            Text(
              "Season Leaderboard",
              style: TextStyles.sourceSansSB.body3.colour(Colors.white),
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),

            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding16,
                  vertical: SizeConfig.padding16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black.withOpacity(0.3),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/ipl_ticket.svg',
                    height: 25,
                  ),
                  SizedBox(
                    width: SizeConfig.padding16,
                  ),
                  //Rank 1 on this leaderboard at the end of the IPL season gets 2 tickets to the Final Match
                  Flexible(
                    child: Text(
                      "Rank 1 on this leaderboard at the end of the IPL season gets 2 tickets to the Final Match",
                      style: TextStyles.sourceSans.body4.colour(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.padding26,
            ),

            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              onPressed: () {
                // BaseUtil.openModalBottomSheet(
                //     isBarrierDismissible: true,
                //     addToScreenStack: true,
                //     backgroundColor: const Color(0xff21284A),
                //     borderRadius: BorderRadius.only(
                //       topLeft: Radius.circular(SizeConfig.roundness32),
                //       topRight: Radius.circular(SizeConfig.roundness32),
                //     ),
                //     isScrollControlled: true,
                //     hapticVibrate: true,
                //     content: const YourPredictionSheet());
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

class MakePredictionSheet extends StatefulWidget {
  const MakePredictionSheet({Key? key}) : super(key: key);

  @override
  State<MakePredictionSheet> createState() => _MakePredictionSheetState();
}

class _MakePredictionSheetState extends State<MakePredictionSheet> {
  late TextEditingController _textController;
  var _formKey;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _formKey = GlobalKey<FormState>();
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
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 35,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white)),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bengaluru',
                              style: TextStyles.sourceSansB.body4,
                            ),
                            Text(
                              '140/2 (19)',
                              style: TextStyles.sourceSans.copyWith(
                                  fontSize: SizeConfig.screenWidth! * 0.030),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Text(
                            'VS',
                            style: TextStyles.sourceSansB.body4,
                          ),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chennai',
                              style: TextStyles.sourceSansB.body4,
                            ),
                            Text(
                              'YET TO BAT',
                              style: TextStyles.sourceSans.copyWith(
                                  fontSize: SizeConfig.screenWidth! * 0.030),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 30,
                          width: 35,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 19,
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

            AppTextField(
              margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding12,
              ),
              textEditingController: _textController,
              isEnabled: true,
              maxLength: 256,
              keyboardType: TextInputType.number,
              hintText: 'Enter your prediction',
              hintStyle: TextStyles.sourceSans.body3.colour(Color(0xff21284A)),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              fillColor: const Color(0xffD9D9D9).withOpacity(0.8),
              prefixIcon: const Icon(
                Icons.star,
                color: Color(0xff21284A),
                size: 25,
              ),
              // onSubmit: (_) =>null,

              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  return null;
                } else {
                  return 'Please enter your prediction';
                }
              },
            ),
            SizedBox(
              height: SizeConfig.padding40,
            ),
            //What is a Prediction?
            Text(
              "What is a Prediction?",
              style: TextStyles.sourceSans.body2
                  .colour(Colors.white)
                  .copyWith(decoration: TextDecoration.underline),
            ),
            SizedBox(
              height: SizeConfig.padding10,
            ),

            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              onPressed: () {
                // BaseUtil.openModalBottomSheet(
                //     isBarrierDismissible: true,
                //     addToScreenStack: true,
                //     backgroundColor: const Color(0xff21284A),
                //     borderRadius: BorderRadius.only(
                //       topLeft: Radius.circular(SizeConfig.roundness32),
                //       topRight: Radius.circular(SizeConfig.roundness32),
                //     ),
                //     isScrollControlled: true,
                //     hapticVibrate: true,
                //     content: const YourPredictionSheet());
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

class YourPredictionSheet extends StatelessWidget {
  const YourPredictionSheet({Key? key}) : super(key: key);

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
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  '#',
                  style: TextStyles.sourceSans.body4
                      .colour(const Color(0xffB59D9F)),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Prediction',
                  style: TextStyles.sourceSans.body4
                      .colour(const Color(0xffB59D9F)),
                ),
                const Spacer(),
                Text(
                  'Time',
                  style: TextStyles.sourceSans.body4
                      .colour(const Color(0xffB59D9F)),
                ),
              ],
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: 3,
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
                            style: TextStyles.sourceSans.body4
                                .colour(Colors.white),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            '100 runs',
                            style: TextStyles.sourceSans.body4
                                .colour(Colors.white),
                          ),
                          const Spacer(),
                          Text(
                            '6.04 pm',
                            style: TextStyles.sourceSans.body4
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
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              onPressed: () {
                // BaseUtil.openModalBottomSheet(
                //     isBarrierDismissible: true,
                //     addToScreenStack: true,
                //     backgroundColor: const Color(0xff21284A),
                //     borderRadius: BorderRadius.only(
                //       topLeft: Radius.circular(SizeConfig.roundness32),
                //       topRight: Radius.circular(SizeConfig.roundness32),
                //     ),
                //     isScrollControlled: true,
                //     hapticVibrate: true,
                //     content: const YourPredictionSheet());
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
  const NoPredictionSheet({Key? key}) : super(key: key);

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
                  content: const SizedBox(
                    height: 200,
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
