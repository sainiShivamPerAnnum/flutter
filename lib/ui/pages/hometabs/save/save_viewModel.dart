import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/screen_item.dart';
import 'package:felloapp/core/enums/view_state.dart';
import 'package:felloapp/core/fcm_listener.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_viewmodel.dart';
import 'package:felloapp/ui/dialogs/augmont_disabled_dialog.dart';
import 'package:felloapp/ui/dialogs/success-dialog.dart';
import 'package:felloapp/ui/modals/augmont_deposit_modal_sheet.dart';
import 'package:felloapp/ui/modals/augmont_register_modal_sheet.dart';
import 'package:felloapp/ui/pages/tabs/finance/augmont/augmont-details.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class SaveViewModel extends BaseModel {
  BaseUtil _baseUtil = locator<BaseUtil>();

  getGoldBalance() {
    return _baseUtil.userFundWallet.augGoldQuantity ?? 0.0;
  }

  getUnclaimedPrizeBalance() {
    return _baseUtil.userFundWallet.prizeLifetimeWin ?? 0.0;
  }
}
