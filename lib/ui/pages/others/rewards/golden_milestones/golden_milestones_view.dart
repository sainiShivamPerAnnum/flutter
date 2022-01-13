import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_milestones/golden_milestones_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class GoldenMilestonesView extends StatelessWidget {
  const GoldenMilestonesView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<GoldenMilestonesViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.primaryColor,
          body: HomeBackground(
            child: Column(
              children: [
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  title: "Milestones",
                ),
                Expanded(
                  child: Container(
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(SizeConfig.padding40),
                        topRight: Radius.circular(SizeConfig.padding40),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Upcoming rewards", style: TextStyles.title4),
                        SizedBox(height: SizeConfig.padding2),
                        Text("Complete task, earn rewards!",
                            style: TextStyles.body4),
                        SizedBox(height: SizeConfig.padding12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: UiConstants.primaryColor, width: 2),
                          ),
                          padding: EdgeInsets.all(SizeConfig.padding4),
                          child: ProfileImageSE(radius: SizeConfig.padding16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
