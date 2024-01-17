import 'dart:math' as math;

import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class TicketsPendingAction extends StatefulWidget {
  const TicketsPendingAction({
    super.key,
  });

  @override
  State<TicketsPendingAction> createState() => _TicketsPendingActionState();
}

class _TicketsPendingActionState extends State<TicketsPendingAction>
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
    final locale = locator<S>();
    return Selector<TambolaService, int>(
        selector: (_, tambolaService) => tambolaService.tambolaTicketCount,
        builder: (_, ticketCount, child) {
          return Selector2<UserService, ScratchCardService,
              Tuple2<Portfolio?, int>>(
            selector: (p0, userService, scratchCardService) => Tuple2(
                userService.userPortfolio,
                scratchCardService.unscratchedTicketsScratchCardCount),
            builder: (context, value, child) {
              if (value.item2 > 0) {
                animationController?.forward();
                return AnimatedBuilder(
                    animation: animationController!,
                    builder: (context, _) {
                      final sineValue = math
                          .sin(3 * 2 * math.pi * animationController!.value);
                      return Transform.translate(
                          offset: Offset(sineValue * 10, 0),
                          child: GestureDetector(
                              onTap: () {
                                Haptic.vibrate();
                                AppState.delegate!
                                    .parseRoute(Uri.parse("myWinnings"));
                              },
                              child: CustomPaint(
                                size: Size(
                                    SizeConfig.screenWidth!,
                                    (SizeConfig.screenHeight! * 0.12)
                                        .toDouble()),
                                painter: RPSCustomPainter(),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: SizeConfig.padding14,
                                      left: SizeConfig.padding38,
                                      right: SizeConfig.padding38),
                                  child: SizedBox(
                                    height: SizeConfig.screenHeight! * 0.12,
                                    child: Row(
                                      children: [
                                        Text(
                                          locale.ticketsWiting,
                                          style: TextStyles.sourceSans.body2
                                              .colour(Colors.white),
                                        ),
                                        const Spacer(),
                                        Container(
                                          width: SizeConfig.padding20,
                                          height: SizeConfig.padding20,
                                          decoration: const ShapeDecoration(
                                            color: Color(0xFFFFD979),
                                            shape: OvalBorder(),
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: SizeConfig.padding12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )));
                    });
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        });
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.05434783, size.height * 0.3333333);
    path_0.cubicTo(
        size.width * 0.05434783,
        size.height * 0.2775475,
        size.width * 0.06651413,
        size.height * 0.2323232,
        size.width * 0.08152174,
        size.height * 0.2323232);
    path_0.lineTo(size.width * 0.5981440, size.height * 0.2323232);
    path_0.cubicTo(
        size.width * 0.6094076,
        size.height * 0.2323232,
        size.width * 0.6195054,
        size.height * 0.2064949,
        size.width * 0.6235272,
        size.height * 0.1673879);
    path_0.lineTo(size.width * 0.6345109, size.height * 0.06060606);
    path_0.lineTo(size.width * 0.6477418, size.height * 0.1720848);
    path_0.cubicTo(
        size.width * 0.6520870,
        size.height * 0.2086980,
        size.width * 0.6618370,
        size.height * 0.2323232,
        size.width * 0.6726033,
        size.height * 0.2323232);
    path_0.lineTo(size.width * 0.9184783, size.height * 0.2323232);
    path_0.cubicTo(
        size.width * 0.9334864,
        size.height * 0.2323232,
        size.width * 0.9456522,
        size.height * 0.2775475,
        size.width * 0.9456522,
        size.height * 0.3333333);
    path_0.lineTo(size.width * 0.9456522, size.height * 0.5555556);
    path_0.cubicTo(
        size.width * 0.9456522,
        size.height * 0.6113414,
        size.width * 0.9334864,
        size.height * 0.6565657,
        size.width * 0.9184783,
        size.height * 0.6565657);
    path_0.lineTo(size.width * 0.08152174, size.height * 0.6565657);
    path_0.cubicTo(
        size.width * 0.06651386,
        size.height * 0.6565657,
        size.width * 0.05434783,
        size.height * 0.6113414,
        size.width * 0.05434783,
        size.height * 0.5555556);
    path_0.lineTo(size.width * 0.05434783, size.height * 0.3333333);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff323232).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.05570652, size.height * 0.3333333);
    path_1.cubicTo(
        size.width * 0.05570652,
        size.height * 0.2803364,
        size.width * 0.06726440,
        size.height * 0.2373737,
        size.width * 0.08152174,
        size.height * 0.2373737);
    path_1.lineTo(size.width * 0.5981440, size.height * 0.2373737);
    path_1.cubicTo(
        size.width * 0.6099728,
        size.height * 0.2373737,
        size.width * 0.6205734,
        size.height * 0.2102535,
        size.width * 0.6247962,
        size.height * 0.1691909);
    path_1.lineTo(size.width * 0.6346005, size.height * 0.07387485);
    path_1.lineTo(size.width * 0.6465000, size.height * 0.1741232);
    path_1.cubicTo(
        size.width * 0.6510625,
        size.height * 0.2125677,
        size.width * 0.6612989,
        size.height * 0.2373737,
        size.width * 0.6726033,
        size.height * 0.2373737);
    path_1.lineTo(size.width * 0.9184783, size.height * 0.2373737);
    path_1.cubicTo(
        size.width * 0.9327364,
        size.height * 0.2373737,
        size.width * 0.9442935,
        size.height * 0.2803364,
        size.width * 0.9442935,
        size.height * 0.3333333);
    path_1.lineTo(size.width * 0.9442935, size.height * 0.5555556);
    path_1.cubicTo(
        size.width * 0.9442935,
        size.height * 0.6085525,
        size.width * 0.9327364,
        size.height * 0.6515152,
        size.width * 0.9184783,
        size.height * 0.6515152);
    path_1.lineTo(size.width * 0.08152174, size.height * 0.6515152);
    path_1.cubicTo(
        size.width * 0.06726440,
        size.height * 0.6515152,
        size.width * 0.05570652,
        size.height * 0.6085525,
        size.width * 0.05570652,
        size.height * 0.5555556);
    path_1.lineTo(size.width * 0.05570652, size.height * 0.3333333);
    path_1.close();

    Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint1Stroke.color = const Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_1, paint1Stroke);

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = const Color(0xff323232).withOpacity(1.0);
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
