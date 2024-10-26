import 'dart:convert';
import 'dart:developer';

import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

const HtmlEscape htmlEscape = HtmlEscape();

GlobalKey saveViewScrollKey = GlobalKey();

class Save extends StatelessWidget {
  const Save({super.key});

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider<BankAndPanService,
        BankAndPanServiceProperties>(
      value: locator<BankAndPanService>(),
      child: ChangeNotifierProvider.value(
        value: locator<SaveViewModel>()..init(),
        builder: (ctx, child) {
          log("ROOT: Save view baseview build called");
          return SaveViewWrapper(model: locator<SaveViewModel>());
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
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      color: UiConstants.primaryColor,
      backgroundColor: Colors.black,
      onRefresh: () async {
        await model.pullRefresh();
      },
      child: SingleChildScrollView(
        controller: RootController.controller,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: model.getSaveViewItems(model),
        ),
      ),
    );
  }
}
