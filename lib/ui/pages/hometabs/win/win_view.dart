import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/fello_badges/ui/fello_badges_home.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/keys/keys.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/current_winnings_info.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/news_component.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/refer_and_earn_card.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/scratch_card_info_strip.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/win_helpers.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/pages/static/dev_rel.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/extensions/string_extension.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class Win extends StatelessWidget {
  const Win({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final S locale = locator<S>();
    return BaseView<WinViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) => model.clear(),
      builder: (ctx, model, child) {
        return Builder(builder: (context) {
          if (model.state == ViewState.Busy) {
            return SizedBox(
              width: SizeConfig.screenWidth,
              child: const FullScreenLoader(),
            );
          }
          return Scaffold(
            backgroundColor: UiConstants.kBackgroundColor,
            appBar: FAppBar(
              title: "My Account",
              showHelpButton: true,
              type: FaqsType.yourAccount,
              showCoinBar: false,
              showAvatar: false,
              leadingPadding: false,
              action: Row(children: [NotificationButton()]),
            ),
            body: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  height: SizeConfig.padding180,
                  width: SizeConfig.screenWidth,
                  color: const Color(0xff191919),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // const ProfileBadgeWidget(),
                      const UserBadgeContainer(
                        badgeColor: Color(0xFFFFD979),
                        badgeUrl:
                            'https://d37gtxigg82zaw.cloudfront.net/loyalty/level-2.svg',
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PropertyChangeConsumer<UserService,
                              UserServiceProperties>(
                            properties: const [UserServiceProperties.myName],
                            builder: (context, model, child) {
                              return Text(
                                (model!.baseUser!.kycName!.isNotEmpty
                                        ? model.baseUser!.kycName!
                                        : model.baseUser!.name!.isNotEmpty
                                            ? model.baseUser!.name!
                                            : "User")
                                    .trim()
                                    .split(' ')
                                    .first
                                    .capitalize(),
                                style: TextStyles.rajdhaniSB.title4
                                    .colour(Colors.white),
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                              );
                            },
                          ),
                          Text(
                            'Beginner Fello',
                            style: TextStyles.sourceSans.body3.colour(
                              const Color(0xFFF79780),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),

                AccountInfoTiles(
                  key: K.userProfileEntryCTAKey,
                  title: locale.abMyProfile,
                  uri: "/profile",
                ),

                const AccountInfoTiles(
                  title: "KYC Details",
                  uri: "/kycVerify",
                ),

                AccountInfoTiles(
                    title: locale.bankAccDetails, uri: "/bankDetails"),
                AccountInfoTiles(
                  title: 'Last Week on Fello',
                  uri: "",
                  onTap: () => model.showLastWeekSummary(),
                ),
                AccountInfoTiles(
                  title: 'Rate Us',
                  uri: "",
                  onTap: () => model.showRatingSheet(),
                ),
                //Scratch Cards count and navigation
                const ScratchCardsInfoStrip(),
                //Current Winnings Information
                const CurrentWinningsInfo(),
                //Refer and Earn
                const ReferEarnCard(),
                //Fello News
                FelloNewsComponent(model: model),
                SizedBox(
                  height: SizeConfig.padding12,
                ),
                const CacheClearWidget(),
                SizedBox(
                  height: SizeConfig.padding10,
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

class ProfileBadgeWidget extends StatelessWidget {
  const ProfileBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 152,
      height: 152,
      child: Stack(
        children: [
          Positioned(
            left: 27,
            top: 27,
            child: SizedBox(
              width: 98,
              height: 98,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 98,
                      height: 98,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFCEC4FF),
                        shape: OvalBorder(),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: SizedBox(
                      width: 98,
                      height: 98,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 98,
                              height: 98,
                              decoration: const ShapeDecoration(
                                color: Color(0xFFCEC4FF),
                                shape: OvalBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 22,
            top: 22,
            child: Container(
              width: 107.15,
              height: 107.15,
              decoration: const ShapeDecoration(
                shape: OvalBorder(
                  side: BorderSide(width: 4.50, color: Color(0xFFA7A7A8)),
                ),
              ),
            ),
          ),
          Positioned(
            left: 22,
            top: 22,
            child: Container(
              width: 107,
              height: 107,
              decoration: ShapeDecoration(
                shape: OvalBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 11.56,
            top: 11.56,
            child: Opacity(
              opacity: 0.30,
              child: Container(
                width: 128.88,
                height: 128.88,
                decoration: const ShapeDecoration(
                  shape: OvalBorder(
                    side: BorderSide(width: 1.17, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Opacity(
              opacity: 0.50,
              child: Container(
                width: 152,
                height: 152,
                decoration: const ShapeDecoration(
                  shape: OvalBorder(
                    side: BorderSide(width: 0.60, color: Color(0xFF727272)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
