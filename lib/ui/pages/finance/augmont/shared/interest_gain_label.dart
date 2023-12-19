import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class InterestGainLabel extends StatelessWidget {
  const InterestGainLabel({
    required this.interest,
    super.key,
    this.onTap,
  });

  final double interest;
  final VoidCallback? onTap;

  void _onTap() {
    //
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? _onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$interest gms interest credited to Digital Gold',
            style: TextStyles.sourceSans.body3.copyWith(
              color: UiConstants.yellow3,
              height: 1,
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: UiConstants.yellow3,
            size: SizeConfig.padding18,
          )
        ],
      ),
    );
  }
}
