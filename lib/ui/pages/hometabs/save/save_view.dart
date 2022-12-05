import 'dart:convert';
import 'dart:developer';

import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/save_banner.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

const HtmlEscape htmlEscape = HtmlEscape();

class Save extends StatelessWidget {
  final CustomLogger? logger = locator<CustomLogger>();

  @override
  Widget build(BuildContext context) {
    log("ROOT: Save view build called");
    return BaseView<SaveViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        log("ROOT: Save view baseview build called");
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: FAppBar(
            type: FaqsType.savings,
            backgroundColor: UiConstants.kSecondaryBackgroundColor,
          ),
          body: Stack(
            children: [
              SizedBox(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                child: ListView(
                  children: model.getSaveViewItems(model),
                ),
              ),
              Positioned(bottom: SizeConfig.navBarHeight, child: SaveBanner())
            ],
          ),
        );
      },
    );
  }
}
