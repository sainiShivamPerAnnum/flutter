import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  String frequencyRename() {
    switch (this) {
      case "Daily":
        return "day";
      case "Weekly":
        return "week";
      case "Monthly":
        return "month";
    }
    return "";
  }
}

extension FRename on FREQUENCY {
  String rename() {
    switch (this) {
      case FREQUENCY.daily:
        return "day";
      case FREQUENCY.weekly:
        return "week";
      case FREQUENCY.monthly:
        return "month";
    }
  }
}

extension UpiRenameExtension on String {
  AppUse formatUpiAppName() {
    switch (this) {
      case "Phonepe":
        return AppUse.PHONE_PE;
      case "Paytm":
        return AppUse.PAYTM;
      case "Google Pay":
        return AppUse.GOOGLE_PAY;
      default:
        return AppUse.PHONE_PE;
    }
  }
}
