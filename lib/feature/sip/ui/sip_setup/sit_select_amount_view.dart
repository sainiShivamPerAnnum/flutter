import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_components/gold_pro_choice_chips.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SipSelectAmountView extends StatelessWidget {
  const SipSelectAmountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                "Sip Value",
                style: TextStyles.rajdhaniM.body2.colour(Colors.white54),
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    child: IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        // model.decrementGoldBalance();
                      },
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // AnimatedContainer(
                        //   width: (SizeConfig.padding22 +
                        //               SizeConfig.padding1) *
                        //           model.goldFieldController.text
                        //               .replaceAll('.', "")
                        //               .length +
                        //       (model.goldFieldController.text
                        //               .contains('.')
                        //           ? SizeConfig.padding6
                        //           : 0),
                        //   duration: const Duration(seconds: 0),
                        //   curve: Curves.easeIn,
                        //   child: TextField(
                        //     maxLength: 3,
                        //     controller: model.goldFieldController,
                        //     keyboardType: TextInputType.number,
                        //     onChanged: model.onTextFieldValueChanged,
                        //     inputFormatters: [
                        //       TextInputFormatter.withFunction(
                        //           (oldValue, newValue) {
                        //         var decimalSeparator = NumberFormat()
                        //             .symbols
                        //             .DECIMAL_SEP;
                        //         var r = RegExp(r'^\d*(\' +
                        //             decimalSeparator +
                        //             r'\d*)?$');
                        //         return r.hasMatch(newValue.text)
                        //             ? newValue
                        //             : oldValue;
                        //       })
                        //     ],
                        //     decoration: const InputDecoration(
                        //       counter: Offstage(),
                        //       focusedBorder: InputBorder.none,
                        //       border: InputBorder.none,
                        //       enabledBorder: InputBorder.none,
                        //       disabledBorder: InputBorder.none,
                        //       isDense: true,
                        //     ),
                        //     style: TextStyles.rajdhaniBL.title1
                        //         .colour(Colors.white),
                        //   ),
                        // ),
                        Text(
                          "gms",
                          style:
                              TextStyles.sourceSansB.body0.colour(Colors.white),
                        )
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      color: Colors.white,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        // model.incrementGoldBalance();
                      },
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
            child: Placeholder()
            // Column(
            //   children: [
            //     Row(
            //         crossAxisAlignment: CrossAxisAlignment.end,
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: List.generate(
            //           model.chipsList.length,
            //           (index) => GoldProChoiceChip(
            //             index: index,
            //             chipValue: "${model.chipsList[index].value}g",
            //             isBest: model.chipsList[index].isBest,
            //             isSelected: index == model.selectedChipIndex,
            //             onTap: () => model.onChipSelected(index),
            //           ),
            //         )),
            //     SizedBox(
            //       width: SizeConfig.screenWidth!,
            //       child: Slider(
            //         value: model.sliderValue,
            //         onChanged: model.updateSliderValue,
            //         // divisions: 4,
            //         inactiveColor: Colors.grey,
            //       ),
            //     ),
            //   ],
            // ),
            ),
      ],
    );
  }
}
