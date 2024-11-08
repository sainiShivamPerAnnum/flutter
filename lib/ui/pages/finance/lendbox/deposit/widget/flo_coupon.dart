import 'package:felloapp/core/model/coupon_card_model.dart';
import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

import '../../../../static/app_widget.dart';
import 'flo_coupon_page.dart';

class FloCouponWidget extends StatelessWidget {
  const FloCouponWidget(
    List<CouponModel>? coupons,
    this.model, {
    required this.onTap,
    super.key,
  }) : _coupons = coupons ?? const <CouponModel>[];

  final List<CouponModel> _coupons;
  final ValueChanged<CouponModel> onTap;
  final LendboxBuyViewModel model;

  @override
  Widget build(BuildContext context) {
    if (_coupons.isEmpty) return const SizedBox.shrink();
    final locale = locator<S>();
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                locale.btnApplyCoupon,
                style: TextStyles.sourceSansSB.body1,
              ),
              GestureDetector(
                onTap: () {
                  if (!model.isBuyInProgress) {
                    model.buyFieldNode.unfocus();
                    model.showOfferModal(model);
                  }
                },
                child: Text(
                  locale.saveViewAll,
                  style: TextStyles.sourceSans.body3
                      .colour(UiConstants.kTabBorderColor),
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding25,
          ),
          CouponViewV2(
            model: _coupons[0],
            lendboxBuyViewModel: model,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class CouponViewV2 extends StatelessWidget {
  const CouponViewV2({
    required this.model,
    required this.lendboxBuyViewModel,
    required this.onTap,
    super.key,
  });

  final CouponModel model;
  final ValueChanged<CouponModel> onTap;
  final LendboxBuyViewModel lendboxBuyViewModel;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return lendboxBuyViewModel.focusCoupon != null
        ? IndividualCouponView(
            appliedCode: lendboxBuyViewModel.appliedCoupon?.code,
            model: lendboxBuyViewModel.focusCoupon!,
            ticketMultiplier:
                lendboxBuyViewModel.focusCoupon!.ticketMultiplier!,
            icon: lendboxBuyViewModel.focusCoupon!.icon,
            desc: lendboxBuyViewModel.focusCoupon!.description!,
            disabledDesc: lendboxBuyViewModel.focusCoupon!.disabledDescription!,
            lendboxBuyViewModel: lendboxBuyViewModel,
            isDisabled:
                lendboxBuyViewModel.focusCoupon!.couponSubType != null &&
                    lendboxBuyViewModel.focusCoupon!.couponSubType ==
                        'SUPER_FELLO' &&
                    locator<UserService>().baseUser!.superFelloLevel !=
                        SuperFelloLevel.SUPER_FELLO,
            onTap: (coupon) => lendboxBuyViewModel.applyCoupon(
              coupon.code,
              false,
            ),
          )
        : GestureDetector(
            onTap: () {
              lendboxBuyViewModel.buyFieldNode.unfocus();
              lendboxBuyViewModel.showOfferModal(lendboxBuyViewModel);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding8,
                horizontal: SizeConfig.padding16,
              ),
              decoration: BoxDecoration(
                color: Color(0xff2A343A),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    SizeConfig.padding10,
                  ),
                ),
              ),
              child: Row(
                children: [
                  AppImage(
                    Assets.ticketTilted,
                    width: SizeConfig.iconSize0,
                    height: SizeConfig.iconSize0,
                    color: UiConstants.teal2,
                  ),
                  SizedBox(
                    width: SizeConfig.padding8,
                  ),
                  Text(
                    locale.viewAllCoupons,
                    style: TextStyles.sourceSansSB.body2,
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right,
                    color: UiConstants.kTextColor,
                  )
                ],
              ),
            ),
          );
  }
}
