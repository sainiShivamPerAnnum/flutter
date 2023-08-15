import 'package:felloapp/feature/flo_withdrawals/ui/reinvestment_sheet.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuccessfulDepositSheet extends StatelessWidget {
  const SuccessfulDepositSheet(
      {super.key,
      required this.investAmount,
      required this.maturityAmount,
      required this.maturityDate,
      required this.reInvestmentDate});

  final String investAmount;
  final String maturityAmount;
  final String maturityDate;
  final String reInvestmentDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding22,
        vertical: SizeConfig.padding18,
      ),
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
          // SizedBox(height: SizeConfig.padding8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/fello_flo.svg',
                height: SizeConfig.padding64,
                // width: SizeConfig.padding4,
                // fit: BoxFit.cover,
              ),
              SizedBox(width: SizeConfig.padding8),
              Text('Your New 10% Flo Deposit',
                  style: TextStyles.rajdhaniSB.body0.colour(Colors.white))
            ],
          ),
          SizedBox(height: SizeConfig.padding30),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding18,
                vertical: SizeConfig.padding20),
            // height: SizeConfig.padding152,
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Re-investment on',
                          style: TextStyles.sourceSans.body3
                              .colour(const Color(0xFFBDBDBE)),
                        ),
                        SizedBox(height: SizeConfig.padding4),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding8,
                              vertical: SizeConfig.padding4),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFD9D9D9).withOpacity(0.20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness12)),
                          ),
                          child: Text(
                            '3rd Sept 2023',
                            style: TextStyles.sourceSans.body4
                                .colour(Colors.white),
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Matures on',
                          style: TextStyles.sourceSans.body3
                              .colour(const Color(0xFFBDBDBE)),
                        ),
                        SizedBox(height: SizeConfig.padding4),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding8,
                              vertical: SizeConfig.padding4),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFD9D9D9).withOpacity(0.20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness12)),
                          ),
                          child: Text(
                            '4th Dec 2023',
                            style: TextStyles.sourceSans.body4
                                .colour(Colors.white),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding16,
                ),
                Row(
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
                          '₹$investAmount',
                          style: TextStyles.sourceSansSB.title5
                              .colour(Colors.white),
                        ),
                      ],
                    ),
                    Column(children: [
                      Text(
                        '3 months',
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSans.body3.colour(Colors.white),
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
                          '₹$maturityAmount',
                          style: TextStyles.sourceSansSB.title5
                              .colour(const Color(0xFF1AFFD5)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.padding30),
          Text(
            'Your new transaction will reflect from 3rd Sept',
            textAlign: TextAlign.center,
            style: TextStyles.sourceSans.body3.colour(const Color(0xFFBDBDBE)),
          ),
          SizedBox(height: SizeConfig.padding12),
          MaterialButton(
              minWidth: SizeConfig.screenWidth,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.roundness5),
              ),
              height: SizeConfig.padding44,
              child: Text(
                "GO TO TRANSACTIONS",
                style: TextStyles.rajdhaniB.body1.colour(Colors.black),
              ),
              onPressed: () {}),
          SizedBox(height: SizeConfig.padding12),
        ],
      ),
    );
  }
}
