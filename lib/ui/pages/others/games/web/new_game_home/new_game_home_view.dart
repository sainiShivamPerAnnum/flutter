import 'package:felloapp/ui/pages/others/games/web/new_game_home/leaderboard/leaderboard_view.dart';
import 'package:felloapp/ui/pages/others/games/web/new_game_home/reward/reward_view.dart';
import 'package:flutter/material.dart';

class NewGameHomeView extends StatelessWidget {
  const NewGameHomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WebGameHome();
  }
}

class WebGameHome extends StatefulWidget {
  const WebGameHome({Key key}) : super(key: key);

  @override
  State<WebGameHome> createState() => _WebGameHomeState();
}

class _WebGameHomeState extends State<WebGameHome>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232326),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  "Some Widgets",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Column(
              children: [
                TabBar(
                  controller: _tabController,
                  indicator: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFF62E3C4),
                        width: 5,
                      ),
                    ),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.6),
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 30),
                  tabs: const [
                    Tab(
                      text: 'Rewards',
                    ),
                    Tab(
                      text: 'Laderboard',
                    ),
                  ],
                ),
                _buildTabView(context, 0),
              ],
            ),
            SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  "Some Widgets",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTabView(BuildContext context, int i) {
    return SizedBox(
      height: _tabController.index == 0 ? 300.0 + (68 * 7) : 570.0,
      child: TabBarView(
        children: const [
          RewardView(),
          LeaderBoardView(),
        ],
        controller: _tabController,
      ),
    );
  }
}
