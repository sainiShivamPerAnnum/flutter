import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AutoPayDetailsView extends StatelessWidget {
  const AutoPayDetailsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: UiConstants.primaryColor,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Image.asset(
                Assets.splashBackground,
                width: SizeConfig.screenWidth,
                fit: BoxFit.fitWidth,
              ),
            ),
            FelloAppBar(leading: FelloAppBarBackButton()),
            DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.6,
              maxChildSize: 0.9,
              builder:
                  (BuildContext context, ScrollController myScrollController) {
                return ListView.builder(
                  controller: myScrollController,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: SizeConfig.screenHeight),
                          // ScrollHandle(),
                          // SizedBox(height: 20),
                          // PeopleHeader(),
                          // SizedBox(height: 20),
                          // UserDetails(controller: myScrollController),
                          // LoadMore(),
                          // SizedBox(height: 30),
                          // Separator(),
                          // SizedBox(height: 30),
                          // BusinessHeader(),
                          // SizedBox(height: 5),
                          // BusinessBanner(),
                          // SizedBox(height: 20),
                          // UserDetails(controller: myScrollController),
                          // LoadMore(),
                          // SizedBox(height: 30),
                          // Separator(),
                          // SizedBox(height: 30),
                          // PromotionHeader(),
                          // SizedBox(height: 20),
                          // PromotionData(),
                          // SizedBox(height: 50),
                          // CashUtils(),
                          // SizedBox(height: 50),
                          // InviteSection(),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
