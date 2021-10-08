import 'package:felloapp/core/enums/pagestate.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/widgets.dart';
import 'package:felloapp/ui/pages/tabs/profile/userProfile/userProfile_view.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/widgets/drawer/drawer_vm.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class FDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<FDrawerVM>(
      builder: (ctx, model, child) {
        return Drawer(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.globalMargin),
                ListTile(
                  onTap: () {
                    AppState.delegate.appState.currentAction = PageAction(
                        state: PageState.addWidget,
                        page: UserProfileDetailsConfig,
                        widget: UserProfileDetails(
                            // needsRefresh: (needsRefresh) {
                            //   if (needsRefresh) {
                            //     model.refreshDrawer();
                            //   }
                            // },
                            ));
                  },
                  leading: ProfileImage(),
                  title: PropertyChangeConsumer<UserService,
                      UserServiceProperties>(
                    properties: [UserServiceProperties.myUserName],
                    builder: (context, model, properties) => Widgets()
                        .getHeadlineBold(
                            text: model.myUserName, color: Colors.black),
                  ),
                  subtitle: Widgets()
                      .getBodyLight("@${model.username}", Colors.black),
                ),
                SizedBox(
                  height: 16,
                ),
                ListTile(
                  title:
                      Widgets().getHeadlineLight("Refer & Earn", Colors.black),
                ),
                ListTile(
                  title: Widgets().getHeadlineLight("PAN & KYC", Colors.black),
                ),
                ListTile(
                  title:
                      Widgets().getHeadlineLight("Transactions", Colors.black),
                ),
                ListTile(
                  title: Widgets()
                      .getHeadlineLight("Help & Support", Colors.black),
                ),
                ListTile(
                  title:
                      Widgets().getHeadlineLight("How it works?", Colors.black),
                ),
                ListTile(
                  title: Widgets()
                      .getHeadlineLight("About Digital Gold", Colors.black),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Widgets().getBodyLight("Version 1.0.0.1", Colors.black),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
