import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view/tambola_existing_user_landing_page.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view/tambola_new_user_page.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view_model/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class TambolaWrapper extends StatelessWidget {
  const TambolaWrapper({Key? key, this.vm}) : super(key: key);
  final RootViewModel? vm;

  @override
  Widget build(BuildContext context) {
    return BaseView<TambolaHomeViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) {
        if (model.state == ViewState.Busy) {
          return const Scaffold(
            body: Center(child: FullScreenLoader()),
            backgroundColor: UiConstants.kBackgroundColor,
          );
        }
        return RefreshIndicator(
          color: UiConstants.primaryColor,
          backgroundColor: Colors.black,
          onRefresh: model.refreshTambolaTickets,
          child: Scaffold(
            body: (model.activeTambolaCardCount ?? 0) > 0
                ? TambolaExistingUserScreen(
                    model: model,
                  )
                : TambolaNewUserPage(
                    model: model,
                    isFromNavigation: locator<RootController>()
                        .navItems
                        .containsValue(RootController.tambolaNavBar),
                  ),
          ),
        );
      },
    );
  }
}
