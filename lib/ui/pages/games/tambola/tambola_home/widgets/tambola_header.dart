import 'package:felloapp/ui/pages/games/tambola/tambola_home/view_model/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/widgets/tambola_video_player.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:felloapp/util/url_type_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TambolaHeader extends StatelessWidget {
  const TambolaHeader({Key? key, required this.model}) : super(key: key);
  final TambolaHomeViewModel model;

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
          switch (UrlTypeHelper.getType(model.game!.walkThroughUri!)) {
            case UrlType.IMAGE:
              return SvgPicture.network(model.game!.walkThroughUri!);
            case UrlType.VIDEO:
              return TambolaVideoPlayer(link: model.game!.walkThroughUri!);

            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
