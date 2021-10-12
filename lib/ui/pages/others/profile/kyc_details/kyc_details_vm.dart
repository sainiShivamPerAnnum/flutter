import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:flutter/cupertino.dart';

class KYCDetailsViewModel extends BaseModel {
  String stateChosenValue;
  TextEditingController nameController, panController;
  bool inEditMode = true;
  bool isUpadtingKycDetails = false;

  init() {
    nameController = new TextEditingController();
    panController = new TextEditingController();
    checkForKycExistence();
  }

  updateKYCDetails() {}

  onStateSelected(String newVal) {
    stateChosenValue = newVal;
    notifyListeners();
  }

  checkForKycExistence() {}
}
