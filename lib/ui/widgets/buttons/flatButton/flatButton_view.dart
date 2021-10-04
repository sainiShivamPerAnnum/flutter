import 'package:felloapp/core/enums/connectivity_status.dart';
import 'package:felloapp/core/enums/view_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/widgets/buttons/flatButton/flatButton_viewModel.dart';
import 'package:felloapp/ui/elements/network_bar.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FBtn extends StatelessWidget {
  final String text;
  final Function onPressed;
  final TextStyle textStyle;

  FBtn({@required this.text, @required this.onPressed, this.textStyle});

  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context);
    return BaseView<FBtnVM>(
      onModelReady: (model) {},
      builder: (ctx, model, child) {
        if (connectivityStatus == ConnectivityStatus.Offline)
          return NetworkBar(
            textColor: Colors.black,
          );
        else
          return model.state == ViewState.Idle
              ? TextButton(
                  child: Text(
                    text,
                    style: textStyle,
                  ),
                  onPressed: onPressed,
                )
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
