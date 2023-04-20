import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tambola/src/utils/assets.dart';
import 'package:tambola/src/utils/styles/styles.dart';

class HowTambolaWorks extends StatelessWidget {
  const HowTambolaWorks({
    super.key,
    // required this.model,
  });

  // final TambolaHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.padding14),
      child: GestureDetector(
        onTap: () {
          //TODO: REVERT WHEN PACAKGE IS SETUP

          // AppState.delegate!.appState.currentAction = PageAction(
          //   state: PageState.addWidget,
          //   page: TambolaNewUser,
          //   widget: TambolaHomeDetailsView(
          //     model: model,
          //     showPrizeSection: false,
          //   ),
          // );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.tambolaInstantView,
              height: 35,
            ),
            Text(
              'How Tambola Works? ',
              style: TextStyles.sourceSansSB.body2.colour(Colors.white),
            ),
            SvgPicture.asset(
              Assets.chevRonRightArrow,
              color: const Color(0xff62E3C4),
              height: SizeConfig.iconSize1,
            ),
          ],
        ),
      ),
    );
  }
}
