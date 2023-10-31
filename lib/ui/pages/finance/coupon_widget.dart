import 'package:felloapp/core/model/coupon_card_model.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/util/assets.dart' as a;
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CouponWidget extends StatelessWidget {
  final List<CouponModel> _coupons;
  final Function(CouponModel coupon) onTap;
  final GoldBuyViewModel model;

  const CouponWidget(
    List<CouponModel>? coupons,
    this.model, {
    required this.onTap,
    super.key,
  }) : _coupons = coupons ?? const <CouponModel>[];

  void _onTapApply() {
    model.buyFieldNode.unfocus();
    model.showOfferModal(model);
  }

  @override
  Widget build(BuildContext context) {
    if (_coupons.isEmpty) return const SizedBox.shrink();
    final locale = S.of(context);
    return SizedBox(
      height: SizeConfig.screenHeight! * 0.17,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  locale.btnApplyCoupon,
                  style: TextStyles.sourceSansSB.body2,
                ),
                GestureDetector(
                  onTap: _onTapApply,
                  child: Text(
                    'Add Manually',
                    style: TextStyles.sourceSans.body3.colour(
                      UiConstants.teal3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _coupons.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: index == 0
                      ? EdgeInsets.only(left: SizeConfig.padding16)
                      : index == _coupons.length - 1
                          ? EdgeInsets.only(
                              right: SizeConfig.padding16,
                              left: SizeConfig.padding14,
                            )
                          : EdgeInsets.only(left: SizeConfig.padding14),
                  child: _CouponView(
                    model: _coupons[index],
                    goldBuyViewModel: model,
                    onTap: onTap,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _CouponView extends StatelessWidget {
  const _CouponView({
    required this.model,
    required this.goldBuyViewModel,
    required this.onTap,
  });
  final CouponModel model;
  final Function(CouponModel coupon) onTap;
  final GoldBuyViewModel goldBuyViewModel;

  void _onTapCoupon() {
    if (goldBuyViewModel.appliedCoupon == null ||
        goldBuyViewModel.appliedCoupon?.code != model.code) {
      if (!goldBuyViewModel.couponApplyInProgress) onTap(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context);
    final code = goldBuyViewModel.appliedCoupon?.code;
    final applied = code != null && code == model.code;
    return GestureDetector(
      onTap: _onTapCoupon,
      child: Container(
        width: SizeConfig.screenWidth! * .6,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: applied
                ? UiConstants.teal3
                : UiConstants.grey2.withOpacity(
                    .2,
                  ),
          ),
          color: UiConstants.grey2.withOpacity(.2),
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
                    if (goldBuyViewModel.appliedCoupon == null ||
                        goldBuyViewModel.appliedCoupon!.code != model.code) {
                      if (!goldBuyViewModel.couponApplyInProgress) onTap(model);
                    } else {
                      goldBuyViewModel.appliedCoupon = null;
                    }
                  },
                  child: goldBuyViewModel.appliedCoupon == null ||
                          goldBuyViewModel.appliedCoupon!.code != model.code
                      ? goldBuyViewModel.couponApplyInProgress &&
                              goldBuyViewModel.couponCode == model.code
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
                          color: UiConstants.teal3,
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
                style: TextStyles.sourceSans.body4.colour(
                  UiConstants.grey1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
