import 'package:felloapp/feature/flo_withdrawals/ui/widgets/flo_asset_info_widget.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/widgets/reinvestment_bottom_widget.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum UserDecision { REINVEST, WITHDRAW, MOVETO8, NOTDECIDED }

class ReInvestmentSheet extends StatelessWidget {
  const ReInvestmentSheet({required this.decision, super.key});

  final UserDecision decision;

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
                    mainAxisAlignment: MainAxisAlignment.start,
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
                  SizedBox(height: SizeConfig.padding26),
                  FloAssetInfoWidget(
                    investedAmount: '140',
                    investedDate: '3rd June 2023',
                    maturityAmount: '150',
                    maturityDate: '3rd Sept 2023',
                    decision: decision,
                  ),
                  SizedBox(
                      height: (decision == UserDecision.MOVETO8 ||
                              decision == UserDecision.WITHDRAW)
                          ? SizeConfig.padding20
                          : SizeConfig.padding10),
                ],
              ),
            ),
            ReInvestmentBottomWidget(
              decision: decision,
              remainingDay: 7,
            )
          ],
        ),
      ),
    );
  }
}

