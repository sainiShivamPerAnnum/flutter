import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tambola/src/utils/styles/styles.dart';
import 'package:tambola/src/utils/url_type_helper.dart';

class TambolaHeader extends StatelessWidget {
  const TambolaHeader({Key? key, required this.uri}) : super(key: key);
  // final TambolaHomeViewModel model;
  final String uri;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight! * 0.4,
      width: double.infinity,
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.padding24, vertical: 12),
      decoration: BoxDecoration(
          color: UiConstants.kBackgroundColor,
          borderRadius: BorderRadius.circular(SizeConfig.roundness12)),
      child: Builder(
        builder: (_) {
          switch (UrlTypeHelper.getType(uri)) {
            case UrlType.IMAGE:
              return SvgPicture.network(uri);
            //TODO: REVERT WHEN PACAKGE IS SETUP

            // case UrlType.VIDEO:
            //   return TambolaVideoPlayer(link: model.game!.walkThroughUri!);

            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
