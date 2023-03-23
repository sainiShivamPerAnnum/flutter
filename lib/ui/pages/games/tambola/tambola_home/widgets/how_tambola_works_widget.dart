import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view/tambola_new_user_page.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view_model/tambola_home_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HowTambolaWorks extends StatelessWidget {
  const HowTambolaWorks({
    super.key,
    required this.model,
  });

  final TambolaHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppState.delegate!.appState.currentAction = PageAction(
          state: PageState.addWidget,
          page: TambolaNewUser,
          widget: TambolaNewUserPage(
            model: model,
            showPrizeSection: false,
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/tambola_instant_view.svg',
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
    );
  }
}
