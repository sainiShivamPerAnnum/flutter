import 'package:felloapp/base_util.dart';
import 'package:felloapp/feature/support-new/bloc/support_bloc.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FindUs extends StatelessWidget {
  const FindUs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupportBloc, SupportState>(
      builder: (context, state) {
        if (state is SupportData && state.socialItems.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You can also find us on',
                style: TextStyles.sourceSansSB.body1,
              ),
              SizedBox(
                height: SizeConfig.padding24,
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  double spacing = 18;
                  final maxWidth = constraints.biggest.width;
                  final containerWidth = (maxWidth - ((2 - 1) * spacing)) / 2;
                  return Wrap(
                    alignment: WrapAlignment.center,
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      for (final item in state.socialItems)
                        ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                            width: containerWidth,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              BaseUtil.launchUrl(item.link);
                            },
                            child: buildSocialMediaButton(
                              item.name,
                              item.icon,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: SizeConfig.padding24,
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

Widget buildSocialMediaButton(String title, String iconPath) {
  return Container(
    padding: EdgeInsets.all(SizeConfig.padding18),
    decoration: BoxDecoration(
      color: UiConstants.greyVarient,
      borderRadius: BorderRadius.circular(SizeConfig.roundness12),
    ),
    child: Row(
      children: [
        AppImage(
          iconPath,
          width: SizeConfig.body2,
          height: SizeConfig.body2,
        ),
        SizedBox(width: SizeConfig.padding8),
        Expanded(
          child: Text(
            title,
            style: TextStyles.sourceSansSB.body3,
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white,
          size: SizeConfig.body2,
        ),
      ],
    ),
  );
}
