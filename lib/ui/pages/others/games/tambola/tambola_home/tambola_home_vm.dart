import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:flutter/material.dart';

class TambolaHomeViewModel extends BaseModel {
  int currentPage = 0;
  PageController pageController = new PageController(initialPage: 0);
  GameModel gameData = GameModel(
      gameName: "Tambola",
      pageConfig: THomePageConfig,
      tag: 'tambola',
      thumbnailImage:
          "https://store-images.s-microsoft.com/image/apps.7421.14526104391731353.3efa198c-600d-47e2-a495-171846e34e31.74622fdc-08ff-434d-9cec-a4b5266dc24c?mode=scale&q=90&h=1080&w=1920");
  viewpage(int index) {
    currentPage = index;
    print(currentPage);
    pageController.animateToPage(currentPage,
        duration: Duration(milliseconds: 200), curve: Curves.decelerate);
    refresh();
  }

  init() {}
}
