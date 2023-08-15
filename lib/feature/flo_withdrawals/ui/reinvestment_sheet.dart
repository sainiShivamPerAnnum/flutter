import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reinvest_slider.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/succesful_deposit_sheet.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReInvestmentSheet extends StatelessWidget {
  const ReInvestmentSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff023C40),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.padding16),
          topRight: Radius.circular(SizeConfig.padding16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding22,
              vertical: SizeConfig.padding18,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.close,
                      color: Colors.white,
                      size: SizeConfig.padding24,
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.padding8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/fello_flo.svg',
                      height: SizeConfig.padding44,
                      width: SizeConfig.padding44,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: SizeConfig.padding8),
                    Text('Your 10% Deposit is maturing',
                        style: TextStyles.rajdhaniSB.body0.colour(Colors.white))
                  ],
                ),
                SizedBox(height: SizeConfig.padding40),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding14,
                      vertical: SizeConfig.padding16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(SizeConfig.padding8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Invested',
                            style: TextStyles.sourceSans.body3
                                .colour(const Color(0xFFBDBDBE)),
                          ),
                          SizedBox(height: SizeConfig.padding4),
                          Text(
                            '₹140',
                            style: TextStyles.sourceSansSB.title5
                                .colour(Colors.white),
                          ),
                          SizedBox(height: SizeConfig.padding8),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding8,
                                  vertical: SizeConfig.padding4),
                              decoration: ShapeDecoration(
                                color:
                                    const Color(0xFFD9D9D9).withOpacity(0.20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.roundness12)),
                              ),
                              child: Text(
                                '3rd June 2023',
                                style: TextStyles.sourceSans.body4
                                    .colour(Colors.white),
                              ))
                        ],
                      ),
                      Column(children: [
                        Text(
                          '6 months',
                          textAlign: TextAlign.center,
                          style:
                              TextStyles.sourceSans.body3.colour(Colors.white),
                        ),
                        CustomPaint(
                          size: Size(SizeConfig.padding64,
                              (SizeConfig.padding64 * 0.12).toDouble()),
                          painter: ArrowCustomPainter(),
                        ),
                        SizedBox(height: SizeConfig.padding8),
                        Text('@10% P.A',
                            style: TextStyles.sourceSansSB.body4.colour(
                              const Color(0xFF3DFFD0),
                            ))
                      ]),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Maturity',
                            style: TextStyles.sourceSans.body3
                                .colour(const Color(0xFFBDBDBE)),
                          ),
                          SizedBox(height: SizeConfig.padding4),
                          Text(
                            '₹150',
                            style: TextStyles.sourceSansSB.title5
                                .colour(const Color(0xFF1AFFD5)),
                          ),
                          SizedBox(height: SizeConfig.padding8),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding8,
                                  vertical: SizeConfig.padding4),
                              decoration: ShapeDecoration(
                                color:
                                    const Color(0xFFD9D9D9).withOpacity(0.20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.roundness12)),
                              ),
                              child: Text(
                                '3rd Sept 2023',
                                style: TextStyles.sourceSans.body4
                                    .colour(Colors.white),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
                const UserDecisionWidget(),
                SizedBox(height: SizeConfig.padding20),
                SlideAction(
                  text: "SLIDE TO Re-Invest",
                  textStyle: TextStyles.rajdhaniB.body1.colour(Colors.black),
                  borderRadius: SizeConfig.padding60,
                  height: SizeConfig.padding56,
                  // sliderButtonIconSize: SizeConfig.padding14,
                  sliderButtonIconPadding: SizeConfig.padding10,
                  outerColor: Colors.white,
                  innerColor: const Color(0xFF00EAC2),
                  sliderRotate: false,
                  onSubmit: () {
                    //Perform required action here, once the slider is fully transversed
                    log("unlocked");
                    Haptic.vibrate();
                    AppState.backButtonDispatcher?.didPopRoute();

                    BaseUtil.openModalBottomSheet(
                      addToScreenStack: true,
                      enableDrag: false,
                      hapticVibrate: true,
                      isBarrierDismissible: true,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      content: SuccessfulDepositSheet(
                        investAmount: '140',
                        maturityAmount: '150',
                        maturityDate: '${DateTime.now()}',
                        reInvestmentDate: '${DateTime.now()}',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // const ReInvestmentBottomWidget()
        ],
      ),
    );
  }
}

