import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/lendbox_maturity_response.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/widgets/flo_asset_info_widget.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/widgets/reinvestment_bottom_widget.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

enum UserDecision { REINVEST, WITHDRAW, MOVETOFLEXI, NOTDECIDED }

class ReInvestmentSheet extends StatelessWidget {
  ReInvestmentSheet(
      {required this.decision, required this.depositData, super.key}) {
    isLendboxOldUser =
        locator<UserService>().userSegments.contains(Constants.US_FLO_OLD);
  }

  final UserDecision decision;
  final Deposit depositData;
  late final bool isLendboxOldUser;

  String getTitle() {
    if (depositData.fundType == Constants.ASSET_TYPE_FLO_FIXED_6) {
      return 'Your 12% Deposit is maturing';
    } else if (depositData.fundType == Constants.ASSET_TYPE_FLO_FIXED_3) {
      return 'Your 10% Deposit is maturing';
    } else if (depositData.fundType == Constants.ASSET_TYPE_FLO_FELXI &&
        isLendboxOldUser) {
      return 'Your 10% Deposit is maturing';
    } else if (depositData.fundType == Constants.ASSET_TYPE_FLO_FELXI &&
        !isLendboxOldUser) {
      return 'Your 8% Deposit is maturing';
    }
    return 'Your 10% Deposit is maturing';
  }

  String formatDate(DateTime dateTime) {
    final format = DateFormat('dd MMM, yyyy');
    return format.format(dateTime);
  }

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
                          locator<AnalyticsService>().track(
                            eventName:
                                AnalyticsEvents.crossTappedOnPendingActions,
                          );
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
                      Text(getTitle(),
                          style:
                              TextStyles.rajdhaniSB.body0.colour(Colors.white))
                    ],
                  ),
                  SizedBox(height: SizeConfig.padding26),
                  FloAssetInfoWidget(
                    investedAmount: (depositData.investedAmt!).toString(),
                    investedDate: formatDate(depositData.investedOn!),
                    maturityAmount: (depositData.maturityAmt!).toString(),
                    maturityDate: formatDate(depositData.maturityOn!),
                    decision: decision,
                    maturesInDays: depositData.maturesInDays ?? 0,
                    fdDuration: depositData.fdDuration!,
                    roiPerc: depositData.roiPerc!,
                    fundType: depositData.fundType!,
                    isLendboxOldUser: isLendboxOldUser,
                  ),
                  SizedBox(
                      height: (decision == UserDecision.MOVETOFLEXI ||
                              decision == UserDecision.WITHDRAW)
                          ? SizeConfig.padding20
                          : SizeConfig.padding10),
                ],
              ),
            ),
            ReInvestmentBottomWidget(
              decision: decision,
              remainingDay: depositData.maturesInDays ?? 0,
              depositData: depositData,
              isLendboxOldUser: isLendboxOldUser,
            )
          ],
        ),
      ),
    );
  }
}
