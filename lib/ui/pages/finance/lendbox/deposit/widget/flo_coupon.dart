import 'package:felloapp/core/model/coupon_card_model.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/util/assets.dart' as a;
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FloCouponWidget extends StatelessWidget {
  const FloCouponWidget(this.coupon, this.model,
      {Key? key, required this.onTap})
      : super(key: key);
  final List<CouponModel>? coupon;
  final Function(CouponModel coupon) onTap;
  final LendboxBuyViewModel model;

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return coupon == null
        ? const SizedBox()
        : SizedBox(
            height: SizeConfig.screenHeight! * 0.17,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        locale.btnApplyCoupon,
                        style: TextStyles.sourceSansSB.body1,
                      ),

                      GestureDetector(
                        onTap: () {
                          model.buyFieldNode.unfocus();
                          model.showOfferModal(model);
                        },
                        child: Text(
                          'Add Manually',
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kTabBorderColor),
                        ),
                      ),
                      // SizedBox(width: SizeConfig.padding10),
                      // if (model.couponApplyInProgress && model.isSpecialCoupon)
                      //   SizedBox(
                      //       width: SizeConfig.padding16,
                      //       height: SizeConfig.padding16,
                      //       child: const CircularProgressIndicator(
                      //         color: UiConstants.primaryColor,
                      //         strokeWidth: 2,
                      //       )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                coupon != null
                    ? Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: index == 0
                                  ? EdgeInsets.only(
                                      left: SizeConfig.pageHorizontalMargins)
                                  : index == coupon!.length - 1
                                      ? EdgeInsets.only(
                                          right:
                                              SizeConfig.pageHorizontalMargins,
                                          left: SizeConfig.padding14)
                                      : EdgeInsets.only(
                                          left: SizeConfig.padding14),
                              child: _CouponView(
                                model: coupon![index],
                                lendboxBuyViewModel: model,
                                onTap: onTap,
                              ),
                            );
                          },
                          itemCount: coupon!.length,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          );
  }
}

class _CouponView extends StatelessWidget {
  const _CouponView(
      {required this.model,
      required this.lendboxBuyViewModel,
      Key? key,
      required this.onTap})
      : super(key: key);
  final CouponModel model;
  final Function(CouponModel coupon) onTap;
  final LendboxBuyViewModel lendboxBuyViewModel;

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return GestureDetector(
      onTap: () {
        if (lendboxBuyViewModel.appliedCoupon == null ||
            lendboxBuyViewModel.appliedCoupon?.code != model.code) {
          if (!lendboxBuyViewModel.couponApplyInProgress) onTap(model);
        }
      },
      child: Container(
        width: SizeConfig.screenWidth! * .7,
        height: SizeConfig.padding80,
        padding: const EdgeInsets.only(left: 16, right: 18, top: 8),
        decoration: BoxDecoration(
          border: lendboxBuyViewModel.appliedCoupon != null
              ? lendboxBuyViewModel.appliedCoupon?.code == model.code
                  ? Border.all(color: const Color(0xFF08D2AD))
                  : null
              : null,
          color:
              UiConstants.kModalSheetSecondaryBackgroundColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  a.Assets.ticketTilted,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  model.code!,
                  style: TextStyles.sourceSansSB.body1.colour(Colors.white),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (lendboxBuyViewModel.appliedCoupon == null ||
                        lendboxBuyViewModel.appliedCoupon!.code != model.code) {
                      if (!lendboxBuyViewModel.couponApplyInProgress)
                        onTap(model);
                    } else {
                      lendboxBuyViewModel.appliedCoupon = null;
                    }
                  },
                  child: lendboxBuyViewModel.appliedCoupon == null ||
                          lendboxBuyViewModel.appliedCoupon!.code != model.code
                      ? lendboxBuyViewModel.couponApplyInProgress &&
                              lendboxBuyViewModel.couponCode == model.code
                          ? SpinKitThreeBounce(
                              size: SizeConfig.body2,
                              color: UiConstants.primaryColor,
                            )
                          : Text(
                              locale.txnApply.toUpperCase(),
                              style: TextStyles.sourceSansSB.body3
                                  .colour(const Color(0xff1ADAB7)),
                            )
                      : const Icon(
                          Icons.close,
                          size: 20,
                          color: Color(0xff1ADAB7),
                        ),
                )
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            SizedBox(
              width: SizeConfig.screenWidth! * 0.5,
              child: Text(
                model.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.sourceSans.body4,
              ),
            )
          ],
        ),
      ),
    );
  }
}
