import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/model/coupon_card_model.dart';
import '../../../../../../util/assets.dart';

class FloCouponPage extends StatelessWidget {
  FloCouponPage({required this.model1, super.key});
  final LendboxBuyViewModel? model1;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController couponCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return ChangeNotifierProvider.value(
      value: model1,
      child: Scaffold(
        backgroundColor: UiConstants.kAnimationBackGroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Container(
            margin: EdgeInsets.only(left: SizeConfig.padding16),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white.withOpacity(0.4),
              ),
              onPressed: () => AppState.backButtonDispatcher!.didPopRoute(),
            ),
          ),
          title: Text(
            locale.btnApplyCoupon,
            style: TextStyles.rajdhaniSB.title5,
          ),
        ),
        body: Consumer<LendboxBuyViewModel>(
          builder: (context, model, child) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig.padding32,
                  ),
                  Form(
                    key: _formKey,
                    child: AppTextField(
                      fillColor: UiConstants.kTambolaMidTextColor,
                      textEditingController: couponCodeController,
                      hintText: locale.enterCoupon,
                      textCapitalization: TextCapitalization.characters,
                      suffixIcon: InkWell(
                        child: Text(
                          locale.txnApply,
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.teal2),
                        ),
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            model.applyCoupon(
                                couponCodeController.text.trim(), true);
                            AppState.backButtonDispatcher!.didPopRoute();
                          }
                        },
                      ),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 40,
                      ),
                      validator: (val) {
                        if (val!.trim().isEmpty) return locale.txnEnterCode;
                        if (val.trim().length < 3 || val.trim().length > 20) {
                          return locale.txnInvalidCouponCode;
                        }
                        return null;
                      },
                      isEnabled: true,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  Text(
                    locale.moreCoupons,
                    style: TextStyles.rajdhaniSB.body2,
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: List.generate(
                        model.couponList!.length,
                        (i) => model.couponList![i].code == null ||
                                model.couponList![i].description == null
                            ? const SizedBox.shrink()
                            : Padding(
                                padding:
                                    EdgeInsets.only(top: SizeConfig.padding16),
                                child: IndividualCouponView(
                                  model: model.couponList![i],
                                  appliedCode: model.appliedCoupon?.code,
                                  desc: model.couponList![i].description!,
                                  lendboxBuyViewModel: model,
                                  onTap: (coupon) => model.applyCoupon(
                                    coupon.code,
                                    false,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class IndividualCouponView extends StatelessWidget {
  const IndividualCouponView({
    required this.appliedCode,
    required this.model,
    required this.desc,
    required this.onTap,
    required this.lendboxBuyViewModel,
    super.key,
  });
  final String? appliedCode;
  final CouponModel model;
  final String desc;
  final ValueChanged<CouponModel> onTap;
  final LendboxBuyViewModel lendboxBuyViewModel;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return GestureDetector(
      onTap: () {
        if (lendboxBuyViewModel.appliedCoupon == null ||
            lendboxBuyViewModel.appliedCoupon?.code != model.code) {
          if (!lendboxBuyViewModel.couponApplyInProgress) onTap(model);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding10,
          horizontal: SizeConfig.padding12,
        ),
        decoration: BoxDecoration(
          color: UiConstants.customCoupon,
          borderRadius: BorderRadius.all(
            Radius.circular(
              SizeConfig.padding10,
            ),
          ),
          border: appliedCode != model.code
              ? null
              : Border.all(
                  color: UiConstants.teal3,
                  width: 1,
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppImage(
                  Assets.ticketTilted,
                  width: SizeConfig.iconSize0,
                  height: SizeConfig.iconSize0,
                  color: model.minPurchase! <=
                          int.parse(
                            lendboxBuyViewModel.amountController!.text,
                          )
                      ? UiConstants.teal2
                      : UiConstants.textGray70,
                ),
                SizedBox(width: SizeConfig.padding12),
                Text(
                  model.code!,
                  style: TextStyles.sourceSansSB.body2,
                ),
                const Spacer(),
                lendboxBuyViewModel.couponApplyInProgress &&
                        lendboxBuyViewModel.couponCode == model.code
                    ? const SpinKitThreeBounce(
                        color: UiConstants.teal2,
                        size: 14,
                      )
                    : appliedCode != model.code
                        ? Row(
                            children: [
                              Text(
                                locale.txnApply,
                                style: TextStyles.sourceSans.body3.colour(
                                    model.minPurchase! <=
                                            int.parse(lendboxBuyViewModel
                                                .amountController!.text)
                                        ? UiConstants.teal2
                                        : UiConstants.textGray70),
                              ),
                              Icon(Icons.chevron_right,
                                  color: model.minPurchase! <=
                                          int.parse(lendboxBuyViewModel
                                              .amountController!.text)
                                      ? UiConstants.teal2
                                      : UiConstants.textGray70)
                            ],
                          )
                        : const SizedBox.shrink()
              ],
            ),
            SizedBox(height: SizeConfig.padding8),
            Text(
              desc,
              style: TextStyles.sourceSans.body4
                  .colour(UiConstants.kFAQsAnswerColor),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.padding10),
              child: CustomPaint(
                painter: DashedLinePainter(),
                size: const Size(double.infinity, 1),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Get 5X Tickets',
                    style: TextStyles.sourceSansSB.body3.colour(
                        model.minPurchase! <=
                                int.parse(
                                    lendboxBuyViewModel.amountController!.text)
                            ? UiConstants.teal2
                            : UiConstants.textGray70))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 9, dashSpace = 5, startX = 0;
    final paint = Paint()
      ..color = UiConstants.grey2.withOpacity(.2)
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
