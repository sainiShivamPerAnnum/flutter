import 'package:felloapp/core/enums/view_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/widgets/buttons/sell_gold_button/sellGoldBtn_vm.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SellGoldBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<SellGoldBtnVM>(builder: (ctx, model, child) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.grey[300],
          ),
          onPressed: () => model.sellButtonAction(context),
          child: model.state == ViewState.Busy
              ? SpinKitThreeBounce(
                  size: SizeConfig.mediumTextSize,
                  color: Colors.black,
                )
              : Text(
                  'WITHDRAW',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.black),
                ));
    });
  }
}
