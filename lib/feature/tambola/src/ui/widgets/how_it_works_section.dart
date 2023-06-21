import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:felloapp/util/haptic.dart';

class HowTambolaWorks extends StatelessWidget {
  const HowTambolaWorks({
    super.key,
    // required this.model,
  });

  // final TambolaHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Haptic.vibrate();
          AppState.delegate!.appState.currentAction = PageAction(
            state: PageState.addWidget,
            page: TambolaNewUser,
            widget: const TambolaHomeDetailsView(
              isStandAloneScreen: true,
              showPrizeSection: false,
            ),
          );
        },
        child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenWidth! * 0.06),
            width: SizeConfig.screenWidth! * 0.88,
            height: SizeConfig.screenHeight! * 0.07,
            decoration: BoxDecoration(
                color: UiConstants.darkPrimaryColor4,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    SizeConfig.roundness12,
                  ),
                )),
            child: Padding(
              padding: EdgeInsets.only(top: SizeConfig.padding16),
              child: Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.padding12,
                      bottom: SizeConfig.padding12,
                      left: SizeConfig.pageHorizontalMargins,
                      right: SizeConfig.pageHorizontalMargins / 2),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.tambolaCardAsset,
                          width: SizeConfig.padding34,
                        ),
                        SizedBox(width: SizeConfig.padding4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "How Tickets Work?",
                            style: TextStyles.sourceSansSB.body2
                                .colour(Colors.white),
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(width: SizeConfig.padding8),
                        SvgPicture.asset(
                          Assets.chevRonRightArrow,
                          color: UiConstants.primaryColor,
                        )
                      ])),
            )));
  }
}
