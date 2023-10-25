import 'package:felloapp/feature/flo_withdrawals/ui/reinvestment_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/widgets/user_decision_widget.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FloAssetInfoWidget extends StatelessWidget {
  const FloAssetInfoWidget({
    required this.investedAmount,
    required this.investedDate,
    required this.maturityAmount,
    required this.maturityDate,
    required this.decision,
    required this.fdDuration,
    required this.roiPerc,
    required this.fundType,
    required this.isLendboxOldUser,
    super.key,
    this.maturesInDays = 7,
  });

  final String investedAmount;
  final String investedDate;
  final String maturityAmount;
  final String maturityDate;
  final int maturesInDays;
  final UserDecision decision;
  final String fdDuration;
  final String roiPerc;
  final String fundType;
  final bool isLendboxOldUser;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
                width: 1,
                strokeAlign: BorderSide.strokeAlignOutside,
                color: const Color(0xFF326164)),
            borderRadius: BorderRadius.circular(SizeConfig.roundness8),
            // color: Color(0xff023C40),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding20,
                    vertical: SizeConfig.padding16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.roundness8),
                    topRight: Radius.circular(SizeConfig.roundness8),
                  ),
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
                          '₹$investedAmount',
                          style: TextStyles.sourceSansSB.title5
                              .colour(Colors.white),
                        ),
                        SizedBox(height: SizeConfig.padding8),
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
                            investedDate,
                            style: TextStyles.sourceSans.body4
                                .colour(Colors.white),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.padding56,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            fdDuration,
                            textAlign: TextAlign.center,
                            style: TextStyles.sourceSans.body3
                                .colour(Colors.white),
                          ),
                          SvgPicture.asset(
                            'assets/svg/Arrow.svg',
                            width: SizeConfig.padding64,
                          ),
                          Text(
                            '@$roiPerc P.A',
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
                          'You Get',
                          style: TextStyles.sourceSans.body3
                              .colour(const Color(0xFFBDBDBE)),
                        ),
                        SizedBox(height: SizeConfig.padding4),
                        Text(
                          '₹$maturityAmount',
                          style: TextStyles.sourceSansSB.title5
                              .colour(const Color(0xFF1AFFD5)),
                        ),
                        SizedBox(height: SizeConfig.padding8),
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
                              maturityDate,
                              style: TextStyles.sourceSans.body4
                                  .colour(Colors.white),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
              UserDecisionWidget(
                decision: decision,
                fundType: fundType,
                isLendboxOldUser: isLendboxOldUser,
              ),
            ],
          ),
        ),
        if (maturesInDays > 0)
          Align(
            alignment: Alignment.topCenter,
            child: Transform.translate(
              offset: Offset(0, -SizeConfig.padding12),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding8,
                    vertical: SizeConfig.padding2),
                decoration: BoxDecoration(
                  color: const Color(0xFF62E3C4),
                  borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                ),
                child: 'Matures in *$maturesInDays days*'.beautify(
                  boldStyle: TextStyles.sourceSansB.body4.colour(
                    const Color(0xFF013B3F),
                  ),
                  style: TextStyles.sourceSansSB.body4.colour(
                    const Color(0xFF013B3F),
                  ),
                  alignment: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
