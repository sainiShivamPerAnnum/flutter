import 'package:felloapp/base_util.dart';
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

class AugmontCouponsModalSheet extends StatelessWidget {
  final AugmontGoldBuyViewModel model;
  final _formKey = GlobalKey<FormState>();
  AugmontCouponsModalSheet({this.model});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          height: SizeConfig.screenHeight * 0.7,
          decoration: BoxDecoration(),
          padding: EdgeInsets.all(
            SizeConfig.blockSizeHorizontal * 5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Choose a Coupon",
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
                  )
                ],
              ),
              Divider(
                height: 32,
                thickness: 2,
                endIndent: SizeConfig.screenWidth / 4,
              ),
              SizedBox(height: SizeConfig.padding16),
              Text(
                "Choose from available Coupon codes",
                style: TextStyles.body2.light.colour(Colors.black45),
              ),
              SizedBox(height: SizeConfig.padding16),
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                    border: Border.all(
                        width: 0.5, color: UiConstants.tertiarySolid),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding12),
                    itemCount: 3,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (c, i) => Container(
                      height: SizeConfig.padding54,
                      width: SizeConfig.screenWidth,
                      margin: EdgeInsets.only(bottom: SizeConfig.padding8),
                      padding: EdgeInsets.only(
                          // top: SizeConfig.padding8,
                          // bottom: SizeConfig.padding8,
                          right: SizeConfig.pageHorizontalMargins),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness12),
                        color: UiConstants.tertiaryLight,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: SizeConfig.padding54,
                            width: SizeConfig.padding54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(SizeConfig.padding12),
                                bottomLeft:
                                    Radius.circular(SizeConfig.padding12),
                              ),
                              color: UiConstants.tertiarySolid.withOpacity(0.4),
                            ),
                            child: Center(
                              child: Image.asset(
                                Assets.couponIcon,
                                height: SizeConfig.padding32,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                "EXTRA3%",
                                style: TextStyles.body4.bold,
                              ),
                              subtitle: Text(
                                "Buy gold worth ₹1000 and get 3% gold free",
                                style: TextStyles.body4,
                              ),
                              onTap: () {
                                model.applyCoupon(i == 0 ? true : false);
                                AppState.backButtonDispatcher.didPopRoute();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.padding16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("OR")],
              ),
              SizedBox(height: SizeConfig.padding16),
              Form(
                key: _formKey,
                child: TextFormField(
                    // controller: _referralCodeController,
                    //maxLength: 10,
                    decoration: InputDecoration(
                      hintText: "Enter your Coupon Code here",
                      hintStyle: TextStyles.body3.colour(Colors.grey),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
                    ],
                    validator: (val) {
                      if (val.trim().length == 0 || val == null) return null;
                      if (val.trim().length < 3 || val.trim().length > 10)
                        return "Invalid Coupon code";
                      return null;
                    }),
              ),
              SizedBox(height: SizeConfig.padding16),
              FelloButtonLg(
                child: Text(
                  "Apply Coupon",
                  style: TextStyles.body2.bold.colour(Colors.white),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    BaseUtil.showNegativeAlert(
                        "Invalid Coupon", "Please recheck the Coupon code");
                    AppState.backButtonDispatcher.didPopRoute();
                  }
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              )
            ],
          ),
        ),
      ],
    );
  }
}
