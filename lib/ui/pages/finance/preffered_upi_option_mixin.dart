import 'package:collection/collection.dart';
import 'package:felloapp/util/installed_upi_apps_finder.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:upi_pay/upi_pay.dart';

/// A mixin that provides the preferred UPI option based on consecutive usage
/// count.
///
/// This mixin analyzes the usage history of UPI options and determines the
/// preferred option by finding the UPI name that has been used more than
/// 3 times consecutively.
mixin PaymentIntentMixin {
  List<ApplicationMeta> _appMetaList = [];

  /// List of available psp apps for transaction.
  List<ApplicationMeta> get appMetaList => _appMetaList;

  /// Selected application for payment by user.
  ApplicationMeta? selectedUpiApplication;

  /// Returns the name of the UPI option that has been used more than
  /// or equal to 3 times consecutively, or null if no such option is found.
  ///
  /// Note: Not using cached value of `paymentHistory` as it may be changed
  /// during the lifecycle of application and which may lead to unexpected
  /// behavior for that session being.
  String? get getPreferredUpiOption {
    final paymentIntentsHistory = PreferenceHelper.getPaymentIntentsHistory();

    if (paymentIntentsHistory.isNotEmpty &&
        paymentIntentsHistory.length >= 3 &&
        paymentIntentsHistory.every(
          (e) => e == paymentIntentsHistory[0],
        )) {
      return paymentIntentsHistory.first;
    }

    return null;
  }

  Future<void> initAndSetPreferredPaymentOption() async {
    _appMetaList = await UpiUtils.getUpiApps();
    _setPreferredPayment();
  }

  /// Sets preferred [upiApplication] based on the upi app used by user in
  /// previous transaction.
  ///
  /// Checks if [PaymentIntentMixin.getPreferredUpiOption] exits in device
  /// based on [appMetaList] and if exits then assigns meta to [upiApplication].
  void _setPreferredPayment() {
    final preferredOption =
        getPreferredUpiOption; // optimizing getter for evaluation.
    final preferredAppMeta = appMetaList.firstWhereOrNull(
      (element) => element.upiApplication.appName == preferredOption,
    );
    if (preferredAppMeta != null) {
      selectedUpiApplication = preferredAppMeta;
    }
  }
}
