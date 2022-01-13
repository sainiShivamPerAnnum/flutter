import 'dart:ui';

import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/hero_router.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_card/golden_scratch_card_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_ticket_utils.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_tickets/golden_tickets_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class GoldenTicketsView extends StatelessWidget {
  const GoldenTicketsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<GoldenTicketsViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          body: HomeBackground(
            child: Column(
              children: [
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  title: "Golden Scratch Cards",
                ),
                //Container(height: SizeConfig.screenHeight * 0.2),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(SizeConfig.padding40),
                        topRight: Radius.circular(SizeConfig.padding40),
                      ),
                      color: Colors.white,
                    ),
                    child: model.arrangedGoldenTicketList == null
                        ? Center(child: CircularProgressIndicator())
                        : (model.arrangedGoldenTicketList.length == 0
                            ? Center(
                                child: NoRecordDisplayWidget(
                                  assetLottie: Assets.noData,
                                  text: "No Golden Scratch Cards yet",
                                ),
                              )
                            : GridView.builder(
                                itemCount:
                                    model.arrangedGoldenTicketList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 20,
                                        childAspectRatio: 1 / 1,
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 20),
                                itemBuilder: (ctx, i) {
                                  return InkWell(
                                    onTap: () {
                                      AppState.screenStack
                                          .add(ScreenItem.dialog);
                                      Navigator.of(AppState.delegate
                                              .navigatorKey.currentContext)
                                          .push(
                                        HeroDialogRoute(
                                          builder: (context) {
                                            return GoldenScratchCardView(
                                              ticket: model
                                                  .arrangedGoldenTicketList[i],
                                              superModel: model,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: GoldenTicketGridItemCard(
                                      ticket: model.arrangedGoldenTicketList[i],
                                      titleStyle: TextStyles.body1,
                                    ),
                                  );
                                },
                              )),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// final scratchKey = GlobalKey<ScratcherState>();

// class GoldenScratchCard extends StatefulWidget {
//   final GoldenTicket ticket;
//   GoldenScratchCard({this.ticket});
//   @override
//   State<GoldenScratchCard> createState() => GoldenScratchCardState();
// }

// class GoldenScratchCardState extends State<GoldenScratchCard> {
//   bool viewScratcher = false;
//   double _detailsModalHeight = 0;
//   bool bottompadding = true;
//   @override
//   void initState() {
//     Future.delayed(Duration(seconds: 0), () {
//       setState(() {
//         viewScratcher = true;
//       });
//     });
//     super.initState();
//   }

//   showDetailsModal() {
//     setState(() {
//       bottompadding = false;
//       _detailsModalHeight = SizeConfig.screenHeight * 0.5;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: SafeArea(
//         child: Column(
//           children: [
//             FelloAppBar(
//               leading: FelloAppBarBackButton(
//                 color: Colors.black,
//               ),
//             ),
//             Spacer(),
//             viewScratcher
//                 ? Hero(
//                     key: Key(widget.ticket.createdOn.toString()),
//                     tag: widget.ticket.createdOn.toString(),
//                     createRectTween: (begin, end) {
//                       return CustomRectTween(begin: begin, end: end);
//                     },
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(32),
//                       child: Scratcher(
//                         brushSize: 50,
//                         threshold: 40,
//                         key: scratchKey,
//                         onThreshold: () {
//                           scratchKey.currentState.reveal();
//                           showDetailsModal();
//                         },
//                         image: Image.asset(
//                           "images/gticket.png",
//                           fit: BoxFit.cover,
//                           height: SizeConfig.screenWidth * 0.6,
//                           width: SizeConfig.screenWidth * 0.6,
//                         ),
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(32),
//                           ),
//                           child: Container(
//                             height: SizeConfig.screenWidth * 0.6,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(32),
//                             ),
//                             width: SizeConfig.screenWidth * 0.6,
//                             margin: EdgeInsets.only(
//                                 left: SizeConfig.pageHorizontalMargins),
//                             child: Stack(
//                               children: [
//                                 Positioned(
//                                   bottom: 0,
//                                   left: 8,
//                                   child: Image.asset(
//                                     "images/fello-short-logo.png",
//                                     height: SizeConfig.screenWidth * 0.24,
//                                     color: Colors.grey[200],
//                                   ),
//                                 ),
//                                 Positioned(
//                                   bottom:
//                                       5, // SizeConfig.pageHorizontalMargins,
//                                   right: 5, //SizeConfig.pageHorizontalMargins,
//                                   child: Image.asset(
//                                     Assets.felloRewards,
//                                     width: SizeConfig.screenWidth * 0.3,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                     top: SizeConfig.pageHorizontalMargins,
//                                     right: SizeConfig.pageHorizontalMargins,
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Text(
//                                         "You won ₹${widget.ticket.rewards.firstWhere((e) => e.type == 'amt').value ?? '0'} and ${widget.ticket.rewards.firstWhere((e) => e.type == 'flc').value ?? '0'} fello coins",
//                                         style: TextStyles.title1,
//                                       )
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 : GoldenTicketCard(
//                     ticket: widget.ticket,
//                     enabled: true,
//                   ),
//             Spacer(),
//             if (bottompadding) FelloAppBar(),
//             AnimatedContainer(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(SizeConfig.roundness16),
//               ),
//               height: _detailsModalHeight,
//               duration: Duration(seconds: 1),
//               curve: Curves.easeIn,
//               width: SizeConfig.screenWidth,
//               padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Image.asset(
//                           "images/fello_logo.png",
//                           height: SizeConfig.padding40,
//                         ),
//                         SizedBox(width: SizeConfig.padding8),
//                       ],
//                     ),
//                     Text(
//                       "Reward Details",
//                       style: TextStyles.title3.bold,
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
