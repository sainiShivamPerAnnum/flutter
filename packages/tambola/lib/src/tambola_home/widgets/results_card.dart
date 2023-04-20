import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tambola/src/utils/styles/styles.dart';

import '../../utils/assets.dart';

class TambolaResultCard extends StatelessWidget {
  // final TambolaHomeViewModel model;
  final bool showCard;
  const TambolaResultCard({
    required this.showCard,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);
    return showCard
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.padding10),
            child: GestureDetector(
              onTap: () => {},
              //TODO: REVERT WHEN PACAKGE IS SETUP

              //     AppState.delegate!.appState.currentAction = PageAction(
              //   state: PageState.addWidget,
              //   page: TWeeklyResultPageConfig,
              //   widget: WeeklyResult(
              //     winningsmap: model.ticketCodeWinIndex,
              //     isEligible: model.isEligible,
              //   ),
              // ),
              child: Container(
                margin: EdgeInsets.only(
                    // top: SizeConfig.pageHorizontalMargins,
                    right: SizeConfig.pageHorizontalMargins,
                    left: SizeConfig.pageHorizontalMargins),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.cardBorderRadius),
                  border: Border.all(
                      color: UiConstants.kModalSheetSecondaryBackgroundColor),
                  color: UiConstants.kModalSheetSecondaryBackgroundColor
                      .withOpacity(0.3),
                ),
                padding: EdgeInsets.symmetric(vertical: SizeConfig.padding4),
                child: ListTile(
                  leading: SvgPicture.asset(
                    Assets.tambolaCardAsset,
                    width: SizeConfig.screenWidth! * 0.17,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Tambola Results are out  ',
                          style: TextStyles.rajdhaniB.title3,
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      Text(
                        "Find out if your tickets won",
                        style: TextStyles.sourceSans.body3
                            .colour(Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                  // subtitle:
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
