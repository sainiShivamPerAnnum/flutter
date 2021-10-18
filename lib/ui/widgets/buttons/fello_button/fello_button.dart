import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/ui/elements/network_bar.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

///
/// If passing a custom UI for the button:
///
/// defaultButtonColor: not required
/// defaultButtonText: not required
/// textStyle: not required
/// onPressed: not requried
/// onPressedAsync: not required
///
class FelloButton extends StatefulWidget {
  final ValueChanged<dynamic> action;
  final Function onPressed;
  final Widget activeButtonUI;
  final Widget offlineButtonUI;
  final Widget loadingButtonUI;
  final Color defaultButtonColor;
  final String defaultButtonText;
  final TextStyle textStyle;
  final Function onPressedAsync;

  FelloButton(
      {this.action,
      this.onPressed,
      this.activeButtonUI,
      this.offlineButtonUI,
      this.loadingButtonUI,
      this.defaultButtonColor,
      this.defaultButtonText,
      this.onPressedAsync,
      this.textStyle});

  @override
  _FelloButtonState createState() => _FelloButtonState();
}

class _FelloButtonState extends State<FelloButton> {
  bool isLoading = false;

  updateButtonState(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context);
    if (connectivityStatus == ConnectivityStatus.Offline)
      return widget.offlineButtonUI != null
          ? InkWell(
              onTap: () async {
                if (await BaseUtil.showNoInternetAlert()) return;
              },
              child: widget.offlineButtonUI,
            )
          : ElevatedButton(
              onPressed: () => BaseUtil.showNoInternetAlert(),
              style: ElevatedButton.styleFrom(primary: Colors.grey),
              child: Opacity(
                opacity: 0.7,
                child: Text(widget.defaultButtonText ?? "Button"),
              ),
            );
    else {
      if (isLoading)
        return widget.loadingButtonUI != null
            ? widget.loadingButtonUI
            : SpinKitThreeBounce(
                size: SizeConfig.mediumTextSize,
                color: UiConstants.primaryColor,
              );
      else
        return widget.activeButtonUI != null
            ? InkWell(
                onTap: () async {
                  if (await BaseUtil.showNoInternetAlert()) return;
                  if (Platform.isAndroid)
                    HapticFeedback.vibrate();
                  else
                    HapticFeedback.lightImpact();
                  if (widget.onPressedAsync != null) {
                    if (widget.action != null)
                      widget.action(true);
                    else
                      updateButtonState(true);
                    await widget.onPressedAsync();
                    if (widget.action != null)
                      widget.action(false);
                    else
                      updateButtonState(false);
                  }
                  if (widget.onPressed != null) widget.onPressed();
                },
                child: widget.activeButtonUI)
            : TextButton(
                onPressed: () async {
                  if (await BaseUtil.showNoInternetAlert()) return;

                  if (Platform.isAndroid)
                    HapticFeedback.vibrate();
                  else
                    HapticFeedback.lightImpact();
                  if (widget.onPressedAsync != null) {
                    if (widget.action != null)
                      widget.action(true);
                    else
                      updateButtonState(true);
                    await widget.onPressedAsync();
                    if (widget.action != null)
                      widget.action(false);
                    else
                      updateButtonState(false);
                  }
                  if (widget.onPressed != null) widget.onPressed();
                },
                child: Text(
                  widget.defaultButtonText ?? "Button",
                  style: widget.textStyle ?? TextStyles.body2.bold,
                ),
              );
    }
  }
}

class DemoButton extends FelloButton {
  DemoButton(
      {Key key,
      Function onPressed,
      activeButtonUI,
      ValueChanged action,
      offlineButtonUI,
      Color defaultButtonColor,
      String defaultButtonText,
      Function onPressedAsync,
      TextStyle textStyle})
      : super(
            onPressed: onPressed,
            activeButtonUI: activeButtonUI,
            action: action,
            offlineButtonUI: offlineButtonUI,
            defaultButtonColor: defaultButtonColor,
            defaultButtonText: defaultButtonText,
            onPressedAsync: onPressedAsync,
            textStyle: textStyle);
}
