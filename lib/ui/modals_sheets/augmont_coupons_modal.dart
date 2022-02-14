import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/coupon_card_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AugmontCouponsModalSheet extends StatelessWidget {
  final AugmontGoldBuyViewModel model;
  final _formKey = GlobalKey<FormState>();
  AugmontCouponsModalSheet({this.model});

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Container(
      height: SizeConfig.screenHeight * 0.54,
      decoration: BoxDecoration(),
      padding: EdgeInsets.all(
        SizeConfig.blockSizeHorizontal * 5,
      ),
      child: Column(
        //shrinkWrap: true,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Apply a Coupon",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
              Spacer(),
              CircleAvatar(
                backgroundColor: Colors.black,
                child: IconButton(
                  onPressed: () {
                    AppState.backButtonDispatcher.didPopRoute();
                  },
                  icon: Icon(
                    Icons.close,
                    size: SizeConfig.iconSize1,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: SizeConfig.padding24,
            thickness: 2,
            // endIndent: SizeConfig.screenWidth / 4,
          ),

          SizedBox(height: SizeConfig.padding16),
          Row(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                      // controller: _referralCodeController,
                      //maxLength: 10,
                      decoration: InputDecoration(
                        hintText: "Enter a Coupon Code here",
                        hintStyle: TextStyles.body3.colour(Colors.grey),
                        suffix: InkWell(
                          child: Text(
                            "Apply",
                            style: TextStyles.body3.bold
                                .colour(UiConstants.primaryColor),
                          ),
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              BaseUtil.showNegativeAlert("Invalid Coupon",
                                  "Please recheck the Coupon code");
                              AppState.backButtonDispatcher.didPopRoute();
                            }
                          },
                        ),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (val) {
                        if (val.trim().length == 0 || val == null)
                          return "Please enter a code to continue";
                        if (val.trim().length < 3 || val.trim().length > 10)
                          return "Invalid Coupon code";
                        return null;
                      }),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.padding24),

          Text(
            "Active Coupons",
            style: TextStyles.body2.light,
          ),

          Expanded(
            child: Container(
              // padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              //   border: Border.all(width: 0.5, color: UiConstants.felloBlue),
              // ),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: SizeConfig.padding8),
                physics: BouncingScrollPhysics(),
                children: List.generate(
                    model.couponList.length,
                    (i) => Container(
                          margin: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding4),
                          child: CouponItem(
                              model: model,
                              coupon: model.couponList[i],
                              onTap: () {
                                model.applyCoupon(model.couponList[i]);
                                AppState.backButtonDispatcher.didPopRoute();
                              }),
                        )),
              ),
            ),
          ),
          // SizedBox(height: SizeConfig.padding16),
          // SizedBox(
          //   height: MediaQuery.of(context).viewInsets.bottom,
          // )
        ],
      ),
    );
  }
}

class CouponItem extends StatelessWidget {
  const CouponItem(
      {Key key,
      @required this.model,
      this.trailingWidget,
      this.onTap,
      this.coupon})
      : super(key: key);
  final Widget trailingWidget;

  final AugmontGoldBuyViewModel model;
  final Function onTap;
  final CouponModel coupon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // height: SizeConfig.padding54,
        width: SizeConfig.screenWidth,
        margin: EdgeInsets.only(bottom: SizeConfig.padding4),
        padding: EdgeInsets.only(
            top: SizeConfig.padding2,
            bottom: SizeConfig.padding2,
            right: SizeConfig.pageHorizontalMargins / 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            color: UiConstants.felloBlue.withOpacity(0.1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: SizeConfig.padding54,
              width: SizeConfig.padding54,
              padding: EdgeInsets.all(SizeConfig.padding4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.padding12),
                  bottomLeft: Radius.circular(SizeConfig.padding12),
                ),
              ),
              child: Center(
                child: Transform.rotate(
                  angle: 40,
                  child: SvgPicture.asset(
                    Assets.couponIcon,
                    color: UiConstants.felloBlue,
                    height: SizeConfig.padding20,
                  ),
                ),
              ),
            ),
            SizedBox(width: SizeConfig.padding4),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coupon.code,
                    style: TextStyles.body4.bold.colour(UiConstants.felloBlue),
                  ),
                  SizedBox(height: SizeConfig.padding2),
                  Text(
                    coupon.description,
                    style: TextStyles.body4,
                  )
                ],
              ),
            ),
            if (trailingWidget != null) trailingWidget
          ],
        ),
      ),
    );
  }
}
