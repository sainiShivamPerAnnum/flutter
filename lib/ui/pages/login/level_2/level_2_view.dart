import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/level_2/level_2_vm.dart';
import 'package:felloapp/ui/pages/login/level_2/screens/choose_avatar_input/choose_avatar.dart';

import 'package:felloapp/ui/pages/login/level_2/screens/dob_input/dob_4.0.dart';

import 'package:felloapp/ui/pages/login/level_2/screens/email_input/email_4.0.dart';
import 'package:felloapp/ui/pages/login/level_2/screens/name_input/name_4.0.dart';
import 'package:felloapp/ui/pages/login/login_components/tm_button_4.0.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Level2View extends StatefulWidget {
  final int initPage;
  Level2View({Key key, this.initPage}) : super(key: key);

  @override
  State<Level2View> createState() => _Level2ViewState();
}

class _Level2ViewState extends State<Level2View> {
  @override
  Widget build(BuildContext context) {
    return BaseView<Level2ViewModel>(
      onModelReady: (model) {},
      builder: (ctx, model, child) => Stack(
        children: [
          NewSquareBackground(),
          if (model.currentPage != 0)
            Container(
              height: SizeConfig.screenHeight * 0.5,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff135756),
                    UiConstants.kBackgroundColor,
                  ],
                ),
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.screenWidth * 1.7,
                child: PageView(
                  controller: model.pageController,
                  onPageChanged: (val) {
                    model.currentPage = val;
                  },
                  children: [
                    //TODO: CHANGE ALL SIZES FROM HERE.
                    ChooseAvatar4(),
                    Name4(),
                    Email4(),
                    DOB4(),
                  ],
                ),
              ),
              Spacer(),
              if (model.currentPage == 0)
                Center(
                  child: Container(
                    width: SizeConfig.screenWidth * 0.136,
                    height: SizeConfig.screenWidth * 0.136,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF01656B),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/svg/arrow_svg.svg',
                        height: SizeConfig.screenWidth * 0.066,
                        width: SizeConfig.screenWidth * 0.069,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              if (model.currentPage == 1 ||
                  model.currentPage == 2 ||
                  model.currentPage == 3)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding35,
                  ),
                  child: AppPositiveBtn(
                    btnText: 'Next',
                    onPressed: () {},
                    width: SizeConfig.screenWidth,
                  ),
                ),
              SizedBox(
                height: SizeConfig.padding32,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
