// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../util/assets.dart';

class GoldProBuyView extends StatefulWidget {
  const GoldProBuyView({super.key});

  @override
  State<GoldProBuyView> createState() => _GoldProBuyViewState();
}

class _GoldProBuyViewState extends State<GoldProBuyView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<GoldProBuyViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) => model.dump(),
      builder: (context, model, child) => Consumer<AugmontTransactionService>(
          builder: (transactionContext, txnService, _) {
        return Scaffold(
          backgroundColor: UiConstants.darkPrimaryColor2,
          body: getView(txnService, model),
        );
      }),
    );
  }

  getView(AugmontTransactionService txnService, GoldProBuyViewModel model) {
    switch (txnService.currentTxnState) {
      case TransactionState.idle:
        return GoldProBuyInputView(model: model);
      case TransactionState.ongoing:
        return GoldProBuyPendingView();
      case TransactionState.success:
        return GoldProBuySuccessView();
    }
  }
}

class GoldProBuyInputView extends StatelessWidget {
  const GoldProBuyInputView({super.key, required this.model});

  final GoldProBuyViewModel model;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {},
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              Image.asset(
                Assets.digitalGoldBar,
                width: SizeConfig.padding54,
                height: SizeConfig.padding54,
              ),
              // SizedBox(width: SizeConfig.padding8),
              Text(
                'Digital Gold Pro',
                style: TextStyles.rajdhaniSB.title5,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.padding20),
              Text(
                "Select value to save in Gold Pro",
                style: TextStyles.rajdhani.body1.colour(Colors.white),
              ),
              Container(
                margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                padding: EdgeInsets.all(SizeConfig.padding16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                  color: UiConstants.kBackgroundColor2,
                ),
                child: Column(
                  children: [
                    Text(
                      "Gold Value",
                      style: TextStyles.rajdhaniM.body2.colour(Colors.white54),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          child: IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.remove),
                            onPressed: () {},
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                width: SizeConfig.title3 * 2,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeIn,
                                child: TextField(
                                  controller: model.goldFieldController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    isDense: true,
                                  ),
                                  style: TextStyles.rajdhaniBL.title1
                                      .colour(Colors.white),
                                ),
                              ),
                              Text(
                                "gms",
                                style: TextStyles.sourceSansB.body0
                                    .colour(Colors.white),
                              )
                            ],
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          child: IconButton(
                            icon: const Icon(Icons.add),
                            color: Colors.white,
                            onPressed: () {},
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GoldProChoiceChip(
                          chipValue: "0.5g",
                          isBest: false,
                          isSelected: 0 == model.selectedChipValue,
                          onTap: () => model.onChipSelected(0),
                        ),
                        GoldProChoiceChip(
                          chipValue: "2.5g",
                          isBest: true,
                          isSelected: 1 == model.selectedChipValue,
                          onTap: () => model.onChipSelected(1),
                        ),
                        GoldProChoiceChip(
                          chipValue: "7.5g",
                          isBest: false,
                          isSelected: 2 == model.selectedChipValue,
                          onTap: () => model.onChipSelected(2),
                        ),
                        GoldProChoiceChip(
                          chipValue: "10g",
                          isBest: false,
                          isSelected: 3 == model.selectedChipValue,
                          onTap: () => model.onChipSelected(3),
                        ),
                      ],
                    ),
                    // SizedBox(height: SizeConfig.padding8),
                    SizedBox(
                      width: SizeConfig.screenWidth! * 0.82,
                      child: Slider(
                        value: model.sliderValue,
                        onChanged: model.updateSliderValue,
                        divisions: 3,
                        inactiveColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.roundness16),
                      topRight: Radius.circular(SizeConfig.roundness16)),
                  color: Colors.black,
                ),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "You are adding",
                        style: TextStyles.rajdhaniM.body1,
                      ),
                      Text(
                        "2.5gms",
                        style:
                            TextStyles.sourceSansSB.title5.colour(Colors.white),
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.padding12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Current Gold Balance",
                        style: TextStyles.rajdhaniM.body2.colour(Colors.grey),
                      ),
                      Text(
                        "0.2gms",
                        style: TextStyles.sourceSansSB.body2
                            .colour(Colors.white70),
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.padding18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expected Returns in 5Y",
                            style:
                                TextStyles.rajdhaniB.body1.colour(Colors.white),
                          ),
                          Text(
                            "with Gold Pro",
                            style:
                                TextStyles.rajdhaniM.body2.colour(Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(width: SizeConfig.padding10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FittedBox(
                              child: Text(
                                "₹10500",
                                style: TextStyles.rajdhaniBL.title0
                                    .colour(UiConstants.kGoldProPrimary),
                              ),
                            ),
                            Text(
                              "@ 15.5% p.a",
                              style: TextStyles.sourceSans.body2
                                  .colour(UiConstants.kGoldProPrimary),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.padding18),
                  ReactivePositiveAppButton(
                      btnText: "PROCEED", onPressed: () {})
                ]),
              )
            ],
          ),
        )
      ],
    );
  }
}

