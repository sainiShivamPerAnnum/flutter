import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class AssetOptionsWidget extends StatelessWidget {
  const AssetOptionsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _OptionsGrid(
      runItemCount: 2,
      itemBuilder: (context, index) => const AssetInformationCard(),
      itemCount: 3,
    );
  }
}

class AssetInformationCard extends StatelessWidget {
  const AssetInformationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.grey4,
        borderRadius: BorderRadius.circular(
          SizeConfig.roundness12,
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Colors.black.withOpacity(.30),
          ),
          BoxShadow(
            offset: const Offset(2, 2),
            blurRadius: 10,
            spreadRadius: 2,
            color: Colors.black.withOpacity(.15),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: UiConstants.bg,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(SizeConfig.roundness12),
              ),
            ),
            child: Align(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.padding4,
                ),
                child: Text(
                  '12 Month Plan',
                  style: TextStyles.sourceSans.body3.copyWith(
                    color: UiConstants.teal3,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Text(
            '10%',
            style: TextStyles.rajdhaniSB.title2.copyWith(),
          ),
          Text(
            'Per annum',
            style: TextStyles.rajdhaniSB.body2.copyWith(),
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppImage(
                Assets.singleTambolaTicket,
                height: 16,
              ),
              SizedBox(
                width: SizeConfig.padding8,
              ),
              Text(
                '5X Tickets',
                style: TextStyles.sourceSans.body4,
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.padding8,
          ),
          Text(
            '+ 0.75% Returns',
            style: TextStyles.sourceSans.body4.copyWith(
              color: UiConstants.yellow2,
            ),
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
        ],
      ),
    );
  }
}

class _OptionsGrid extends StatelessWidget {
  const _OptionsGrid({
    required this.itemBuilder,
    required this.itemCount,
    this.runItemCount = 4,
  });

  final int runItemCount;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 16.0;
        final maxWidth = constraints.biggest.width;
        final containerWidth =
            (maxWidth - ((runItemCount - 1) * spacing)) / runItemCount;
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (int i = 0; i < itemCount; i++)
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  width: containerWidth,
                ),
                child: itemBuilder(context, i),
              )
          ],
        );
      },
    );
  }
}
