import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/tabs/games/cricket/cricket_view.dart';
import 'package:felloapp/ui/pages/tabs/profile/userProfile/userProfile_view.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/widgets/drawer/drawer_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class FDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<FDrawerVM>(
      builder: (ctx, model, child) {
        return Drawer(
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(
                  top: 24, left: SizeConfig.scaffoldMargin, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        AppState.delegate.appState.currentAction = PageAction(
                          state: PageState.addWidget,
                          page: UserProfileDetailsConfig,
                          widget: UserProfileDetails(),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: UiConstants.primaryColor, width: 2),
                              shape: BoxShape.circle,
                            ),
                            child: ProfileImage(
                              height: 0.5,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PropertyChangeConsumer<UserService,
                                  UserServiceProperties>(
                                properties: [UserServiceProperties.myUserName],
                                builder: (context, model, properties) => Text(
                                    model.myUserName,
                                    style: TextStyles.body2.bold),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "@${model.username}",
                                style: TextStyles.body3
                                    .colour(UiConstants.primaryColor),
                              ),
                            ],
                          )
                        ],
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: Column(
                      children: List.generate(
                        6,
                        (index) => Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.account_tree,
                              size: 20,
                              color: Colors.grey[400],
                            ),
                            label: Text(
                              "Share and earn",
                              style: TextStyles.body2.colour(Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      "Version 1.0.0.1",
                      style: TextStyles.body3.colour(Colors.black45),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
