import 'package:felloapp/core/model/game_tier_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/locator.dart';

class GameViewModel {
  List<GameTier> gameTiers;

  final UserFundWallet _wallet;

  GameViewModel(this.gameTiers)
      : _wallet = locator<UserService>().userFundWallet!;

  void processData() {
    for (var i = 0; i < gameTiers.length; i++) {
      _setLockedFlag(i);
      _setProgressIndicatorFlag(i);

      gameTiers[i].netWorth = _wallet.netWorth!;
    }
  }

  void _setLockedFlag(int index) {
    final gameTier = gameTiers[index];
    if (_wallet.netWorth! >= gameTier.level) {
      gameTier.isLocked = false;
    
        gameTier.subTitle =index==0? "":'Maintain min ₹${gameTier.level} balance to play';
    } else {
      gameTier.isLocked = true;
    }
  }

  factory GameViewModel.fromGameTier(GameTiers model) {
    List<GameTier> _games = [];

    model.data.forEach((element) {
      _games.add(
        GameTier(
            winningSubtext: element!.winningSubtext,
            winningText: element.winningText,
            title: element.title,
            subTitle: element.subtitle,
            level: element.minInvestmentToUnlock,
            games: element.games),
      );
    });
    return GameViewModel(_games);
  }

  void _setProgressIndicatorFlag(int index) {
    if (index == 0) return;
    final gameTier = gameTiers[index];
    if (gameTiers[index - 1].isLocked == false) {
      if (gameTier.isLocked) {
        gameTier.amountToCompleteLevel = gameTier.level - _wallet.netWorth!;
        gameTier.showProgressIndicator = true;
        gameTier.shadow = 0.3;
      }
    } else {
      gameTier.showProgressIndicator = false;
      gameTier.shadow = 0.5;
    }
  }
}

class GameTier {
  double level;
  String title;
  String subTitle;
  bool showProgressIndicator;
  bool isLocked;
  double shadow;
  List<GameModel?> games;
  bool showBuyButton;
  double amountToCompleteLevel;
  double netWorth;
  String winningText;
  String winningSubtext;

  GameTier(
      {required this.level,
      this.amountToCompleteLevel = 0,
      this.title = '',
      this.subTitle = '',
      this.showProgressIndicator = false,
      this.isLocked = false,
      this.netWorth = 0.0,
      required this.games,
      this.showBuyButton = false,
      this.shadow = 0.0,
      this.winningText = '',
      this.winningSubtext = ''});
}
