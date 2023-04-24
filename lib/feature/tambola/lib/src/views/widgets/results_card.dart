import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/tambola/lib/src/views/weekly_results/weekly_result.dart';
import 'package:felloapp/feature/tambola/lib/tambola.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class TambolaResultCard extends StatelessWidget {
  // final TambolaHomeViewModel model;
  const TambolaResultCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);
    return Selector<TambolaService, Tuple2<Map<String, int>, bool>>(
        selector: (_, service) => Tuple2(
              service.ticketCodeWinIndex,
              service.isEligible,
            ),
        builder: (context, value, child) => value.item1.isNotEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.padding10),
                child: GestureDetector(
                  onTap: () =>
                      AppState.delegate!.appState.currentAction = PageAction(
                    state: PageState.addWidget,
                    page: TWeeklyResultPageConfig,
                    widget: WeeklyResult(
                      winningsMap: value.item1,
                      isEligible: value.item2,
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                        // top: SizeConfig.pageHorizontalMargins,
                        right: SizeConfig.pageHorizontalMargins,
                        left: SizeConfig.pageHorizontalMargins),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.cardBorderRadius),
                      border: Border.all(
                          color:
                              UiConstants.kModalSheetSecondaryBackgroundColor),
                      color: UiConstants.kModalSheetSecondaryBackgroundColor
                          .withOpacity(0.3),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding4),
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
            : const SizedBox());
  }
}
