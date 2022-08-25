import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/sell_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/sell_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/recharge_modal_sheet.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_details/augmont_gold_details_vm.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_sell/augmont_gold_sell_view.dart';
import 'package:felloapp/ui/service_elements/auto_save_card/subscription_card.dart';
import 'package:felloapp/ui/service_elements/user_service/user_gold_quantity.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/ui/widgets/custom_card/custom_cards.dart';
import 'package:felloapp/ui/widgets/faq_card/faq_card_view.dart';
import 'package:felloapp/ui/widgets/mini_trans_card/mini_trans_card_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class SaveAssetView extends StatelessWidget {
  const SaveAssetView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.kDarkBackgroundColor,
      appBar: AppBar(
        backgroundColor: UiConstants.kBackgroundColor,
        elevation: 0,
        leading: FelloAppBarBackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: BaseView<SaveViewModel>(
              onModelReady: (model) => model.init(),
              builder: (context, model, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: SizeConfig.screenWidth * 2.4,
                    decoration: BoxDecoration(
                        color: UiConstants.kBackgroundColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GoldAssetCard(),
                        SizedBox(
                          height: SizeConfig.padding24,
                        ),
                        // -- Break --
                        SaveTitleContainer(title: 'Auto SIP'),
                        SizedBox(
                          height: SizeConfig.padding10,
                        ),
                        AutosaveCard(),
                        SizedBox(
                          height: SizeConfig.padding24,
                        ),
                        SaveTitleContainer(title: 'Transactions'),
                        Expanded(child: MiniTransactionCard()),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SellGoldText(),
                          _sellButton(
                              onTap: () {
                                BaseUtil.openModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    isBarrierDismissable: true,
                                    addToScreenStack: true,
                                    content: SellingReasonBottomSheet(
                                      saveViewModel: model,
                                    ));
                              },
                              isActive: model.getButtonAvailibility()),
                        ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: SizeConfig.padding24),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: model.isKYCVerified && model.isVPAVerified
                          ? SizedBox()
                          : Text(
                              'To enable selling gold,\ncomplete the following:',
                              style: TextStyles.sourceSans.body4
                                  .colour(Colors.grey.withOpacity(0.7)),
                              textAlign: TextAlign.end,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  //Complete KYC section
                  if (!(model.isKYCVerified && model.isVPAVerified))
                    CompleteKYCSection(
                      isKYCCompleted:
                          model.userService.isSimpleKycVerified ?? false,
                      isBankInformationComeplted: model.isVPAVerified ?? false,
                    ),
                  //Lock in reached section
                  if (model.isLockInReached)
                    SellPreventionReasonCard(
                      iconString: Assets.alertTriangle,
                      content:
                          '${model.nonWithdrawableQnt}g is locked. Digital Gold can be withdrawn after 48 hours of successful deposit',
                    ),
                  if (model.isGoldSaleActive)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: SizeConfig.padding10),
                      child: SellPreventionReasonCard(
                        iconString: Assets.alertTriangle,
                        content:
                            'Selling of DIgital Gold is currently on hold. Please try again later.',
                      ),
                    ),
                  if (model.isOngoingTransaction)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: SizeConfig.padding10),
                      child: SellPreventionReasonCard(
                        iconString: Assets.loadingSvg,
                        content:
                            'Your Digital Gold withdrawal is being processsed',
                      ),
                    ),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
                    child: FAQCardView(
                        category: 'digital_gold',
                        bgColor: UiConstants.kDarkBackgroundColor),
                  ),
                  SizedBox(
                    height: SizeConfig.screenWidth * 0.2,
                  )
                ],
              ),
            )),
      ),
    );
  }

  GestureDetector _sellButton(
      {@required Function() onTap, @required bool isActive}) {
    return GestureDetector(
      onTap: isActive ? onTap : () {},
      child: Container(
        height: SizeConfig.screenWidth * 0.12,
        width: SizeConfig.screenWidth * 0.29,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
          border: Border.all(
              color: isActive
                  ? Colors.white
                  : UiConstants.kSecondaryBackgroundColor,
              width: 1),
        ),
        child: Center(
          child: Text(
            'SELL',
            style: TextStyles.rajdhaniSB.body0.colour(
                isActive ? UiConstants.kTextColor : UiConstants.kTextColor2),
          ),
        ),
      ),
    );
  }
}

