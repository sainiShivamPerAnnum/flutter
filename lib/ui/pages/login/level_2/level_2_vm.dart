import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:flutter/cupertino.dart';

class Level2ViewModel extends BaseModel {
  PageController pageController = PageController();
  int _currentPage = 0;

  int get currentPage => _currentPage;

  set currentPage(int val) {
    _currentPage = val;
    notifyListeners();
  }
}
