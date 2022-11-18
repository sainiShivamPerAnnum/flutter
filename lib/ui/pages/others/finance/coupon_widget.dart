import 'dart:developer';

import 'package:felloapp/core/model/coupon_card_model.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CouponWidget extends StatelessWidget {
  const CouponWidget(this.coupon, this.model, {Key? key, required this.onTap})
      : super(key: key);
  final List<CouponModel>? coupon;
  final Function(CouponModel coupon) onTap;
  final GoldBuyViewModel model;
  @override
  Widget build(BuildContext context) {
    return coupon == null
        ? SizedBox()
        : SizedBox(
            height: SizeConfig.screenHeight! * 0.22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    'Apply Coupon',
                    style: TextStyles.sourceSansSB.title5,
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                coupon != null
                    ? Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: index == 0
                                  ? const EdgeInsets.only(left: 24)
                                  : index == coupon!.length - 1
                                      ? EdgeInsets.only(right: 14, left: 14)
                                      : EdgeInsets.only(left: 14),
                              child: _CouponView(
                                model: coupon![index],
                                goldBuyViewModel: model,
                                onTap: onTap,
                              ),
                            );
                          },
                          itemCount: coupon!.length,
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: RichText(
                    text: TextSpan(
                      text: 'Have a different coupon code? ',
                      style: TextStyles.sourceSans.body4,
                      children: [
                        TextSpan(
                            text: 'Enter here',
                            style: TextStyles.sourceSans.body4
                                .copyWith(decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                model.buyFieldNode.unfocus();
                                model.showOfferModal(model);
                              }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}

class _CouponView extends StatelessWidget {
  const _CouponView(
      {required this.model,
      required this.goldBuyViewModel,
      Key? key,
      required this.onTap})
      : super(key: key);
  final CouponModel model;
  final Function(CouponModel coupon) onTap;
  final GoldBuyViewModel goldBuyViewModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth! * .7,
      padding: EdgeInsets.only(left: 16, right: 18, bottom: 18, top: 8),
      decoration: BoxDecoration(
        border: goldBuyViewModel.appliedCoupon != null
            ? goldBuyViewModel.appliedCoupon?.code == model.code
                ? Border.all(color: Color(0xFF08D2AD))
                : null
            : null,
        color: UiConstants.kModalSheetSecondaryBackgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                Assets.ticketTilted,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                model.code!,
                style: TextStyles.sourceSansSB.body1.colour(Colors.white),
              ),
              Spacer(),
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
                            "Apply",
                            style: TextStyles.sourceSansSB.body3
                                .colour(Color(0xff1ADAB7)),
                          )
                    : Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xff1ADAB7),
                      ),
              )
            ],
          ),
          SizedBox(
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
    );
  }
}


// 
