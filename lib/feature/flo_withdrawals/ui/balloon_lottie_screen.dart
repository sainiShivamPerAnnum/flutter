import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/lendbox_maturity_service.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/maturity_withdrawal_success.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/widgets/money_after_maturity_widget.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/service_elements/last_week/last_week_bg.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class BalloonLottieScreen extends StatefulWidget {
  const BalloonLottieScreen({super.key});

  @override
  State<BalloonLottieScreen> createState() => _BalloonLottieScreenState();
}

class _BalloonLottieScreenState extends State<BalloonLottieScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  double heightFactor = 1;
  Color lineColor = const Color(0xff1ADAB7);
  bool showWithdrawalScreen = false;
  int expectedKey = 1;
  late LendboxMaturityService lendboxMaturityService;
  bool showLoading = false;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    lendboxMaturityService = locator<LendboxMaturityService>();
    super.initState();
  }

  Future<void> _reset() async {
    Haptic.vibrate();
    if (showWithdrawalScreen) {
      setState(() {
        showLoading = true;
      });
      var depositData = lendboxMaturityService.filteredDeposits?[0];

      await lendboxMaturityService.updateInvestmentPref('0');

      //add delay to show loading
      await Future.delayed(const Duration(milliseconds: 700));

      AppState.backButtonDispatcher?.didPopRoute();

      AppState.delegate!.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: MaturityWithdrawalSuccessViewPageConfig,
        widget: MaturityWithdrawalSuccessView(
          amount: depositData?.maturityAmt.toString() ?? '',
          date: depositData?.maturityOn ?? DateTime.now(),
        ),
      );

      locator<AnalyticsService>().track(
        eventName: AnalyticsEvents.confirmWithdrawOnFixedWithdrawal,
        properties: {
          "Maturity Date": formatDate(depositData!.maturityOn!),
          "Maturity Amount": depositData.maturityAmt,
          "principal amount": depositData.investedAmt,
          'asset': depositData.fundType
        },
      );
    } else {
      AppState.backButtonDispatcher?.didPopRoute();

      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          BaseUtil.openModalBottomSheet(
            addToScreenStack: true,
            enableDrag: false,
            hapticVibrate: true,
            isBarrierDismissible: false,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            content: MoneyAfterMaturityWidget(
              depositData: lendboxMaturityService.filteredDeposits![0],
              decision: lendboxMaturityService.userDecision,
              isLendboxOldUser: lendboxMaturityService.isLendboxOldUser,
            ),
          );
        },
      );

      locator<AnalyticsService>().track(
        eventName: AnalyticsEvents.changeDecisionOnBalloonScreen,
        properties: {
          "Maturity Date": formatDate(
              lendboxMaturityService.filteredDeposits![0].maturityOn!),
          "Maturity Amount":
              lendboxMaturityService.filteredDeposits![0].maturityAmt,
          "principal amount":
              lendboxMaturityService.filteredDeposits![0].investedAmt,
          'asset': lendboxMaturityService.filteredDeposits![0].fundType
        },
      );
    }
  }

  void _handleTap(int tappedKey) {
    Haptic.vibrate();
    if (tappedKey == expectedKey) {
      controller!.animateTo(
        _getAnimationProgressForTap(tappedKey),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
      setState(() {
        heightFactor = _getLineAnimationProgress(tappedKey);
      });

      if (tappedKey == 6) {
        Future.delayed(const Duration(milliseconds: 600), () {
          setState(() {
            showWithdrawalScreen = true;
          });
        });
      }

      expectedKey++;
      if (expectedKey > 6) {
        expectedKey = 1;
      }

      locator<AnalyticsService>().track(
        eventName: AnalyticsEvents.balloonTappedWithdrawalFixed,
        properties: {
          "Maturity Date": formatDate(
              lendboxMaturityService.filteredDeposits![0].maturityOn!),
          "Maturity Amount":
              lendboxMaturityService.filteredDeposits![0].maturityAmt,
          "principal amount":
              lendboxMaturityService.filteredDeposits![0].investedAmt,
          'asset': lendboxMaturityService.filteredDeposits![0].fundType
        },
      );
    } else {
      BaseUtil.showPositiveAlert("Please Tap on the top most balloon", ' ');
    }
  }

  double _getAnimationProgressForTap(int tappedKey) {
    // Define the animation progress values for each key
    switch (tappedKey) {
      case 1:
        return 0.119;
      case 2:
        return 0.29;
      case 3:
        return 0.44;
      case 4:
        return 0.59;
      case 5:
        return 0.745;
      case 6:
        return 0.92;
      default:
        return 0.0;
    }
  }

  double _getLineAnimationProgress(int tappedKey) {
    switch (tappedKey) {
      case 1:
        return 0.75;
      case 2:
        return 0.6;
      case 3:
        setState(() {
          lineColor = const Color(0xFFF79780);
        });
        return 0.528;
      case 4:
        return 0.4;
      case 5:
        setState(() {
          lineColor = const Color(0xFFFF4C21);
        });
        return 0.28;
      case 6:
        return 0.0;
      default:
        return 0.0;
    }
  }

  String getText() {
    switch (expectedKey) {
      case 1:
      case 2:
      case 3:
        return 'Your investment could have grown by 10% if you re-invested';
      case 4:
      case 5:
        return 'You can still move your investment to 8% Flo and withdraw anytime after 1 week from the date of re-investing';
      case 6:
        return 'Are you sure you want to withdraw? You are getting 5% lesser returns in your savings bank account.';
      default:
        return '';
    }
  }

  String formatDate(DateTime dateTime) {
    final format = DateFormat('dd MMM, yyyy');
    return format.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff232326),
      body: Stack(
        children: [
          Positioned(
            top: SizeConfig.padding56,
            left: SizeConfig.padding18,
            child: GestureDetector(
              onTap: () {
                AppState.backButtonDispatcher!.didPopRoute();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: SizeConfig.padding108,
            left: 0,
            right: 0,
            child: Text(
              showWithdrawalScreen
                  ? 'We are sorry to\nsee you go'
                  : 'Tap on balloons to withdraw',
              textAlign: TextAlign.center,
              style: TextStyles.rajdhaniB.title3.colour(Colors.white),
            ),
          ),
          const _BackGround(),
          Transform.translate(
            offset: Offset(SizeConfig.padding60, -SizeConfig.padding60),
            child: Center(
              child: SizedBox(
                height: SizeConfig.screenHeight! * 0.55,
                child: LottieBuilder.asset(
                  'assets/lotties/balloon_burst_lottie.json',
                  // frameRate: FrameRate(20),
                  controller: controller,
                  animate: true,
                  // repeat: true,
                ),
              ),
            ),
          ),
          showWithdrawalScreen
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: SizeConfig.padding104),
                      SvgPicture.asset(
                        'assets/svg/tissue_box.svg',
                      ),
                      SizedBox(height: SizeConfig.padding70),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding25),
                        child: Text(
                          'We will credit ₹${lendboxMaturityService.filteredDeposits?[0].maturityAmt} at the end of maturity to your bank',
                          textAlign: TextAlign.center,
                          style:
                              TextStyles.rajdhaniSB.title4.colour(Colors.white),
                        ),
                      )
                    ],
                  ),
                )
              : BalloonGestureDetectors(onTap: _handleTap),
          if (!showWithdrawalScreen)
            LineIndicator(
              heightFactor: heightFactor,
              lineColor: lineColor,
            ),
          if (!showWithdrawalScreen)
            Positioned(
              bottom: SizeConfig.screenHeight! * 0.15,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding24,
                    vertical: SizeConfig.padding26),
                margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding30),
                width: SizeConfig.screenWidth! * 0.75,
                decoration: ShapeDecoration(
                  color: const Color(0xFF191919),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)),
                ),
                child: Text(
                  getText(),
                  textAlign: TextAlign.center,
                  style:
                      TextStyles.sourceSans.body2.copyWith(color: Colors.white),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding25,
                      vertical: SizeConfig.padding16),
                  child: showLoading
                      ? SpinKitThreeBounce(
                          size: SizeConfig.title5,
                          color: Colors.white,
                        )
                      : AppPositiveBtn(
                          onPressed: _reset,
                          btnText: showWithdrawalScreen
                              ? "CONFIRM WITHDRAW"
                              : "CHANGE DECISION",
                        ),
                ),
                if (showWithdrawalScreen)
                  GestureDetector(
                    onTap: () {
                      Haptic.vibrate();
                      AppState.backButtonDispatcher?.didPopRoute();

                      Future.delayed(
                        const Duration(milliseconds: 300),
                        () {
                          BaseUtil.openModalBottomSheet(
                            addToScreenStack: true,
                            enableDrag: false,
                            hapticVibrate: true,
                            isBarrierDismissible: false,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            content: MoneyAfterMaturityWidget(
                              depositData:
                                  lendboxMaturityService.filteredDeposits![0],
                              decision: lendboxMaturityService.userDecision,
                              isLendboxOldUser:
                                  lendboxMaturityService.isLendboxOldUser,
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: SizeConfig.screenWidth! * 0.75,
                      padding: EdgeInsets.only(
                          bottom: SizeConfig.padding26,
                          top: SizeConfig.padding8),
                      child: Text(
                        'CHANGE DECISION',
                        textAlign: TextAlign.center,
                        style: TextStyles.rajdhaniSB.body0.colour(
                          const Color(0xFF46BDA4),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    log("dispose");
    controller?.dispose();
    super.dispose();
  }
}

class LineIndicator extends StatelessWidget {
  const LineIndicator(
      {required this.heightFactor,
      required this.lineColor,
      super.key,
      this.show10label = true,
      this.show8label = true});

  final double heightFactor;
  final Color lineColor;
  final bool show10label;
  final bool show8label;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: SizeConfig.padding20,
          top: SizeConfig.screenHeight! * 0.2,
          child: Container(
            alignment: Alignment.bottomLeft,
            height: SizeConfig.screenHeight! * 0.48,
            child: AnimatedContainer(
              alignment: Alignment.bottomCenter,
              height: heightFactor * (SizeConfig.screenHeight! * 0.57),
              width: SizeConfig.padding8,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInExpo,
              color: lineColor,
            ),
          ),
        ),
        Positioned(
          top: SizeConfig.screenHeight! * 0.2,
          left: SizeConfig.padding20,
          child: Container(
            height: SizeConfig.padding2,
            width: SizeConfig.padding20,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(60)),
            ),
          ),
        ),
        Positioned(
          top: SizeConfig.screenHeight! * 0.38,
          left: SizeConfig.padding20,
          child: Container(
            height: SizeConfig.padding2,
            width: SizeConfig.padding20,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(60)),
            ),
          ),
        ),
        Positioned(
          top: SizeConfig.screenHeight! * 0.52,
          left: SizeConfig.padding20,
          child: Container(
            height: SizeConfig.padding2,
            width: SizeConfig.padding20,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(60)),
            ),
          ),
        ),
        if (show10label)
          Positioned(
            top: SizeConfig.screenHeight! * 0.19,
            left: SizeConfig.padding48,
            child: Text('10%',
                style: TextStyles.rajdhaniSB.body2.colour(Colors.white)),
          ),
        if (show8label)
          Positioned(
            top: SizeConfig.screenHeight! * 0.37,
            left: SizeConfig.padding48,
            child: Text('8%',
                style: TextStyles.rajdhaniSB.body2.colour(Colors.white)),
          ),
        Positioned(
          top: SizeConfig.screenHeight! * 0.51,
          left: SizeConfig.padding48,
          child: Text('Withdraw',
              style: TextStyles.rajdhaniSB.body2.colour(Colors.white)),
        ),
      ],
    );
  }
}

