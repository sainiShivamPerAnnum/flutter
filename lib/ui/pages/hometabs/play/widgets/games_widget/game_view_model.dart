import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/locator.dart';

class GameViewModel {
  List<GameTiers> gameTiers;
  final String title;
  final UserFundWallet _wallet;

  GameViewModel(this.gameTiers, this.title)
      : _wallet = locator<UserService>().userFundWallet!;

  void processData() {
    for (var i = 0; i < gameTiers.length; i++) {
      _setLockedFlag(i);
      _setProgressIndicatorFlag(i);
      _createTitleAndSubtitle(i);
      gameTiers[i].netWorth = _wallet.netWorth!;
    }
  }

  void _setLockedFlag(int index) {
    final gameTier = gameTiers[index];
    if (_wallet.netWorth! >= gameTier.level.minAmount) {
      gameTier.isLocked = false;
    } else {
      gameTier.isLocked = true;
    }
  }

  //[TODO] : Factory Function for converting [model] into [view model]

  void _setProgressIndicatorFlag(int index) {
    if (index == 0) return;
    final gameTier = gameTiers[index];
    if (gameTiers[index - 1].isLocked == false) {
      if (gameTier.isLocked) {
        gameTier.amountToCompleteLevel =
            gameTier.level.minAmount - _wallet.netWorth!;
        gameTier.showProgressIndicator = true;
        gameTier.shadow = 0.3;
      }
    } else {
      gameTier.showProgressIndicator = false;
      gameTier.shadow = 0.5;
    }
  }

  void _createTitleAndSubtitle(int index) {
    final gameTier = gameTiers[index];
    String title = '';
    String subtitle = '';

    title = 'Level ${index + 1} Games';
    subtitle = 'For total savings upto ₹${gameTier.level.maxAmount}';

    gameTier.title = title;
    gameTier.subTitle = subtitle;
  }
}

class GameTiers {
  Level level;
  String title;
  String subTitle;
  bool showProgressIndicator;
  bool isLocked;
  double shadow;
  List<GameModel> games;
  bool showBuyButton;
  double amountToCompleteLevel;
  double netWorth;

  GameTiers({
    required this.level,
    this.amountToCompleteLevel = 0,
    this.title = '',
    this.subTitle = '',
    this.showProgressIndicator = false,
    this.isLocked = false,
    this.netWorth = 0.0,
    required this.games,
    this.showBuyButton = false,
    this.shadow = 0.0,
  });
}

class GameConstants {
  static const level = [
    Level(0, 2000),
    Level(2000, 5000),
    Level(5000, 10000),
    Level(10000, 100000)
  ];
}

class Level {
  final int maxAmount;
  final int minAmount;

  const Level(this.minAmount, this.maxAmount);
}

final viewModel = GameViewModel(
    List.generate(
        4,
        (index) => GameTiers(
              games: locator<GameRepo>().games!.sublist(0, 3),
              level: GameConstants.level[index],
            )),
    "All Games");
