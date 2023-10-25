import 'package:felloapp/core/model/sub_combos_model.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AutosaveComboGrid extends StatelessWidget {
  const AutosaveComboGrid({
    required this.frequency,
    required this.model,
    super.key,
  });

  final AutosaveProcessViewModel model;
  final FREQUENCY frequency;

  @override
  Widget build(BuildContext context) {
    List<SubComboModel> combo = model.getCombos(frequency);
    return GridView.builder(
      shrinkWrap: true,
      itemCount: combo.length + 1,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: SizeConfig.padding24,
        mainAxisSpacing: SizeConfig.padding10,
        mainAxisExtent: SizeConfig.screenWidth! * 0.4,
      ),
      itemBuilder: (ctx, i) {
        return i == combo.length
            ? (model.customComboModel != null
                ? GestureDetector(
                    onTap: () =>
                        model.openCustomInputModalSheet(model, isNew: false),
                    child: ComboCard(
                      combo: model.customComboModel!,
                      isCustomCreated: true,
                    ))
                : CustomComboCard(
                    model: model,
                  ))
            : GestureDetector(
                onTap: () => model.onComboTapped(i),
                child: ComboCard(
                  combo: combo[i],
                ),
              );
      },
    );
  }
}

class ComboCard extends StatelessWidget {
  const ComboCard({
    required this.combo,
    super.key,
    this.isCustomCreated = false,
  });

  final SubComboModel combo;
  final bool isCustomCreated;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        combo.popular
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        SizeConfig.roundness5,
                      ),
                      topRight: Radius.circular(SizeConfig.roundness5)),
                  color: const Color(0xffF7C780),
                ),
                height: SizeConfig.padding16,
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding10),
                child: Text(
                  "POPULAR",
                  style: TextStyles.body4,
                ),
              )
            : SizedBox(
                height: SizeConfig.padding16,
              ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    UiConstants.darkPrimaryColor.withOpacity(0.3),
                    const Color(0xffF7C780).withOpacity(0.3),
                  ],
                ),
                border: Border.all(
                    width: 1,
                    color: combo.isSelected
                        ? UiConstants.primaryColor
                        : Colors.grey),
                borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                color: UiConstants.kBackgroundColor2),
            padding: EdgeInsets.only(top: SizeConfig.padding10),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.network(
                    combo.icon.isNotEmpty
                        ? combo.icon
                        : "https://d37gtxigg82zaw.cloudfront.net/game-icons/knife-hit-icon.svg",
                    height: SizeConfig.padding20,
                  ),
                  Text(
                    "  " + combo.title,
                    style: TextStyles.sourceSansM.body2,
                  ),
                ],
              ),
              Divider(
                color: Colors.white.withOpacity(0.2),
                thickness: 0.5,
                height: SizeConfig.padding12,
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "₹${combo.LENDBOXP2P}",
                            style: TextStyles.sourceSansB.body1,
                          ),
                          Text(
                            "Flo",
                            style: TextStyles.body3
                                .colour(UiConstants.kTextColor3),
                          )
                        ],
                      ),
                    ),
                    Text(
                      "+",
                      style: TextStyles.rajdhaniB.title2
                          .colour(UiConstants.kTextColor),
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "₹${combo.AUGGOLD99}",
                          style: TextStyles.sourceSansB.body1,
                        ),
                        Text(
                          "Gold",
                          style:
                              TextStyles.body3.colour(UiConstants.kTextColor3),
                        )
                      ],
                    )),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.padding16),
              Container(
                height: SizeConfig.padding40,
                decoration: BoxDecoration(
                    color: UiConstants.kBackgroundColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          SizeConfig.roundness8,
                        ),
                        bottomRight: Radius.circular(SizeConfig.roundness8))),
                alignment: Alignment.center,
                child: Text(
                  combo.isSelected
                      ? "SELECTED"
                      : isCustomCreated
                          ? "UPDATE"
                          : "SELECT",
                  style: TextStyles.body3.colour(combo.isSelected
                      ? UiConstants.primaryColor
                      : Colors.white),
                ),
              )
            ]),
          ),
        ),
      ],
    );
  }
}

class CustomComboCard extends StatelessWidget {
  const CustomComboCard({required this.model, super.key});

  final AutosaveProcessViewModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => model.openCustomInputModalSheet(model),
      child: Column(
        children: [
          SizedBox(height: SizeConfig.padding16),
          Container(
            height: SizeConfig.screenWidth! * 0.36,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    UiConstants.darkPrimaryColor.withOpacity(0.3),
                    const Color(0xffF7C780).withOpacity(0.3),
                  ],
                ),
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                color: UiConstants.kBackgroundColor2),
            padding: EdgeInsets.only(top: SizeConfig.padding10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Create your own",
                      style: TextStyles.sourceSansM.body2,
                    ),
                  ],
                ),
                Divider(
                  color: Colors.white.withOpacity(0.2),
                  thickness: 0.5,
                  height: SizeConfig.padding12,
                ),
                Expanded(
                  child: Icon(
                    Icons.add_rounded,
                    color: Colors.white.withOpacity(0.5),
                    size: SizeConfig.padding64,
                  ),
                ),
                Container(
                  height: SizeConfig.padding40,
                  decoration: BoxDecoration(
                      color: UiConstants.kBackgroundColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                            SizeConfig.roundness8,
                          ),
                          bottomRight: Radius.circular(SizeConfig.roundness8))),
                  alignment: Alignment.center,
                  child: Text(
                    "CREATE",
                    style: TextStyles.body3.colour(Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
