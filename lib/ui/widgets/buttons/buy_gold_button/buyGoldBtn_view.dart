import 'package:felloapp/core/enums/view_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/widgets/buttons/buy_gold_button/buyGoldBtn_vm.dart';
import 'package:felloapp/util/styles/palette.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BuyGoldBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<BuyGoldBtnVM>(builder: (ctx, model, child) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: FelloColorPalette.augmontFundPalette().primaryColor,
          ),
          onPressed: () => model.buyButtonAction(context),
          child: model.state == ViewState.Busy
              ? SpinKitThreeBounce(
                  size: SizeConfig.mediumTextSize,
                  color: Colors.black,
                )
              : Text(
                  model.getActionButtonText(),
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.black),
                ));
    });
  }
}
