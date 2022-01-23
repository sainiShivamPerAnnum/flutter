import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/profile/userProfile/userProfile_view.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/service_elements/user_service/user_name_text.dart';
import 'package:felloapp/ui/widgets/drawer/drawer_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<FDrawerVM>(
      builder: (ctx, model, child) {
        return Container(
          width: SizeConfig.screenWidth * 0.7,
          child: Drawer(
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.only(
                    top: 24, left: SizeConfig.scaffoldMargin, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () {
                          if (RootViewModel
                              .scaffoldKey.currentState.isDrawerOpen)
                            RootViewModel.scaffoldKey.currentState
                                .openEndDrawer();
                          AppState.delegate.appState.currentAction = PageAction(
                            state: PageState.addWidget,
                            page: UserProfileDetailsConfig,
                            widget: UserProfileDetails(),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(SizeConfig.padding2),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: UiConstants.primaryColor, width: 2),
                                shape: BoxShape.circle,
                              ),
                              child: ProfileImageSE(
                                radius: SizeConfig.screenWidth * 0.058,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.padding12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(model.name, style: TextStyles.body2.bold),
                                  FittedBox(
                                    child: UserNameTextSE(),
                                  ),
                                  SizedBox(height: 6),
                                  FittedBox(
                                    child: Text(
                                      "@${model.username.replaceAll('@', '.')}",
                                      style: TextStyles.body3
                                          .colour(UiConstants.primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                    SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          model.drawerList.length,
                          (i) => Container(
                            margin: EdgeInsets.symmetric(
                                vertical: SizeConfig.padding8),
                            child: TextButton.icon(
                              onPressed: () {
                                model.onItemSelected(i);
                              },
                              icon: SvgPicture.asset(
                                model.drawerList[i].icon,
                                width: SizeConfig.padding20,
                                color: Color(0xffB8BAC0),
                              ),
                              label: Text(
                                model.drawerList[i].title,
                                style: TextStyles.body2.colour(Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth,
                      margin: EdgeInsets.symmetric(vertical: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Version ${BaseUtil.packageInfo.version} (${BaseUtil.packageInfo.buildNumber})',
                            style: TextStyles.body3.colour(Colors.black45),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            elevation: 0,
          ),
        );
      },
    );
  }
}
