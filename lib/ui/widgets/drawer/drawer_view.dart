import 'package:felloapp/core/enums/pagestate.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/widgets.dart';
import 'package:felloapp/ui/pages/root/root_view.dart';
import 'package:felloapp/ui/widgets/drawer/drawer_viewModel.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';

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
                        state: PageState.addPage,
                        page: UserProfileDetailsConfig);
                  },
                  leading: ProfileImage(
                    height: 0.5,
                  ),
                  title: Widgets()
                      .getHeadlineBold(text: model.name, color: Colors.black),
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
