import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/service_elements/user_service/user_winnings.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class WinningsContainer extends StatelessWidget {
  final bool shadow;
  final Widget child;
  WinningsContainer({this.child, @required this.shadow});

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return InkWell(
      onTap: () => AppState.delegate.appState.currentAction =
          PageAction(state: PageState.addPage, page: MyWinnigsPageConfig),
      child: Container(
        decoration: BoxDecoration(
            color: UiConstants.primaryColor,
            borderRadius: BorderRadius.circular(SizeConfig.roundness32),
            boxShadow: [
              if (shadow)
                BoxShadow(
                  blurRadius: 30,
                  color: UiConstants.primaryColor.withOpacity(0.5),
                  offset: Offset(
                    0,
                    SizeConfig.screenWidth * 0.1,
                  ),
                  spreadRadius: -30,
                )
            ]),
        height: SizeConfig.screenWidth * 0.3,
        margin:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.06,
              child: Image.asset(
                Assets.whiteRays,
                fit: BoxFit.cover,
                width: SizeConfig.screenWidth,
              ),
            ),
            child != null
                ? child
                : Container(
                    width: SizeConfig.screenWidth,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(SizeConfig.padding16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          locale.winMyWinnings,
                          style: TextStyles.title5.colour(Colors.white60),
                        ),
                        SizedBox(height: SizeConfig.padding8),
                        UserWinningsSE(
                          style: TextStyles.title1
                              .colour(Colors.white)
                              .weight(FontWeight.w900)
                              .letterSpace(2),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
