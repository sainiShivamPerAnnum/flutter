import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/widgets/buttons/buy_gold_button/buyGoldBtn_vm.dart';
import 'package:felloapp/util/styles/palette.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class BuyGoldBtn extends StatelessWidget {
  final Widget activeButtonUI;
  final Widget loadingButtonUI;
  final Widget disabledButtonUI;
  BuyGoldBtn(
      {this.loadingButtonUI, this.activeButtonUI, this.disabledButtonUI});
  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context);
    return BaseView<BuyGoldBtnVM>(builder: (ctx, model, child) {
      if (connectivityStatus == ConnectivityStatus.Offline)
        return disabledButtonUI != null
            ? disabledButtonUI
            : ElevatedButton(
                onPressed: () => BaseUtil.showNoInternetAlert(),
                style: ElevatedButton.styleFrom(primary: Colors.grey),
                child: Opacity(
                  opacity: 0.7,
                  child: Text("Offline"),
                ),
              );
      else {
        return activeButtonUI != null
            ? InkWell(
                onTap: model.buyButtonAction(context),
                child: model.state == ViewState.Busy
                    ? loadingButtonUI
                    : activeButtonUI)
            : ElevatedButton(
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
                        style: TextStyles.body2.bold.colour(Colors.black),
                      ),
              );
      }
    });
  }
}
