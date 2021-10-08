import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/pagestate.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Play extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<PlayViewModel>(
      onModelReady: (model) {},
      builder: (ctx, model, child) {
        return Container(
          padding: EdgeInsets.only(
              left: SizeConfig.globalMargin,
              top: SizeConfig.globalMargin,
              right: SizeConfig.globalMargin),
          child: ListView(
            children: [
              Container(
                width: SizeConfig.screenWidth,
                height: 100,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (ctx, i) {
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            children: [
                              CircleAvatar(),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                "Title $i",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(height: 20),
              Text("Trending Games",
                  style: Theme.of(context).textTheme.headline3),
              Column(
                children: List.generate(
                  2,
                  (i) => Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (i == 0)
                            BaseUtil().openTambolaHome();
                          else {
                            AppState.delegate.appState.currentAction =
                                PageAction(
                                    state: PageState.addPage,
                                    page: CricketHomePageConfig);
                            // await Future.delayed(Duration(seconds: 5), () {
                            //   AppState.backButtonDispatcher.didPopRoute();
                            // });
                          }
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(36),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "images/svgs/game.svg",
                                  height: 50,
                                  width: 50,
                                  color: UiConstants.primaryColor,
                                ),
                                SizedBox(width: 36),
                                Text(
                                  model.gameList[i],
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w300,
                                    fontSize: SizeConfig.cardTitleTextSize,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Text(
                              "5 tickets",
                              style:
                                  TextStyle(fontSize: SizeConfig.largeTextSize),
                            ),
                            Spacer(),
                            Text(
                              "Prize: 10K",
                              style: TextStyle(
                                  color: UiConstants.primaryColor,
                                  fontSize: SizeConfig.largeTextSize),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => model.showTicketModal(context),
                child: Card(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.globalMargin, vertical: 40),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 20),
                    child: Text(
                      "Want more ticket?",
                      style: TextStyle(
                        fontSize: SizeConfig.largeTextSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
