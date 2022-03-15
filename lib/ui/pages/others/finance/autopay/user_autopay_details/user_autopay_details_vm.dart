import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:flutter/cupertino.dart';

class UserAutoPayDetailsViewModel extends BaseModel {
  TextEditingController subIdController,
      pUpiController,
      subAmountController,
      subStatusController;
  bool isVerified = true;

  init() {
    subIdController = new TextEditingController(text: "SUB0123456789");
    pUpiController = new TextEditingController(text: "abc@paytm");
    subAmountController = new TextEditingController(text: "40");
    subStatusController = new TextEditingController(text: "Active");
  }
}
