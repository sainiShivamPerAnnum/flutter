import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_sell/augmont_gold_sell_view.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class SellAssetsConfirmationView extends StatelessWidget {
  const SellAssetsConfirmationView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: UiConstants.kBackgroundColor,
        appBar: AppBar(
          backgroundColor: UiConstants.kSecondaryBackgroundColor,
          elevation: 0,
          leading: FelloAppBarBackButton(),
        ),
        body: BaseView<SaveViewModel>(
          onModelReady: (model) => model.init(),
          builder: (context, model, child) => Column(
            children: [],
          ),
        ));
  }
}

class SellingGoldAmountBottomSheet extends StatelessWidget {
  const SellingGoldAmountBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SaleConfirmationDialog extends StatelessWidget {
  const SaleConfirmationDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CountdownWidget extends StatelessWidget {
  const CountdownWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SellConfirmationDialog extends StatelessWidget {
  const SellConfirmationDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
