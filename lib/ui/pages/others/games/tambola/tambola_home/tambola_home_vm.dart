import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:flutter/material.dart';

class TambolaHomeViewModel extends BaseModel {
  int currentPage = 0;
  PageController pageController = new PageController(initialPage: 0);

  viewpage(int index) {
    currentPage = index;
    print(currentPage);
    pageController.animateToPage(currentPage,
        duration: Duration(milliseconds: 200), curve: Curves.decelerate);
    refresh();
  }

  init() {}
}
