import 'dart:convert';
import 'dart:developer';

import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/home/card_actions_notifier.dart';
import 'package:felloapp/ui/pages/hometabs/home/cards_home.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

import '../../../../util/styles/styles.dart';

const HtmlEscape htmlEscape = HtmlEscape();

GlobalKey saveViewScrollKey = GlobalKey();

class Save extends StatelessWidget {
  const Save({super.key});

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider<BankAndPanService,
        BankAndPanServiceProperties>(
      value: locator<BankAndPanService>(),
      child: BaseView<SaveViewModel>(
        onModelReady: (model) => model.init(),
        onModelDispose: (model) => model.dump(),
        builder: (ctx, model, child) {
          log("ROOT: Save view baseview build called");
          return SaveViewWrapper(model: model);
        },
      ),
    );
  }
}

class SaveViewWrapper extends StatelessWidget {
  const SaveViewWrapper({required this.model, Key? key}) : super(key: key);
  final SaveViewModel model;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: RootController.controller,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: model.getSaveViewItems(model),
      ),
    );
  }
}
