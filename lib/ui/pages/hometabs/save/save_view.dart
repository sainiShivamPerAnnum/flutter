import 'dart:convert';

import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/enums/paytm_service_enums.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/locator.dart';
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
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: model.getSaveViewItems(model),
              ),
            );
          },
        ),
      ),
    );
  }
}