class SellGoldText extends StatelessWidget {
  const SellGoldText({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<AugmontGoldDetailsViewModel>(
        onModelReady: (model) => model.fetchGoldRates(),
        builder: (ctx, model, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sell your current gold \nat current market rate',
                  style: TextStyles.sourceSansSB.body2
                      .colour(Colors.grey.withOpacity(0.8)),
                ),
                ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: SizeConfig.screenWidth / 2),
                  child: Text(
                    "With every transaction, some tokens will be deducted.",
                    style: TextStyles.sourceSans.body4
                        .colour(UiConstants.kBlogTitleColor),
                  ),
                ),
              ],
            ));
  }
}

class GoldAssetCard extends StatelessWidget {
  const GoldAssetCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BaseView<SaveViewModel>(
            builder: (ctx, model, child) => Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.padding54,
                      left: SizeConfig.padding24,
                      right: SizeConfig.padding24),
                  child: Container(
                    height: SizeConfig.screenWidth * 0.88,
                    width: SizeConfig.screenWidth * 0.87,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness32),
                        color: UiConstants.kSaveDigitalGoldCardBg),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: SizeConfig.screenWidth * 0.25),
                        child: Column(
                          children: [
                            Text('Digital Gold',
                                style: TextStyles.rajdhaniB.title2),
                            Text('Safer way to invest',
                                style: TextStyles.sourceSans.body4),
                            SizedBox(
                              height: SizeConfig.padding40,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding24),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '\u20b9 2000',
                                        style: TextStyles.sourceSans.body0
                                            .colour(Colors.white),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.padding2,
                                      ),
                                      Text(
                                        'Invested',
                                        style: TextStyles.sourceSans.body3
                                            .colour(UiConstants.kTextColor
                                                .withOpacity(0.8)),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      UserGoldQuantitySE(
                                        style: TextStyles.sourceSans.body0
                                            .colour(Colors.white),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.padding2,
                                      ),
                                      Text(
                                        'Total Gold',
                                        style: TextStyles.sourceSans.body3
                                            .colour(UiConstants.kTextColor
                                                .withOpacity(0.8)),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '\u20b9 4390.8',
                                        style: TextStyles.sourceSans.body0
                                            .colour(Colors.white),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.padding2,
                                      ),
                                      Text(
                                        'Current',
                                        style: TextStyles.sourceSans.body3
                                            .colour(UiConstants.kTextColor
                                                .withOpacity(0.8)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.padding26,
                            ),
                            CustomSaveButton(
                              onTap: () {
                                return BaseUtil.openModalBottomSheet(
                                  addToScreenStack: true,
                                  enableDrag: false,
                                  hapticVibrate: true,
                                  isBarrierDismissable: true,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  content: RechargeModalSheet(),
                                );
                              },
                              title: 'Save',
                              isFullScreen: true,
                              width: SizeConfig.screenWidth * 0.2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
          child: Container(
            height: SizeConfig.screenWidth - 50,
            width: SizeConfig.screenWidth * 0.87,
            child: Align(
              alignment: Alignment.topCenter,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.asset(
                  Assets.digitalGoldBar,
                  height: SizeConfig.screenWidth * 0.4,
                  width: SizeConfig.screenWidth * 0.4,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CompleteKYCSection extends StatelessWidget {
  final bool isKYCCompleted;
  final bool isBankInformationComeplted;

  const CompleteKYCSection(
      {Key key, this.isKYCCompleted, this.isBankInformationComeplted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SaveViewModel>(
        onModelReady: (model) => model.init(),
        builder: (context, model, child) =>
            PropertyChangeConsumer<SellService, SellServiceProperties>(
                properties: [
                  SellServiceProperties.bankDetailsVerified,
                  SellServiceProperties.kycVerified,
                  SellServiceProperties.augmontSellDisabled,
                  SellServiceProperties.reachedLockIn,
                  SellServiceProperties.ongoingTransaction
                ],
                builder: (context, serviceModel, child) => Column(
                      children: [
                        SellActionButton(
                          title: 'Complete KYC',
                          onTap: () {
                            if (!serviceModel.isKYCVerified) {
                              model.navigateToCompleteKYC();
                            }
                          },
                          isVisible: serviceModel.isKYCVerified,
                        ),
                        SizedBox(
                          height: SizeConfig.padding10,
                        ),
                        SellActionButton(
                          title: 'Add Bank Information',
                          onTap: () {
                            if (!serviceModel.isVPAVerified) {
                              model.navigateToVerifyVPA();
                            }
                          },
                          isVisible: serviceModel.isVPAVerified,
                        ),
                      ],
                    )));
  }
}

class AugmontDownCard extends StatelessWidget {
  const AugmontDownCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class OngoingTransactionCard extends StatelessWidget {
  const OngoingTransactionCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class GoldLockedInCard extends StatelessWidget {
  const GoldLockedInCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SellActionButton extends StatelessWidget {
  final String title;
  final String iconData;
  final Function() onTap;
  final bool isVisible;

  const SellActionButton(
      {Key key, this.title, this.iconData, this.onTap, this.isVisible = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: SizeConfig.screenWidth * 0.16,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.roundness5),
              color: UiConstants.kSecondaryBackgroundColor),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyles.rajdhaniM.body1,
                ),
                isVisible
                    ? Icon(
                        Icons.check_circle_rounded,
                        color: UiConstants.kTealTextColor,
                      )
                    : Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: UiConstants.kTextColor,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SellingReasonBottomSheet extends StatefulWidget {
  final SaveViewModel saveViewModel;

  const SellingReasonBottomSheet({Key key, this.saveViewModel})
      : super(key: key);

  @override
  State<SellingReasonBottomSheet> createState() =>
      _SellingReasonBottomSheetState();
}

class _SellingReasonBottomSheetState extends State<SellingReasonBottomSheet> {
  List<String> _sellingReasons = [
    'Not interested anymore',
    'Not interested a little more',
    'Not anymore',
    'Others'
  ];

  String selectedReasonForSelling = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: SizeConfig.screenWidth * 0.85,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.roundness32),
                topRight: Radius.circular(SizeConfig.roundness32)),
            color: UiConstants.kModalSheetBackgroundColor),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.padding10),
          child: Column(
            children: [
              Divider(
                thickness: 4,
                height: 3,
                color: UiConstants.kTextColor,
                endIndent: 150,
                indent: 150,
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              Text(
                'What makes you want to sell the asset?',
                style: TextStyles.rajdhaniSB.body1,
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              Expanded(
                  child: ListView(
                children: _sellingReasons
                    .map((x) => RadioListTile(
                          toggleable: true,
                          selected: true,
                          value: x,
                          groupValue: selectedReasonForSelling,
                          onChanged: (value) {
                            setState(() {
                              selectedReasonForSelling = x;
                            });
                            AppState.backButtonDispatcher.didPopRoute();
                            BaseUtil.openModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness12),
                                enableDrag: true,
                                addToScreenStack: true,
                                isBarrierDismissable: true,
                                content: AugmontGoldSellView());
                          },
                          title: Text(
                            x,
                            style: TextStyles.rajdhani.body2,
                          ),
                        ))
                    .toList(),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class SellPreventionReasonCard extends StatelessWidget {
  final String iconString;
  final String content;

  const SellPreventionReasonCard({Key key, this.iconString, this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
      child: Container(
        height: SizeConfig.screenWidth * 0.2,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
          color: UiConstants.kSecondaryBackgroundColor,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.padding10),
            child: Row(
              children: [
                SvgPicture.asset(iconString),
                SizedBox(
                  width: SizeConfig.padding10,
                ),
                ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: SizeConfig.screenWidth * 0.74),
                  child: Text(
                    content,
                    style: TextStyles.sourceSans.body4
                        .colour(UiConstants.kTextColor2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
