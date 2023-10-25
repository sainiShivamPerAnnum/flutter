import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_slides/autosave_asset_choice_view.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_slides/autosave_setup_view.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AutosaveUpdateView extends StatelessWidget {
  const AutosaveUpdateView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<AutosaveProcessViewModel>(
      onModelReady: (model) => model.updateInit(),
      onModelDispose: (model) => model.updateDump(),
      builder: (context, model, child) => Scaffold(
          backgroundColor: UiConstants.kBackgroundColor,
          appBar: AppBar(
            backgroundColor: UiConstants.kBackgroundColor,
            elevation: 0.0,
            title: model.currentPage <= 3
                ? Text(
                    "${model.currentPage + 1}/2",
                    style: TextStyles.sourceSansL.body3,
                  )
                : Container(),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: UiConstants.kTextColor,
              ),
              onPressed: () => AppState.backButtonDispatcher!.didPopRoute(),
            ),
            actions: const [],
          ),
          resizeToAvoidBottomInset: false,
          body: model.state == ViewState.Busy
              ? const Center(
                  child: FullScreenLoader(),
                )
              : PageView(
                  controller: model.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    AutosaveAssetChoiceView(model: model),
                    AutoPaySetupOrUpdateView(model: model),
                  ],
                )),
    );
  }
}
