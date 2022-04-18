import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AutosaveServices {
  static getGradient(ActiveSubscriptionModel subscription) {
    if (subscription == null)
      return new LinearGradient(
        colors: [UiConstants.autosaveColor, UiConstants.autosaveColor],
      );
    if (subscription.status == Constants.SUBSCRIPTION_INACTIVE &&
        subscription.autoAmount != 0.0 &&
        subscription.resumeDate.isNotEmpty) {
      return new LinearGradient(
          colors: [Color(0xffFD746C), Color(0xffFF9068)],
          begin: Alignment.topLeft,
          end: Alignment.centerRight);
    } else if (subscription.status == Constants.SUBSCRIPTION_INACTIVE &&
        subscription.autoAmount != 0.0 &&
        subscription.resumeDate.isEmpty) {
      return new LinearGradient(
        colors: [Color(0xffEACDA3), Color(0xffD6AE7B)],
      );
    } else
      return new LinearGradient(
        colors: [UiConstants.autosaveColor, UiConstants.autosaveColor],
      );
  }
}
