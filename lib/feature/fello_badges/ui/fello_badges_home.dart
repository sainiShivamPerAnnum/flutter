import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/fello_badges/bloc/fello_badges_cubit.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/badges_top_user_widget.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/fello_badges_backround.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/fello_badges_details.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/fello_badges_list.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/how_superfello_work_widget.dart';
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
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
  Color badgeBorderColor = const Color(0xFFFFD979);
  String badgeUrl = 'https://d37gtxigg82zaw.cloudfront.net/loyalty/level-0.svg';

  @override
  void initState() {
    super.initState();

    BlocProvider.of<FelloBadgesCubit>(context).getFelloBadges();
  }

  void updateUserBadge(int? level) {
    switch (level) {
      case 1:
        badgeBorderColor = Colors.white.withOpacity(0.30);
        badgeUrl = '';
        break;
      case 2:
        badgeBorderColor = const Color(0xFFF79780);
        badgeUrl = 'https://d37gtxigg82zaw.cloudfront.net/loyalty/level-0.svg';
        break;

      case 3:
        badgeBorderColor = const Color(0xFF93B5FE);
        badgeUrl = 'https://d37gtxigg82zaw.cloudfront.net/loyalty/level-1.svg';
        break;

      case 4:
        badgeBorderColor = const Color(0xFFFFDA72);
        badgeUrl = 'https://d37gtxigg82zaw.cloudfront.net/loyalty/level-2.svg';
        break;

      default:
        badgeBorderColor = Colors.white.withOpacity(0.30);
        badgeUrl = '';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
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
      ),
      backgroundColor: const Color(0xFF191919),
      body: FelloBadgesBackground(
        child: BlocBuilder<FelloBadgesCubit, FelloBadgesState>(
          builder: (context, state) {
            if (state is FelloBadgesError) {
              return Center(
                child: Text(state.errorMsg!),
              );
            }

            if (state is FelloBadgesSuccess) {
              updateUserBadge(state.currentLevel);

              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.padding32,
                    ),
                    SvgPicture.network(
                        'https://fello-dev-uploads.s3.ap-south-1.amazonaws.com/super_fello_title.svg'),
                    SizedBox(
                      height: SizeConfig.padding12,
                    ),
                    UserBadgeContainer(
                      badgeColor: badgeBorderColor,
                      badgeUrl: badgeUrl,
                    ),
                    SizedBox(
                      height: SizeConfig.padding12,
                    ),
                    state.felloBadgesModel.title!.beautify(
                      style: TextStyles.rajdhaniB.body1.colour(
                        state.felloBadgesModel.titleColor!.toColor(),
                      ),
                      boldStyle: TextStyles.rajdhaniB.body1.colour(
                        const Color(0xFF26F1CC),
                      ),
                      alignment: TextAlign.center,
                    ),
                    UserProgressIndicator(
                      level: state.currentLevel,
                    ),
                    SizedBox(
                      height: SizeConfig.padding34,
                    ),
                    FelloBadgeDetails(
                      levelsData: state.felloBadgesModel.levels,
                      currentLevel: state.currentLevel,
                    ),
                    SizedBox(
                      height: SizeConfig.padding34,
                    ),
                    HowSuperFelloWorksWidget(
                      isBoxOpen: false,
                      superFelloWorks: state.felloBadgesModel.superFelloWorks!,
                    ),
                    SizedBox(
                      height: SizeConfig.padding32,
                    ),
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
                      badges: state.felloBadgesModel.bagdes,
                    ),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                    SvgPicture.network(
                      'https://fello-dev-uploads.s3.ap-south-1.amazonaws.com/Group+1244832512.svg',
                      height: SizeConfig.padding80,
                      width: SizeConfig.padding68,
                      fit: BoxFit.fill,
                    ),
                    Container(
                      width: SizeConfig.screenWidth,
                      // height: 500,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding28,
                          vertical: SizeConfig.padding42),
                      decoration: const BoxDecoration(color: Color(0xFF1B3637)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: SizeConfig.padding18,
                              mainAxisSpacing: SizeConfig.padding86,
                              // childAspectRatio: 3,
                            ),
                            padding: EdgeInsets.zero,
                            itemCount: 6,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return const BadgesTopUserWidget();
                            },
                          ),
                          SizedBox(
                            height: SizeConfig.padding84,
                          ),
                          // Text(
                          //   'LOAD MORE',
                          //   textAlign: TextAlign.center,
                          //   style: TextStyles.rajdhaniSB.body3.colour(
                          //     const Color(0xFF1ADAB7),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding28,
                    ),
                    LottieBuilder.network(Assets.bottomBannerLottie),
                    SizedBox(
                      height: SizeConfig.padding8,
                    ),
                  ],
                ),
              );
            }

            return Container(
              width: SizeConfig.screenWidth,
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.pageHorizontalMargins),
              child: const FullScreenLoader(),
            );
          },
        ),
      ),
    );
  }
}
