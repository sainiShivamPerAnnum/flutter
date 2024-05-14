import 'package:felloapp/core/model/coupon_card_model.dart';
import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'augmont/gold_buy/augmont_buy_vm.dart';

class GoldCouponWidget extends StatelessWidget {
  const GoldCouponWidget(
    List<CouponModel>? coupons,
    this.model, {
    required this.onTap,
    super.key,
  }) : _coupons = coupons ?? const <CouponModel>[];

  final List<CouponModel> _coupons;
  final ValueChanged<CouponModel> onTap;
  final GoldBuyViewModel model;

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
                  if (!model.isBuyInProgess) {
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
            goldBuymodel: model,
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
    required this.goldBuymodel,
    required this.onTap,
    super.key,
  });

  final CouponModel model;
  final ValueChanged<CouponModel> onTap;
  final GoldBuyViewModel goldBuymodel;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return goldBuymodel.focusCoupon != null
        ? IndividualCouponView(
            appliedCode: goldBuymodel.appliedCoupon?.code,
            model: goldBuymodel.focusCoupon!,
            desc: goldBuymodel.focusCoupon!.description!,
            goldBuymodel: goldBuymodel,
            disabledDesc: goldBuymodel.focusCoupon!.disabledDescription!,
            ticketMultiplier: goldBuymodel.focusCoupon!.ticketMultiplier!,
            icon: goldBuymodel.focusCoupon!.icon,
            isDisabled: goldBuymodel.focusCoupon!.couponSubType != null &&
                goldBuymodel.focusCoupon!.couponSubType == 'SUPER_FELLO' &&
                locator<UserService>().baseUser!.superFelloLevel !=
                    SuperFelloLevel.SUPER_FELLO,
            onTap: (coupon) => goldBuymodel.applyCoupon(
              coupon.code,
              false,
            ),
          )
        : GestureDetector(
            onTap: () {
              goldBuymodel.buyFieldNode.unfocus();
              goldBuymodel.showOfferModal(goldBuymodel);
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

class GoldCouponPage extends StatelessWidget {
  GoldCouponPage({required this.model, super.key});
  final GoldBuyViewModel? model;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController couponCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return ChangeNotifierProvider.value(
      value: model,
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
        body: Consumer<GoldBuyViewModel>(
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
                                  isDisabled:
                                      model.couponList![i].couponSubType !=
                                              null &&
                                          model.couponList![i].couponSubType ==
                                              'SUPER_FELLO' &&
                                          locator<UserService>()
                                                  .baseUser!
                                                  .superFelloLevel !=
                                              SuperFelloLevel.SUPER_FELLO,
                                  disabledDesc:
                                      model.couponList![i].disabledDescription!,
                                  ticketMultiplier:
                                      model.couponList![i].ticketMultiplier!,
                                  icon: model.couponList![i].icon,
                                  goldBuymodel: model,
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
    required this.icon,
    required this.appliedCode,
    required this.model,
    required this.desc,
    required this.onTap,
    required this.goldBuymodel,
    required this.disabledDesc,
    required this.ticketMultiplier,
    required this.isDisabled,
    super.key,
  });
  final String? icon;
  final String? appliedCode;
  final CouponModel model;
  final String desc;
  final String disabledDesc;
  final ValueChanged<CouponModel> onTap;
  final GoldBuyViewModel goldBuymodel;
  final int ticketMultiplier;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return GestureDetector(
      onTap: () {
        if (isDisabled) {
          return;
        }
        if (goldBuymodel.appliedCoupon == null ||
            goldBuymodel.appliedCoupon?.code != model.code) {
          if (!goldBuymodel.couponApplyInProgress) onTap(model);
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
                  icon ?? Assets.ticketTilted,
                  width: SizeConfig.iconSize0,
                  height: SizeConfig.iconSize0,
                  color: model.minPurchase! <=
                              int.parse(
                                goldBuymodel.goldAmountController!.text,
                              ) &&
                          !isDisabled
                      ? UiConstants.teal2
                      : UiConstants.textGray70,
                ),
                SizedBox(width: SizeConfig.padding12),
                Text(
                  model.code!,
                  style: TextStyles.sourceSansSB.body2,
                ),
                const Spacer(),
                goldBuymodel.couponApplyInProgress &&
                        goldBuymodel.couponCode == model.code
                    ? const SpinKitThreeBounce(
                        color: UiConstants.teal2,
                        size: 14,
                      )
                    : appliedCode != model.code
                        ? Row(
                            children: [
                              Text(
                                model.minPurchase! <=
                                        int.parse(
                                          goldBuymodel
                                              .goldAmountController!.text,
                                        )
                                    ? locale.txnApply
                                    : locale.addAmountCoupons,
                                style: TextStyles.sourceSans.body3.colour(
                                  isDisabled
                                      ? UiConstants.textGray70
                                      : UiConstants.teal2,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: isDisabled
                                    ? UiConstants.textGray70
                                    : UiConstants.teal2,
                              )
                            ],
                          )
                        : const SizedBox.shrink()
              ],
            ),
            SizedBox(height: SizeConfig.padding8),
            Text(
              model.minPurchase! <=
                      int.parse(
                        goldBuymodel.goldAmountController!.text,
                      )
                  ? desc
                  : disabledDesc,
              style: TextStyles.sourceSans.body4.colour(model.minPurchase! <=
                      int.parse(
                        goldBuymodel.goldAmountController!.text,
                      )
                  ? UiConstants.kFAQsAnswerColor
                  : UiConstants.peach2),
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
                Text(locale.getTicketMutiplier(ticketMultiplier),
                    style: TextStyles.sourceSansSB.body3.colour(
                      model.minPurchase! <=
                                  int.parse(
                                    goldBuymodel.goldAmountController!.text,
                                  ) &&
                              !isDisabled
                          ? UiConstants.teal2
                          : UiConstants.textGray70,
                    ))
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
