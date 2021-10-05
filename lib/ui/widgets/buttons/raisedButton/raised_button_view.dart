import 'package:felloapp/core/enums/connectivity_status.dart';
import 'package:felloapp/core/enums/view_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/widgets/buttons/raisedButton/raisedButton_vm.dart';
import 'package:felloapp/ui/elements/network_bar.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RBtn extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Future<void> Function() onPressed;
  final TextStyle textStyle;

  RBtn(
      {@required this.text,
      @required this.onPressed,
      this.textStyle,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context);
    return BaseView<RBtnVM>(
      onModelReady: (model) {},
      builder: (ctx, model, child) {
        if (connectivityStatus == ConnectivityStatus.Offline)
          return NetworkBar(
            textColor: Colors.black,
          );
        else
          return model.state == ViewState.Idle
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: bgColor ?? UiConstants.primaryColor),
                  child: Text(
                    text ?? "Button",
                    style: textStyle ??
                        TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.mediumTextSize),
                  ),
                  onPressed: () => model.executeOnPress(onPressed))
              : Center(
                  child: CircularProgressIndicator(
                    color: UiConstants.primaryColor,
                    backgroundColor: Colors.black,
                  ),
                );
      },
    );
  }
}
