import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class MyWinningsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<MyWinningsViewModel>(
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.primaryColor,
          body: HomeBackground(
            child: Column(
              children: [
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  title: "My Winnings",
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.pageHorizontalMargins),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Hero(
                          tag: "myWinnings",
                          child: WinningsContainer(
                            shadow: false,
                            child: Container(
                              width: SizeConfig.screenWidth,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(SizeConfig.padding16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    locale.winMyWinnings,
                                    style: TextStyles.title5
                                        .colour(Colors.white60),
                                  ),
                                  SizedBox(height: SizeConfig.padding8),
                                  Text(
                                    locale.saveWinningsValue(1000),
                                    style: TextStyles.title1
                                        .colour(Colors.white)
                                        .weight(FontWeight.w900)
                                        .letterSpace(2),
                                  )
                                ],
                              ),
                            ),
                            color: Color(0xff11192B),
                          ),
                        ),
                        SizedBox(height: SizeConfig.padding24),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.pageHorizontalMargins),
                          child: Row(
                            children: [
                              ClaimButton(
                                color: UiConstants.primaryColor,
                                image: Assets.amazonClaim,
                                onTap: () {},
                                text: "Redeem for amazon pay",
                              ),
                              SizedBox(
                                width: SizeConfig.padding12,
                              ),
                              ClaimButton(
                                color: UiConstants.tertiarySolid,
                                image: Assets.goldClaim,
                                onTap: () {},
                                text: "Invest in digtial gold",
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ClaimButton extends StatelessWidget {
  final Color color;
  final String image;
  final String text;
  final Function onTap;

  ClaimButton({
    @required this.color,
    @required this.image,
    @required this.onTap,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FelloButton(
        onPressed: onTap,
        activeButtonUI: Container(
          height: SizeConfig.screenWidth * 0.2,
          width: SizeConfig.screenWidth * 0.422,
          decoration: BoxDecoration(
            color: color ?? UiConstants.primaryColor,
            borderRadius: BorderRadius.circular(SizeConfig.padding20),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding12,
            vertical: SizeConfig.padding16,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: SizeConfig.padding24,
                backgroundColor: Colors.white.withOpacity(0.3),
                child: Image.asset(
                  image ?? Assets.amazonClaim,
                ),
              ),
              SizedBox(width: SizeConfig.padding6),
              Expanded(
                child: Text(
                  text ?? "Redeem for amazon pay",
                  style: TextStyles.body2.colour(Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
