import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/daySaver/day_saver_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

enum SaverType { MONTHLY, DAILY, WEEKLY }

class TopSaverView extends StatelessWidget {
  final SaverType type;
  TopSaverView({this.type = SaverType.DAILY});
  @override
  Widget build(BuildContext context) {
    return BaseView<TopSaverViewModel>(onModelReady: (model) {
      model.init(type);
    }, builder: (context, model, child) {
      return Scaffold(
        backgroundColor: UiConstants.primaryColor,
        body: HomeBackground(
          child: Column(
            children: [
              FelloAppBar(
                leading: FelloAppBarBackButton(),
                title: model.appbarTitle,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.padding40),
                      topRight: Radius.circular(SizeConfig.padding40),
                    ),
                    color: Colors.white,
                  ),
                  width: SizeConfig.screenWidth,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.screenWidth * 0.4,
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins,
                            vertical: SizeConfig.pageHorizontalMargins),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness32),
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://image.freepik.com/free-vector/investors-earning-income_74855-2486.jpg?w=1380"),
                            fit: BoxFit.cover,
                          ),
                          color: UiConstants.tertiarySolid,
                        ),
                      ),
                      SaverBoards(title: "Past Winners"),
                      SizedBox(height: SizeConfig.padding16),
                      WinningsContainer(
                        shadow: false,
                        child: Center(
                          child: Text(
                            "How to participate",
                            style: TextStyles.body1.bold.colour(Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding16,
                      ),
                      SaverBoards(title: "Current Leaderboard"),
                      Container(
                        width: SizeConfig.screenWidth,
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness32),
                          color: UiConstants.scaffoldColor,
                        ),
                        child: Column(
                          children: [],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class SaverBoards extends StatelessWidget {
  final String title;
  SaverBoards({@required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness32),
        color: UiConstants.scaffoldColor,
      ),
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      padding: EdgeInsets.all(SizeConfig.padding16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyles.title5.bold.colour(Colors.black54),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    "More ",
                    style:
                        TextStyles.body3.bold.colour(UiConstants.primaryColor),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: UiConstants.primaryColor,
                    size: SizeConfig.iconSize3,
                  )
                ],
              )
            ],
          ),
          SizedBox(height: SizeConfig.padding16),
          Column(
            children: List.generate(
              4,
              (index) => Container(
                margin: EdgeInsets.only(bottom: SizeConfig.padding12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.padding12),
                  color: Colors.white,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: UiConstants.primaryColor,
                    child: Text(
                      index.toString(),
                      style: TextStyles.body2.colour(Colors.white),
                    ),
                  ),
                  title: Text("username"),
                  subtitle: Text("week description"),
                  trailing: Text("Win prize"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
