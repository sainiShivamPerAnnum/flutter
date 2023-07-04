import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class TotalTambolaWon extends StatelessWidget {
  const TotalTambolaWon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userService = locator<UserService>();

    if (userService.userFundWallet?.wTmbLifetimeWin != null &&
        (userService.userFundWallet?.wTmbLifetimeWin ?? 0) > 0) {
      return GestureDetector(
        onTap: () {
          // Haptic.vibrate();
          // AppState.delegate!.appState.currentAction = PageAction(
          //   state: PageState.addWidget,
          //   page: TambolaNewUser,
          //   widget: const TambolaHomeDetailsView(
          //     isStandAloneScreen: true,
          //     showPrizeSection: false,
          //     showBottomButton: false,
          //     showDemoImage: false,
          //   ),
          // );
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.pageHorizontalMargins,
          ),
          width: SizeConfig.screenWidth! * 0.882,
          child: Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.padding12,
              bottom: SizeConfig.padding12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Total Won from Tickets",
                    style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                    maxLines: 1,
                  ),
                ),
                const Spacer(),
                Text(
                  "₹${userService.userFundWallet?.wTmbLifetimeWin}",
                  style: TextStyles.rajdhaniSB.title5.colour(
                    const Color(0xFFFFE9B1),
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const SizedBox();
  }
}
