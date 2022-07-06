import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/web/reward_leaderboard/reward_leaderboard_view.dart';
import 'package:felloapp/ui/pages/others/games/web/web_home/web_home_vm.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class NewWebHomeView extends StatefulWidget {
  const NewWebHomeView({Key key, @required this.game}) : super(key: key);
  final String game;

  @override
  State<NewWebHomeView> createState() => _NewWebHomeViewState();
}

class _NewWebHomeViewState extends State<NewWebHomeView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<WebHomeViewModel>(
      onModelReady: (model) {
        model.newInit(widget.game);
      },
      onModelDispose: (model) {
        model.clear();
      },
      builder: (context, model, child) {
        return RefreshIndicator(
          onRefresh: () => model.refreshLeaderboard(),
          child: Scaffold(
            backgroundColor: UiConstants.kBackgroundColor,
            body: SafeArea(
              child: ListView(
                children: [
                  SizedBox(
                    height: 80,
                    child: Center(
                      child: Text(
                        "Some Widgets",
                        style: TextStyles.sourceSans.body3,
                      ),
                    ),
                  ),
                  RewardLeaderboardView(game: widget.game),
                  SizedBox(
                    height: 80,
                    child: Center(
                      child: Text(
                        "Some Widgets",
                        style: TextStyles.sourceSans.body3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
