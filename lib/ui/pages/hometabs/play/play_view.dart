import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
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
                              Text("Title $i", style: TextStyles.body2.bold)
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(height: 20),
              Text("Trending Games",
                  style:
                      TextStyles.title2.bold.colour(UiConstants.primaryColor)),
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
                            await Future.delayed(Duration(seconds: 10), () {
                              AppState.backButtonDispatcher.didPopRoute();
                            });
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
                                Text(model.gameList[i],
                                    style: TextStyles.title2.light)
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
                              style: TextStyles.body2,
                            ),
                            Spacer(),
                            Text(
                              "Prize: 10K",
                              style: TextStyles.body2
                                  .colour(UiConstants.primaryColor),
                            ),
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
                    child: Text("Want more ticket?",
                        style: TextStyles.title3.bold),
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
