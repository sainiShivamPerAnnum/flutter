import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
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
                    builder: (context, model, properties) =>
                        Text(model.myUserName, style: TextStyles.body2.bold),
                  ),
                  subtitle: Text("@${model.username}",
                      style: TextStyles.body3.colour(UiConstants.primaryColor)),
                ),
                SizedBox(
                  height: 16,
                ),
                ListTile(
                  title: Text("Refer & Earn", style: TextStyles.body2),
                ),
                ListTile(
                  title: Text("PAN & KYC", style: TextStyles.body2),
                ),
                ListTile(
                  title: Text("Transactions", style: TextStyles.body2),
                ),
                ListTile(
                  title: Text("Help & Support", style: TextStyles.body2),
                ),
                ListTile(
                  title: Text("How it works?", style: TextStyles.body2),
                ),
                ListTile(
                  title: Text("About Digital Gold", style: TextStyles.body2),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Version 1.0.0.1", style: TextStyles.body3),
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
