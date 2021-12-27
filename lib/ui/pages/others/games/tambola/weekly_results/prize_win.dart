import 'package:confetti/confetti.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/games/tambola/weekly_results/winnerbox.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrizeWin extends StatefulWidget {
  final Map<String, int> winningsMap;
  const PrizeWin({Key key, this.winningsMap}) : super(key: key);

  @override
  _PrizeWinState createState() => _PrizeWinState();
}

class _PrizeWinState extends State<PrizeWin> {
  ConfettiController _confettiController;
  FcmListener _fcmListener;
  bool addedSubscription = false;

  @override
  void initState() {
    _confettiController = new ConfettiController(
      duration: new Duration(seconds: 2),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _confettiController.play();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    _fcmListener = locator<FcmListener>();
    if (!addedSubscription) {
      _fcmListener.addSubscription(FcmTopic.WINNERWINNER);
      addedSubscription = true;
    }
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Opacity(
              opacity: 0.4,
              child: SvgPicture.asset(
                "images/Tambola/gifts.svg",
                width: SizeConfig.screenWidth,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Spacer(
                  flex: 1,
                ),
                FittedBox(child: Text(
                  locale.tWinTitle,
                  style: TextStyles.title1.bold,
                ),),
                WinnerBox(
                  winningsmap: widget.winningsMap,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(locale.tWinSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyles.body2.bold
                          .colour(UiConstants.primaryColor)),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(locale.tWinSubtitle2,
                      textAlign: TextAlign.center,
                      style: TextStyles.body3),
                ),
                SizedBox(height: SizeConfig.padding12),
                Container(
                  width: SizeConfig.screenWidth,
                  child: FelloButtonLg(
                    onPressed: () {
                      AppState.backButtonDispatcher.didPopRoute();
                    },
                    child: Text(
                      "DONE",
                      style: TextStyles.body3.bold.colour(Colors.white),
                    ),
                  ),
                ),
                Spacer(
                  flex: 2,
                )
              ],
            ),
          ),
          Container(
            height: 100,
            width: 100,
            child: ConfettiWidget(
              blastDirectionality: BlastDirectionality.explosive,
              confettiController: _confettiController,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 25,
              gravity: 0.05,
              shouldLoop: false,
              colors: [
                Color(0xff10AB8F),
                Color(0xfff7ff00),
                Color(0xffFC5C7D),
                Color(0xff2B32B2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
