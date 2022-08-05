import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/service_elements/paytm_service_elements/subscription_card.dart';
import 'package:felloapp/ui/service_elements/user_service/user_gold_quantity.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/ui/widgets/custom_card/custom_cards.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class Save extends StatelessWidget {
  final CustomLogger logger = locator<CustomLogger>();

  @override
  Widget build(BuildContext context) {
    S locale = S();
    return BaseView<AugmontGoldBuyViewModel>(
      onModelReady: (model) => model.init(null),
      builder: (ctx, model, child) {
        return Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                SizedBox(
                  height: SizeConfig.padding54,
                ),
                SaveNetWorthSection(),
              ],
            ));
      },
    );
  }
}

class SaveNetWorthSection extends StatelessWidget {
  const SaveNetWorthSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight / 1.6,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          color: UiConstants.kSecondaryBackgroundColor),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Save',
                  style: TextStyles.rajdhaniSB.title1,
                ),
                FelloCoinBar(
                  svgAsset: Assets.aFelloToken,
                ),
              ],
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Your networth\n",
              style:
                  TextStyles.rajdhaniSB.body2.colour(UiConstants.kTextColor2),
              children: <TextSpan>[
                TextSpan(
                    text: '\u20b9 5732\n',
                    style: TextStyles.sourceSansB.title0),
                TextSpan(
                    text: 'Approx',
                    style:
                        TextStyles.sourceSansB.body4.colour(Color(0xFF93B5FE)))
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          SaveCustomCard(
            title: 'Digital Gold',
            cardBgColor: UiConstants.kSaveDigitalGoldCardBg,
            cardAssetName: Assets.digitalGoldBar,
            onTap: () {},
          ),
          SaveCustomCard(
            title: 'Stable Fello',
            cardBgColor: UiConstants.kSaveStableFelloCardBg,
            cardAssetName: Assets.stableFello,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