class GoldProChoiceChip extends StatelessWidget {
  const GoldProChoiceChip({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.chipValue,
    required this.isBest,
  });

  final bool isSelected;
  final Function onTap;
  final String chipValue;
  final bool isBest;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: SizeConfig.padding64,
        child: Column(
          children: [
            if (isBest)
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.padding2,
                    horizontal: SizeConfig.padding8),
                decoration: BoxDecoration(
                    color: UiConstants.kGoldProPrimary,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(SizeConfig.roundness5),
                        topRight: Radius.circular(SizeConfig.roundness5))),
                child: Text(
                  "Best",
                  style: TextStyles.sourceSansSB.body4.colour(Colors.black),
                ),
              ),
            SizedBox(
              height: (SizeConfig.padding64 * 0.8214285714285714).toDouble(),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CustomPaint(
                      size: Size(
                          SizeConfig.padding64,
                          (SizeConfig.padding64 * 0.8214285714285714)
                              .toDouble()),
                      painter: OutlinedTooltipBorder(
                        width: isSelected ? 1.5 : 1,
                        color: isSelected
                            ? UiConstants.kGoldProPrimary
                            : UiConstants.kGoldProBorder,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: SizeConfig.padding20),
                      child: Text(
                        chipValue,
                        style: TextStyles.sourceSansM.body2.colour(isSelected
                            ? UiConstants.kGoldProPrimary
                            : Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoldProBuyPendingView extends StatelessWidget {
  const GoldProBuyPendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class GoldProBuySuccessView extends StatelessWidget {
  const GoldProBuySuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

//Copy this CustomPainter code to the Bottom of the File
class OutlinedTooltipBorder extends CustomPainter {
  final Color color;
  final double width;
  OutlinedTooltipBorder({
    required this.color,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.08928571, size.height * 0.01948878);
    path_0.lineTo(size.width * 0.9107143, size.height * 0.01948878);
    path_0.cubicTo(
        size.width * 0.9575607,
        size.height * 0.01948878,
        size.width * 0.9955357,
        size.height * 0.06572022,
        size.width * 0.9955357,
        size.height * 0.1227496);
    path_0.lineTo(size.width * 0.9955357, size.height * 0.5792717);
    path_0.cubicTo(
        size.width * 0.9955357,
        size.height * 0.6363000,
        size.width * 0.9575607,
        size.height * 0.6825326,
        size.width * 0.9107143,
        size.height * 0.6825326);
    path_0.lineTo(size.width * 0.7250589, size.height * 0.6825326);
    path_0.cubicTo(
        size.width * 0.6944661,
        size.height * 0.6825326,
        size.width * 0.6657982,
        size.height * 0.7007022,
        size.width * 0.6482554,
        size.height * 0.7312130);
    path_0.lineTo(size.width * 0.5181589, size.height * 0.9574674);
    path_0.cubicTo(
        size.width * 0.5053661,
        size.height * 0.9797174,
        size.width * 0.4780946,
        size.height * 0.9789500,
        size.width * 0.4661571,
        size.height * 0.9560065);
    path_0.lineTo(size.width * 0.3514911, size.height * 0.7355978);
    path_0.cubicTo(
        size.width * 0.3343036,
        size.height * 0.7025565,
        size.width * 0.3044143,
        size.height * 0.6825326,
        size.width * 0.2722893,
        size.height * 0.6825326);
    path_0.lineTo(size.width * 0.08928571, size.height * 0.6825326);
    path_0.cubicTo(
        size.width * 0.04244018,
        size.height * 0.6825326,
        size.width * 0.004464286,
        size.height * 0.6363000,
        size.width * 0.004464286,
        size.height * 0.5792717);
    path_0.lineTo(size.width * 0.004464286, size.height * 0.1227498);
    path_0.cubicTo(
        size.width * 0.004464286,
        size.height * 0.06572022,
        size.width * 0.04244018,
        size.height * 0.01948878,
        size.width * 0.08928571,
        size.height * 0.01948878);
    path_0.close();

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    paint_0_stroke.color = color;
    canvas.drawPath(path_0, paint_0_stroke);

    // Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    // paint_0_fill.color = Color(0xff000000).withOpacity(1.0);
    // canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
