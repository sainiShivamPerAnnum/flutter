import 'dart:convert';
import 'dart:developer';

import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/enums/paytm_service_enums.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/new_user_save.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

const HtmlEscape htmlEscape = HtmlEscape();

class Save extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider<PaytmService, PaytmServiceProperties>(
      value: locator<PaytmService>(),
      child: PropertyChangeProvider<BankAndPanService,
          BankAndPanServiceProperties>(
        value: locator<BankAndPanService>(),
        child: BaseView<SaveViewModel>(
          onModelReady: (model) => model.init(),
          builder: (ctx, model, child) {
            log("ROOT: Save view baseview build called");
            return SaveViewWrapper(model: model);
          },
        ),
      ),
    );
  }
}

class SaveViewWrapper extends StatelessWidget {
  const SaveViewWrapper({Key? key, required this.model}) : super(key: key);
  final SaveViewModel model;
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: [UserServiceProperties.mySegments],
      builder: (_, prop, ___) {
        if (prop!.baseUser!.segments.contains("NEW_USER")) {
          return NewUserSaveView(
            model: model,
          );
        }
        return ListView(
          padding: EdgeInsets.zero,
          cacheExtent: SizeConfig.screenHeight,
          children: model.getSaveViewItems(model),
        );
      },
    );
  }
}
