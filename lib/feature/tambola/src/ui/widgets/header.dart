import 'package:felloapp/ui/elements/video_player/app_video_player.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:felloapp/util/url_type_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TambolaHeader extends StatelessWidget {
  const TambolaHeader({required this.uri, Key? key}) : super(key: key);
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
            case UrlType.VIDEO:
              return AppVideoPlayer(uri);
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
