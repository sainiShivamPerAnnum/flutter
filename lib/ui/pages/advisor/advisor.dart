//Project Imports
import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/ui/pages/advisor/advisor_viewModel.dart';
import 'package:felloapp/ui/pages/support-new/support_viewModel.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
//Flutter Imports
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/styles/ui_constants.dart';

class AdvisorPage extends StatelessWidget {
  const AdvisorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider<BankAndPanService,
        BankAndPanServiceProperties>(
      value: locator<BankAndPanService>(),
      child: BaseView<AdvisorViewModel>(
        onModelReady: (model) => model.init(),
        onModelDispose: (model) => model.dump(),
        builder: (ctx, model, child) {
          return AdvisorViewWrapper(model: model);
        },
      ),
    );
  }
}

class AdvisorViewWrapper extends StatelessWidget {
  const AdvisorViewWrapper({required this.model, Key? key}) : super(key: key);
  final AdvisorViewModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          const NewSquareBackground(
            backgroundColor:
                UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
          ),
          SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                SizedBox(
                    width: SizeConfig.screenWidth,
                    // height: SizeConfig.screenHeight,
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: model.getSaveViewItems(model),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
