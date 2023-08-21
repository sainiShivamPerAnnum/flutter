import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotDecidedModalSheet extends StatelessWidget {
  const NotDecidedModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.removeOverlay();
        return true;
      },
      child: Container(
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
                      GestureDetector(
                        onTap: () {
                          AppState.backButtonDispatcher?.didPopRoute();
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: SizeConfig.padding24,
                        ),
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
                          style:
                              TextStyles.rajdhaniSB.body0.colour(Colors.white))
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        SizedBox(
                          height: SizeConfig.padding56,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '6 months',
                                textAlign: TextAlign.center,
                                style: TextStyles.sourceSans.body3
                                    .colour(Colors.white),
                              ),
                              SvgPicture.asset(
                                'assets/svg/Arrow.svg',
                                width: SizeConfig.padding64,
                              ),
                              Text(
                                '@10% P.A',
                                style: TextStyles.sourceSansSB.body4.colour(
                                  const Color(0xFF3DFFD0),
                                ),
                              )
                            ],
                          ),
                        ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
