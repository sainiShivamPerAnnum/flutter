import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoldProHero extends StatelessWidget {
  const GoldProHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(
      builder: (context, model, child) {
        // final double goldQuantity = model.userFundWallet!.augGoldQuantity;
        // if (goldQuantity <= 0) {
        //   return NewGoldProHero();
        // } else if (goldQuantity <= 0.5) {
        //   return ProgressGoldProHero();
        // } else {
        //   return EligibleGoldProHero();
        // }
        return NewGoldProHero();
      },
    );
  }
}

class NewGoldProHero extends StatelessWidget {
  const NewGoldProHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Get 4.5% extra returns with Gold Pro ",
          style:
              TextStyles.sourceSansM.body2.colour(UiConstants.kGoldProPrimary),
        ),
        Transform.translate(
          offset: Offset(0, SizeConfig.padding1),
          child: Icon(
            Icons.arrow_forward_ios,
            size: SizeConfig.iconSize2,
            color: UiConstants.kGoldProPrimary,
          ),
        )
      ],
    );
  }
}

class ProgressGoldProHero extends StatelessWidget {
  const ProgressGoldProHero({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class EligibleGoldProHero extends StatelessWidget {
  const EligibleGoldProHero({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class InvestedGoldProHero extends StatelessWidget {
  const InvestedGoldProHero({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