class ReInvestmentBottomWidget extends StatelessWidget {
  const ReInvestmentBottomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding24,
        vertical: SizeConfig.padding16,
      ),
      color: Colors.black.withOpacity(0.37),
      width: SizeConfig.screenWidth,
      child: Column(
        children: [
          Text(
            'Get extra 2% on your Investment',
            textAlign: TextAlign.center,
            style: TextStyles.rajdhaniSB.body2.colour(Colors.white),
          ),
          SizedBox(height: SizeConfig.padding16),
          SlideAction(
            text: "SLIDE TO Re-Invest",
            borderRadius: SizeConfig.padding60,
            height: SizeConfig.padding56,
            outerColor: Colors.white,
            innerColor: const Color(0xFF43544F),
            sliderRotate: false,
            onSubmit: () {
              //Perform required action here, once the slider is fully transversed
              log("unlocked");
              Haptic.vibrate();
              AppState.backButtonDispatcher?.didPopRoute();

              BaseUtil.openModalBottomSheet(
                addToScreenStack: true,
                enableDrag: false,
                hapticVibrate: true,
                isBarrierDismissible: true,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                content: SuccessfulDepositSheet(
                  investAmount: '140',
                  maturityAmount: '150',
                  maturityDate: '${DateTime.now()}',
                  reInvestmentDate: '${DateTime.now()}',
                ),
              );
            },
          ),
          SizedBox(height: SizeConfig.padding25),
          Text(
            'I AM HAPPY WITH 8% RETURNS ONLY',
            textAlign: TextAlign.center,
            style: TextStyles.rajdhaniB.body1
                .colour(const Color(0xFFBDBDBE))
                .copyWith(decoration: TextDecoration.underline),
          )
        ],
      ),
    );
  }
}

class UserDecisionWidget extends StatelessWidget {
  const UserDecisionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.padding56,
      width: SizeConfig.screenWidth,
      decoration: ShapeDecoration(
        color: Colors.black.withOpacity(0.37),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Center(
        child: Text(
          "You had chosen to re-invest to 10%",
          style: TextStyles.sourceSans.body3.colour(Colors.white),
        ),
      ),
    );
  }
}

//Copy this CustomPainter code to the Bottom of the File
class ArrowCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9900554, size.height * 0.5261438);
    path_0.cubicTo(
        size.width * 0.9930585,
        size.height * 0.5017362,
        size.width * 0.9930585,
        size.height * 0.4621637,
        size.width * 0.9900554,
        size.height * 0.4377550);
    path_0.lineTo(size.width * 0.9411015, size.height * 0.04000775);
    path_0.cubicTo(
        size.width * 0.9380969,
        size.height * 0.01560000,
        size.width * 0.9332262,
        size.height * 0.01560000,
        size.width * 0.9302231,
        size.height * 0.04000775);
    path_0.cubicTo(
        size.width * 0.9272185,
        size.height * 0.06441550,
        size.width * 0.9272185,
        size.height * 0.1039884,
        size.width * 0.9302231,
        size.height * 0.1283962);
    path_0.lineTo(size.width * 0.9737369, size.height * 0.4819500);
    path_0.lineTo(size.width * 0.9302231, size.height * 0.8355025);
    path_0.cubicTo(
        size.width * 0.9272185,
        size.height * 0.8599113,
        size.width * 0.9272185,
        size.height * 0.8994838,
        size.width * 0.9302231,
        size.height * 0.9238913);
    path_0.cubicTo(
        size.width * 0.9332262,
        size.height * 0.9482987,
        size.width * 0.9380969,
        size.height * 0.9482987,
        size.width * 0.9411015,
        size.height * 0.9238913);
    path_0.lineTo(size.width * 0.9900554, size.height * 0.5261438);
    path_0.close();
    path_0.moveTo(size.width * -0.06724831, size.height * -1.000000);
    // path_0.lineTo(size.width * 0.06700908, size.height * NaN);
    path_0.lineTo(size.width * 0.9846154, size.height * 0.5444500);
    path_0.lineTo(size.width * 0.9846154, size.height * 0.4194500);
    path_0.lineTo(size.width * 0.06724831, size.height * -1.000000);
    // path_0.lineTo(size.width * 0.05162446, size.height * NaN);
    path_0.lineTo(size.width * -0.06724831, size.height * -1.000000);
    // path_0.lineTo(size.width * 0.06700908, size.height * NaN);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xff1ADAB7).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
