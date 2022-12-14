import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_vm.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_tickets/golden_tickets_view.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/service_elements/winners_prizes/prize_claim_card.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class MyWinningsView extends StatelessWidget {
  final openFirst;
  // final WinViewModel winModel;

  MyWinningsView({this.openFirst = false});
  @override
  Widget build(BuildContext context) {
    S? locale = S.of(context);
    return BaseView<MyWinningsViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) {
        return RefreshIndicator(
          backgroundColor: Colors.black,
          onRefresh: () async {
            await model.init();
            return Future.value();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'My Rewards',
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: TextStyles.title4.bold.colour(Colors.white),
              ),
              elevation: 0.0,
              backgroundColor: UiConstants.kBackgroundColor,
              leading: IconButton(
                onPressed: () {
                  AppState.backButtonDispatcher!.didPopRoute();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: UiConstants.kBackgroundColor,
            body: Stack(
              children: [
                NewSquareBackground(),
                ListView(
                  shrinkWrap: true,
                  children: [
                    PrizeClaimCard(),
                    GoldenTicketsView(),
                  ],
                )
                // Container(
                //   width: SizeConfig.screenWidth,
                //   height: SizeConfig.screenHeight,
                //   child: Column(
                //     children: [
                //       Expanded(
                //         child: Container(
                //           decoration: BoxDecoration(
                //             color: Colors.transparent,
                //           ),
                //           child: RefreshIndicator(
                //             onRefresh: () {
                //               model.init();
                //               return Future.value();
                //             },
                //             child: NestedScrollView(
                //               headerSliverBuilder: (context, _) {
                //                 return [
                //                   SliverList(
                //                     delegate: SliverChildListDelegate(
                //                       [],
                //                     ),
                //                   ),
                //                 ];
                //               },
                //               body:
                //             ),
                //           ),
                //         ),
                //       )
                // ],
                // ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
