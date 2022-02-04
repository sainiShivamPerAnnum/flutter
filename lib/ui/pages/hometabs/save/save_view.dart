import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/coupon_card_model.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/gold_overview.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/ui/pages/static/play_offer_card.dart';
import 'package:felloapp/ui/service_elements/user_service/user_gold_quantity.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

// TEST COUPON [TO BE DELETED]
CouponModel TestCoupon = CouponModel(
  "",
  "FREE3%",
  "Buy gold worth ₹1000 and get 3% gold free.",
  Timestamp.now(),
  Timestamp.now(),
  4,
  1,
  Additionals("", "get ₹300 worth gold for free", "", null, "Apply Coupon"),
);

class Save extends StatelessWidget {
  final CustomLogger logger = locator<CustomLogger>();

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<AugmontGoldBuyViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Stack(
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(
                      height: SizeConfig.screenHeight * 0.08 +
                          SizeConfig.screenWidth * 0.2),
                  Expanded(
                    child: ListView(
                      children: [
                        GoldOverview(model: model),
                        SizedBox(height: SizeConfig.padding20),
                        AugmontBuyCard(model: model),
                        SizedBox(height: SizeConfig.padding32),
                        SizedBox(height: SizeConfig.navBarHeight * 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin:
                        EdgeInsets.only(top: SizeConfig.screenHeight * 0.09),
                    child: CouponCard(
                      model: TestCoupon,
                      onPressed: () {
                        model.appliedCoupon != TestCoupon
                            ? model.applyCoupon(true)
                            : model.applyCoupon(false);
                      },
                      shimmer: true,
                    )),
              ],
            ),
          ],
        );
      },
    );
  }
}

// class SaveInfoTile extends StatelessWidget {
//   final String svg, png;
//   final String title;
//   final Function onPressed;

//   SaveInfoTile({this.svg, this.png, this.onPressed, this.title});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressed ?? () {},
//       splashColor: UiConstants.primaryColor,
//       focusColor: UiConstants.primaryColor,
//       highlightColor: UiConstants.primaryColor,
//       hoverColor: UiConstants.primaryColor,
//       child: Container(
//         width: SizeConfig.screenWidth * 0.603,
//         height: SizeConfig.screenWidth * 0.24,
//         margin: EdgeInsets.only(
//             left: SizeConfig.pageHorizontalMargins,
//             right: SizeConfig.padding16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(SizeConfig.roundness32),
//         ),
//         alignment: Alignment.center,
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: SizeConfig.padding20,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               png != null
//                   ? Image.asset(png ?? Assets.moneyIcon,
//                       width: SizeConfig.padding40)
//                   : SvgPicture.asset(
//                       svg ?? Assets.tokens,
//                       width: SizeConfig.padding40,
//                     ),
//               SizedBox(width: SizeConfig.padding16),
//               Expanded(
//                 child: Text(
//                   title ?? "title",
//                   maxLines: 3,
//                   style: TextStyles.title5.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



// Container(
                        //   width: SizeConfig.screenWidth,
                        //   height: SizeConfig.screenWidth * 0.24,
                        //   child: ListView(
                        //     scrollDirection: Axis.horizontal,
                        //     children: [
                        //       SaveInfoTile(
                        //         svg: 'images/svgs/gold.svg',
                        //         title: "About digital Gold",
                        //         onPressed: () {
                        //           logger.d("Save info tile tap check");
                        //           model.navigateToAboutGold();
                        //         },
                        //       ),
                        //       SaveInfoTile(
                        //         png: "images/augmont-share.png",
                        //         title: "Learn more about Augmont",
                        //         onPressed: () {
                        //           model.openAugmontWebUri();
                        //         },
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        