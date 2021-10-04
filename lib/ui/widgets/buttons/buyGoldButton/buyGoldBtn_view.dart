import 'package:felloapp/core/enums/view_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/widgets/buttons/buyGoldButton/buyGoldBtn_viewModel.dart';
import 'package:felloapp/util/palettes.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BuyGoldBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<BuyGoldBtnVM>(builder: (ctx, model, child) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: augmontGoldPalette.primaryColor,
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