class _BackGround extends StatelessWidget {
  const _BackGround();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: SizeConfig.padding152,
          right: SizeConfig.padding50,
          child: CustomPaint(
            size: Size(25, (25 * 1.13).toDouble()),
            painter: MoonCustomPainter(),
          ),
        ),
        Positioned(
          top: SizeConfig.padding164,
          left: SizeConfig.padding70,
          child: CustomPaint(
            size: Size(25, (25 * 0.32).toDouble()),
            painter: CloudCustomPainter(),
          ),
        ),
        Positioned(
          bottom: SizeConfig.screenHeight! * 0.3,
          right: SizeConfig.padding50,
          child: CustomPaint(
            size: Size(25, (25 * 0.32).toDouble()),
            painter: CloudCustomPainter(),
          ),
        ),
        Positioned(
            top: SizeConfig.padding90,
            left: SizeConfig.padding50,
            child: Container(
              height: SizeConfig.padding2,
              width: SizeConfig.padding2,
              color: const Color(0xff62E3C4),
            )),
        Positioned(
            top: SizeConfig.padding90,
            left: SizeConfig.padding136,
            child: Container(
              height: SizeConfig.padding2,
              width: SizeConfig.padding2,
              color: const Color(0xff62E3C4),
            )),
        Positioned(
            top: SizeConfig.padding112,
            left: SizeConfig.padding20,
            child: Container(
              height: SizeConfig.padding2,
              width: SizeConfig.padding2,
              color: const Color(0xffFFD979),
            )),
        Positioned(
            top: SizeConfig.screenHeight! * 0.3,
            left: SizeConfig.padding200,
            child: Container(
              height: SizeConfig.padding2,
              width: SizeConfig.padding2,
              color: const Color(0xffFFD979),
            )),
        Positioned(
            top: SizeConfig.screenHeight! * 0.28,
            left: SizeConfig.padding120,
            child: Container(
              height: SizeConfig.padding2,
              width: SizeConfig.padding2,
              color: const Color(0xffFFD979),
            )),
        Positioned(
            top: SizeConfig.padding132,
            right: SizeConfig.padding136,
            child: Container(
              height: SizeConfig.padding2,
              width: SizeConfig.padding2,
              color: const Color(0xffFFD979),
            )),
        Positioned(
            bottom: SizeConfig.padding152,
            right: SizeConfig.padding20,
            child: Container(
              height: SizeConfig.padding2,
              width: SizeConfig.padding2,
              color: const Color(0xffFFD979),
            )),
        Positioned(
            bottom: SizeConfig.screenHeight! * 0.4,
            left: SizeConfig.padding136,
            child: Container(
              height: SizeConfig.padding2,
              width: SizeConfig.padding2,
              color: const Color(0xffFFD979),
            )),
        Positioned(
            bottom: SizeConfig.screenHeight! * 0.5,
            right: SizeConfig.padding180,
            child: Container(
              height: SizeConfig.padding2,
              width: SizeConfig.padding2,
              color: const Color(0xff62E3C4),
            )),
        Positioned(
            bottom: SizeConfig.screenHeight! * 0.6,
            right: SizeConfig.padding50,
            child: Container(
              height: SizeConfig.padding2,
              width: SizeConfig.padding2,
              color: const Color(0xff62E3C4),
            )),
        Positioned(
            bottom: SizeConfig.screenHeight! * 0.2,
            left: SizeConfig.padding50,
            child: Container(
              height: SizeConfig.padding2,
              width: SizeConfig.padding2,
              color: const Color(0xff62E3C4),
            )),
        Positioned(
            bottom: SizeConfig.screenHeight! * 0.3,
            left: SizeConfig.padding132,
            child: Container(
              height: SizeConfig.padding2,
              width: SizeConfig.padding2,
              color: const Color(0xffFFD979),
            )),
        Positioned(
            bottom: SizeConfig.screenHeight! * 0.4,
            right: SizeConfig.padding50,
            child: Container(
              height: SizeConfig.padding2,
              width: SizeConfig.padding2,
              color: const Color(0xffFFD979),
            )),
        Positioned(
          bottom: SizeConfig.screenHeight! * 0.5,
          right: SizeConfig.padding132,
          child: Container(
            height: SizeConfig.padding2,
            width: SizeConfig.padding2,
            color: const Color(0xffFFD979),
          ),
        ),
        Positioned(
            bottom: SizeConfig.screenHeight! * 0.4,
            left: SizeConfig.padding50,
            child: Container(
              height: SizeConfig.padding2,
              width: SizeConfig.padding2,
              color: const Color(0xff62E3C4),
            )),
        Positioned(
            bottom: SizeConfig.screenHeight! * 0.55,
            left: SizeConfig.padding60,
            child: Container(
              height: SizeConfig.padding2,
              width: SizeConfig.padding2,
              color: const Color(0xff62E3C4),
            )),
      ],
    );
  }
}

