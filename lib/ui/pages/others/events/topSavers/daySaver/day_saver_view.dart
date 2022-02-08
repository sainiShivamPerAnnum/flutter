import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/daySaver/day_saver_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/styles/size_config.dart';
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
                title: "Top Saver",
              ),
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
                  width: SizeConfig.screenWidth,
                  child: Column(
                    children: [],
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
