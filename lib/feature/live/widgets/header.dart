import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class LiveHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onViewAllPressed;

  const LiveHeader({
    required this.title,
    required this.subtitle,
    required this.onViewAllPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.sourceSansSB.body2,
              ),
              SizedBox(height: SizeConfig.padding4),
              Text(
                subtitle,
                style: TextStyles.sourceSans.body4.colour(
                  UiConstants.kTextColor5,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onViewAllPressed,
          child: Row(
            children: [
              Text(
                'VIEW ALL',
                 style: TextStyles.sourceSansSB.body3,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: SizeConfig.body3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
