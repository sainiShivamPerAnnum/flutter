import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AmountChip extends StatelessWidget {
  const AmountChip(
      {required this.isActive,
      required this.amt,
      required this.onClick,
      required this.index,
      Key? key,
      this.isBest = false})
      : super(key: key);

  final bool isActive;
  final int amt;
  final bool isBest;
  final Function(int val) onClick;
  final int index;

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Container(
      height: SizeConfig.padding44,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () {
                onClick(index);
              },
              child: Container(
                height: SizeConfig.padding40,
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.padding8,
                  horizontal: SizeConfig.padding12,
                ),
                margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFFFEF5DC)
                        : const Color(0xFFFEF5DC).withOpacity(0.2),
                    width: SizeConfig.border0,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "₹ ${amt.toInt()}",
                  style: TextStyles.sourceSansL.body2.colour(Colors.white),
                ),
              ),
            ),
          ),
          if (isBest)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding4,
                  vertical: SizeConfig.padding2,
                ),
                decoration: const BoxDecoration(
                  color: UiConstants.primaryColor,
                ),
                child: Text(
                  locale.best,
                  style: TextStyles.rajdhaniSB.body5,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class AmountChipV2 extends StatelessWidget {
  const AmountChipV2(
      {required this.isActive,
      required this.amt,
      required this.onClick,
      required this.index,
      Key? key,
      this.isBest = false})
      : super(key: key);

  final bool isActive;
  final int amt;
  final bool isBest;
  final Function(int val) onClick;
  final int index;

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return SizedBox(
      height: SizeConfig.padding46 + SizeConfig.padding2,
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isBest)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding8,
                vertical: SizeConfig.padding2,
              ),
              decoration: const BoxDecoration(
                color: UiConstants.teal4,
              ),
              child: Text(
                locale.best,
                style: TextStyles.sourceSans.body4.copyWith(
                  fontSize: 10,
                ),
              ),
            ),
          if (!isBest) const Spacer(),
          GestureDetector(
            onTap: () {
              onClick(index);
            },
            child: Container(
              height: SizeConfig.padding32,
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding4,
                horizontal: SizeConfig.padding12,
              ),
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                border: Border.all(
                  color: isActive
                      ? UiConstants.teal3
                      : const Color(0xFFFEF5DC).withOpacity(0.2),
                  width: SizeConfig.border0,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "₹ ${amt.toInt()}",
                style: TextStyles.sourceSans.body2.colour(
                  isActive ? UiConstants.teal3 : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
