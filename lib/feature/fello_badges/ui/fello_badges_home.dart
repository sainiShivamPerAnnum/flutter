import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/model/badges_leader_board_model.dart';
import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/fello_badges/bloc/fello_badges_cubit.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/badges_top_user_widget.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/fello_badges_backround.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/fello_badges_list.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/user_badges_container.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/user_progress_indicator.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/elements/coin_bar/coin_bar_view.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'widgets/badge_level.dart';
import 'widgets/how_superfello_work_widget.dart';

class FelloBadgeHome extends StatelessWidget {
  const FelloBadgeHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FelloBadgesCubit>(
      create: (_) => FelloBadgesCubit(),
      child: const FelloBadgeUi(),
    );
  }
}

class FelloBadgeUi extends StatefulWidget {
  const FelloBadgeUi({super.key});

  @override
  State<FelloBadgeUi> createState() => _FelloBadgeUiState();
}

class _FelloBadgeUiState extends State<FelloBadgeUi> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<FelloBadgesCubit>(context).getFelloBadges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildFAppBar(),
      backgroundColor: const Color(0xFF191919),
      body: FelloBadgesBackground(
        child: BlocBuilder<FelloBadgesCubit, FelloBadgesState>(
          builder: (context, state) {
            return switch (state) {
              FelloBadgesLoading() || FelloBadgesInitial() => const Center(
                  child: FullScreenLoader(),
                ),
              FelloBadgesSuccess() => FelloBadgeSuccessScreen(state: state),
              FelloBadgesError(:final errorMsg) => Center(
                  child: Text(
                    errorMsg,
                    style: TextStyles.sourceSans.title3.colour(Colors.white),
                  ),
                ),
            };
          },
        ),
      ),
    );
  }

  FAppBar buildFAppBar() {
    return FAppBar(
      showHelpButton: true,
      type: FaqsType.yourAccount,
      showCoinBar: false,
      showAvatar: false,
      leadingPadding: false,
      action: Row(children: [
        Selector2<UserService, ScratchCardService, Tuple2<Portfolio?, int>>(
          builder: (context, value, child) => FelloInfoBar(
            svgAsset: Assets.scratchCard,
            size: SizeConfig.padding16,
            child: "₹${value.item1?.rewards.toInt() ?? 0}",
            onPressed: () {
              Haptic.vibrate();
              AppState.delegate!.parseRoute(Uri.parse("myWinnings"));
            },
            mark: value.item2 > 0,
          ),
          selector: (p0, userService, scratchCardService) => Tuple2(
              userService.userPortfolio,
              scratchCardService.unscratchedTicketsCount),
        ),
      ]),
    );
  }
}

class FelloBadgeSuccessScreen extends StatelessWidget {
  const FelloBadgeSuccessScreen({
    required this.state,
    super.key,
  });

  final FelloBadgesSuccess state;

  @override
  Widget build(BuildContext context) {
    final badgesModel = state.felloBadgesModel;
    final leaderBoardModel = state.badgesLeaderBoardModel?.data;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.padding20,
          ),
          SvgPicture.network(
            'https://fello-dev-uploads.s3.ap-south-1.amazonaws.com/super_fello_title.svg',
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          UserBadgeContainer(
            level: state.userLevel,
          ),
          SizedBox(
            height: SizeConfig.padding6,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins),
            child: badgesModel.title.beautify(
              style: TextStyles.rajdhaniSB.body1,
              boldStyle: TextStyles.rajdhaniSB.body1.colour(
                const Color(0xFF26F1CC),
              ),
              alignment: TextAlign.center,
            ),
          ),
          UserProgressIndicator(
            level: state.userLevel,
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),

          BadgeLevel(
            levelsData: badgesModel.levels,
            currentLevel: state.userLevel.level,
          ),

          SizedBox(
            height: SizeConfig.padding34,
          ),

          HowSuperFelloWorksWidget(
            isBoxOpen: false,
            superFelloWorks: badgesModel.superFelloWorks,
          ),

          /// Other badges.
          if (badgesModel.otherBadges.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.padding32,
              ),
              child: OtherBadges(
                otherBadges: badgesModel.otherBadges,
              ),
            ),

          /// Super fello wall of frame.
          if (leaderBoardModel != null &&
              leaderBoardModel.leaderBoard.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.padding16,
              ),
              child: SuperFelloWallFrame(
                badgesLeaderBoard: leaderBoardModel,
              ),
            ),
        ],
      ),
    );
  }
}

class SuperFelloWallFrame extends StatelessWidget {
  const SuperFelloWallFrame({
    required this.badgesLeaderBoard,
    super.key,
  });

  final BadgesLeaderBoardData badgesLeaderBoard;

  @override
  Widget build(BuildContext context) {
    final leaderBoard = badgesLeaderBoard.leaderBoard;
    final heroImage = badgesLeaderBoard.heroImage;
    return Column(
      children: [
        SvgPicture.network(
          heroImage,
          height: SizeConfig.padding80,
          width: SizeConfig.padding68,
          fit: BoxFit.fill,
        ),
        Container(
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding28,
            vertical: SizeConfig.padding42,
          ),
          decoration: const BoxDecoration(color: Color(0xFF1B3637)),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: SizeConfig.padding18,
              mainAxisSpacing: SizeConfig.padding86,
              childAspectRatio: .82,
            ),
            itemCount: leaderBoard.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => BadgesTopUserWidget(
              leaderBoard: leaderBoard[index],
            ),
          ),
        ),
      ],
    );
  }
}

class OtherBadges extends StatelessWidget {
  const OtherBadges({
    super.key,
    this.otherBadges = const [],
  });

  final List<BadgeLevelInformation> otherBadges;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Other Badges on Fello',
          textAlign: TextAlign.center,
          style: TextStyles.rajdhaniB.body2.colour(
            Colors.white,
          ),
        ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
        FelloBadgeList(
          badges: otherBadges,
        ),
      ],
    );
  }
}