class BalloonGestureDetectors extends StatelessWidget {
  const BalloonGestureDetectors({required this.onTap, super.key});

  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          key: const Key("1"),
          top: SizeConfig.screenHeight! * 0.248,
          right: SizeConfig.screenWidth! * 0.448,
          child: GestureDetector(
            onTap: () => onTap(1),
            child: Container(
                height: SizeConfig.padding86,
                width: SizeConfig.padding86,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                )),
          ),
        ),
        Positioned(
          key: const Key("2"),
          top: SizeConfig.screenHeight! * 0.2,
          right: SizeConfig.screenWidth! * 0.235,
          child: GestureDetector(
            onTap: () => onTap(2),
            child: Container(
                height: SizeConfig.padding86,
                width: SizeConfig.padding86,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                )),
          ),
        ),
        Positioned(
          key: const Key("3"),
          top: SizeConfig.screenHeight! * 0.25,
          right: SizeConfig.padding12,
          child: GestureDetector(
            onTap: () => onTap(3),
            child: Container(
                height: SizeConfig.padding86,
                width: SizeConfig.padding86,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                )),
          ),
        ),
        Positioned(
          key: const Key("4"),
          top: SizeConfig.screenHeight! * 0.36,
          right: SizeConfig.screenWidth! * 0.36,
          child: GestureDetector(
            onTap: () => onTap(4),
            child: Container(
                height: SizeConfig.padding82,
                width: SizeConfig.padding82,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                )),
          ),
        ),
        Positioned(
          key: const Key("5"),
          top: SizeConfig.screenHeight! * 0.39,
          right: SizeConfig.padding50,
          child: GestureDetector(
            onTap: () => onTap(5),
            child: Container(
                height: SizeConfig.padding82,
                width: SizeConfig.padding82,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                )),
          ),
        ),
        Positioned(
          key: const Key("6"),
          top: SizeConfig.screenHeight! * 0.5,
          right: SizeConfig.screenWidth! * 0.26,
          child: GestureDetector(
            onTap: () => onTap(6),
            child: Container(
                height: SizeConfig.padding82,
                width: SizeConfig.padding82,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                )),
          ),
        ),
      ],
    );
  }
}

class MoonCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9848696, size.height * 0.8239500);
    path_0.cubicTo(
        size.width * 0.9408609,
        size.height * 0.8406154,
        size.width * 0.8938348,
        size.height * 0.8528808,
        size.width * 0.8442522,
        size.height * 0.8596808);
    path_0.cubicTo(
        size.width * 0.5304609,
        size.height * 0.9028808,
        size.width * 0.2365652,
        size.height * 0.7124923,
        size.width * 0.1878843,
        size.height * 0.4350423);
    path_0.cubicTo(
        size.width * 0.1589470,
        size.height * 0.2695838,
        size.width * 0.2233017,
        size.height * 0.1107935,
        size.width * 0.3464365,
        0);
    path_0.cubicTo(
        size.width * 0.1119230,
        size.height * 0.08959462,
        size.width * -0.03412009,
        size.height * 0.3107815,
        size.width * 0.006874565,
        size.height * 0.5447692);
    path_0.cubicTo(
        size.width * 0.05555565,
        size.height * 0.8224846,
        size.width * 0.3494509,
        size.height * 1.012473,
        size.width * 0.6632391,
        size.height * 0.9694077);
    path_0.cubicTo(
        size.width * 0.7902957,
        size.height * 0.9523423,
        size.width * 0.9010696,
        size.height * 0.8991462,
        size.width * 0.9848696,
        size.height * 0.8240846);
    path_0.lineTo(size.width * 0.9848696, size.height * 0.8239500);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xffF1ADAB7).withOpacity(0.5);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class WavePainter extends CustomPainter {
  late final Animation<double> position;
  final Animation<double> controller;

  /// Number of waves to paint.
  final int waves;

  /// How high the wave should be.
  final double waveAmplitude;

  int get waveSegments => 2 * waves - 1;

  WavePainter(
      {required this.controller,
      required this.waves,
      required this.waveAmplitude}) {
    position = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.linear))
        .animate(controller);
  }

  void drawWave(Path path, int wave, size) {
    double waveWidth = size.width / waveSegments;
    double waveMinHeight = size.height / 2;

    double x1 = wave * waveWidth + waveWidth / 2;
    // Minimum and maximum height points of the waves.
    double y1 = waveMinHeight + (wave.isOdd ? waveAmplitude : -waveAmplitude);

    double x2 = x1 + waveWidth / 2;
    double y2 = waveMinHeight;

    path.quadraticBezierTo(x1, y1, x2, y2);
    if (wave <= waveSegments) {
      drawWave(path, wave + 1, size);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.fill;

    // Draw the waves
    Path path = Path()..moveTo(0, size.height / 2);
    drawWave(path, 0, size);

    // Draw lines to the bottom corners of the size/screen with account for one extra wave.
    double waveWidth = (size.width / waveSegments) * 2;
    path
      ..lineTo(size.width + waveWidth, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.height / 2)
      ..close();

    // Animate sideways one wave length, so it repeats cleanly.
    Path shiftedPath = path.shift(Offset(-position.value * waveWidth, 0));

    canvas.drawPath(shiftedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
