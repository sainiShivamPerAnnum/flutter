import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:flutter/material.dart';

class CricketHomeViewModel extends BaseModel {
  int currentPage = 0;
  PageController pageController = new PageController(initialPage: 0);
  GameModel gameData = GameModel(
      gameName: "Cricket",
      pageConfig: CricketHomePageConfig,
      tag: 'cricket',
      thumbnailImage:
          "https://www.mpl.live/blog/wp-content/uploads/2020/09/WCC2-mobile-game-becomes-the-worlds-No.1-cricket-game-silently-1.png");
  viewpage(int index) {
    currentPage = index;
    print(currentPage);
    pageController.animateToPage(currentPage,
        duration: Duration(milliseconds: 200), curve: Curves.decelerate);
    refresh();
  }

  init() {}
}
