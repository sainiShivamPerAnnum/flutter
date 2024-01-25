import 'dart:math' as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/lendbox_maturity_service.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reinvestment_sheet.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FloPendingAction extends StatefulWidget {
  const FloPendingAction({
    super.key,
  });

  @override
  State<FloPendingAction> createState() => _FloPendingActionState();
}

class _FloPendingActionState extends State<FloPendingAction>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animationController?.addListener(listener);
  }

  void listener() {
    if (animationController?.status == AnimationStatus.completed) {
      animationController?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: SizeConfig.padding14),
      child: Consumer<LendboxMaturityService>(builder: (context, model, child) {
        if (model.pendingMaturityCount > 0 &&
            (model.filteredDeposits != null &&
                model.filteredDeposits?[0] != null)) {
          animationController?.forward();
          return AnimatedBuilder(
              animation: animationController!,
              builder: (context, _) {
                final sineValue =
                    math.sin(3 * 2 * math.pi * animationController!.value);
                return Transform.translate(
                  offset: Offset(sineValue * 10, 0),
                  child: GestureDetector(
                    onTap: () {
                      Haptic.vibrate();
                      locator<AnalyticsService>().track(
                        eventName: AnalyticsEvents.pendingActionsFloTapped,
                        properties: {
                          "Transaction count": model.pendingMaturityCount,
                          "initial decision taken": model.userDecision.name,
                          "asset": model.filteredDeposits?[0].fundType,
                          "principal amount":
                              model.filteredDeposits?[0].investedAmt
                        },
                      );
    
                      BaseUtil.openModalBottomSheet(
                        addToScreenStack: true,
                        enableDrag: false,
                        hapticVibrate: true,
                        isBarrierDismissible: false,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        content: ReInvestmentSheet(
                          decision: model.userDecision,
                          depositData: model.filteredDeposits![0],
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: SizeConfig.padding24),
                      height: SizeConfig.padding74,
                      child: Transform.translate(
                        offset:
                            Offset(-SizeConfig.padding12, -SizeConfig.padding14),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding10),
                              child: CustomPaint(
                                size: Size(SizeConfig.screenWidth!,
                                    (SizeConfig.screenWidth! * 0.18).toDouble()),
                                painter: CustomToolTipPainter(),
                              ),
                            ),
                            Positioned(
                              top: SizeConfig.padding36 + SizeConfig.padding1,
                              left: SizeConfig.padding18,
                              child: SizedBox(
                                width: SizeConfig.screenWidth! * 0.9,
                                child: Row(
                                  children: [
                                    Text(
                                      'Pending actions on ${model.pendingMaturityCount} Flo transactions',
                                      style: TextStyles.sourceSans.body2
                                          .colour(Colors.white),
                                    ),
                                    const Spacer(),
                                    Container(
                                      width: SizeConfig.padding20,
                                      height: SizeConfig.padding20,
                                      decoration: const ShapeDecoration(
                                        color: Color(0xFF1ADAB7),
                                        shape: OvalBorder(),
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: SizeConfig.padding12,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: SizeConfig.padding18)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        }
        return const SizedBox.shrink();
      }),
    );
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }
}

class CustomToolTipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.001524390, size.height * 0.4576271);
    path_0.cubicTo(
        size.width * 0.001524390,
        size.height * 0.3687000,
        size.width * 0.01449174,
        size.height * 0.2966102,
        size.width * 0.03048780,
        size.height * 0.2966102);
    path_0.lineTo(size.width * 0.07657774, size.height * 0.2966102);
    path_0.cubicTo(
        size.width * 0.08984665,
        size.height * 0.2966102,
        size.width * 0.1017399,
        size.height * 0.2511034,
        size.width * 0.1064787,
        size.height * 0.1822017);
    path_0.lineTo(size.width * 0.1174787, size.height * 0.02226458);
    path_0.lineTo(size.width * 0.1308277, size.height * 0.1904780);
    path_0.cubicTo(
        size.width * 0.1359470,
        size.height * 0.2549864,
        size.width * 0.1474338,
        size.height * 0.2966102,
        size.width * 0.1601165,
        size.height * 0.2966102);
    path_0.lineTo(size.width * 0.9695122, size.height * 0.2966102);
    path_0.cubicTo(
        size.width * 0.9855091,
        size.height * 0.2966102,
        size.width * 0.9984756,
        size.height * 0.3687000,
        size.width * 0.9984756,
        size.height * 0.4576271);
    path_0.lineTo(size.width * 0.9984756, size.height * 0.8305085);
    path_0.cubicTo(
        size.width * 0.9984756,
        size.height * 0.9194356,
        size.width * 0.9855091,
        size.height * 0.9915254,
        size.width * 0.9695122,
        size.height * 0.9915254);
    path_0.lineTo(size.width * 0.03048777, size.height * 0.9915254);
    path_0.cubicTo(
        size.width * 0.01449174,
        size.height * 0.9915254,
        size.width * 0.001524390,
        size.height * 0.9194356,
        size.width * 0.001524390,
        size.height * 0.8305085);
    path_0.lineTo(size.width * 0.001524390, size.height * 0.4576271);
    path_0.close();

    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint0Stroke.color = const Color(0xff1ADAB7).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Stroke);

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff323232).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
