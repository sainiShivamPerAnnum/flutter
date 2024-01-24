import 'dart:math' as math;
import 'package:felloapp/core/model/lendbox_maturity_response.dart';
import 'package:felloapp/core/service/lendbox_maturity_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
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
    return Selector<LendboxMaturityService, int>(
        selector: (_, lendboxMaturityService) =>
            lendboxMaturityService.pendingMaturityCount,
        builder: (_, pendingMaturityAmount, child) {
          return Selector2<LendboxMaturityService, ScratchCardService,
              Tuple2<List<Deposit>?, int>>(
            selector: (p0, lendboxMaturityService, scratchCardService) =>
                Tuple2(lendboxMaturityService.filteredDeposits,
                    scratchCardService.unscratchedTicketsCount),
            builder: (context, value, child) {
              if (!(pendingMaturityAmount > 0 &&
                      (value.item1 != null && value.item1?[0] != null)) &&
                  value.item2 > 0) {
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
                            child: Container(
                              margin:
                                  EdgeInsets.only(left: SizeConfig.padding24),
                              height: SizeConfig.padding74,
                              child: Transform.translate(
                                offset: Offset(-SizeConfig.padding12,
                                    -SizeConfig.padding14),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: SizeConfig.padding10),
                                      child: CustomPaint(
                                        size: Size(
                                            SizeConfig.screenWidth!,
                                            (SizeConfig.screenWidth! * 0.18)
                                                .toDouble()),
                                        painter: RPSCustomPainter(),
                                      ),
                                    ),
                                    Positioned(
                                      top: SizeConfig.padding36 +
                                          SizeConfig.padding1,
                                      left: SizeConfig.padding22,
                                      child: SizedBox(
                                        width: SizeConfig.screenWidth! * 0.83,
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
                                  ],
                                ),
                              ),
                            ),
                          ));
                    });
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        });
  }
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
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
    path_0.lineTo(size.width * 0.6101128, size.height * 0.2966102);
    path_0.cubicTo(
        size.width * 0.6233841,
        size.height * 0.2966102,
        size.width * 0.6352774,
        size.height * 0.2511034,
        size.width * 0.6400152,
        size.height * 0.1822017);
    path_0.lineTo(size.width * 0.6510152, size.height * 0.02226458);
    path_0.lineTo(size.width * 0.6643659, size.height * 0.1904780);
    path_0.cubicTo(
        size.width * 0.6694848,
        size.height * 0.2549864,
        size.width * 0.6809695,
        size.height * 0.2966102,
        size.width * 0.6936524,
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

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_0_stroke.color = Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff323232).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
