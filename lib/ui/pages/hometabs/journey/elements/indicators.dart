import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class JRefreshIndicator extends StatelessWidget {
  const JRefreshIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: SizeConfig.navBarHeight,
      child: Container(
        width: SizeConfig.screenWidth,
        child: const LinearProgressIndicator(
          minHeight: 4,
          backgroundColor: UiConstants.gameCardColor,
          color: UiConstants.tertiarySolid,
        ),
      ),
    );
  }
}

class JPageLoader extends StatelessWidget {
  final JourneyPageViewModel model;
  const JPageLoader({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Consumer<JourneyService>(
      builder: (context, service, child) => AnimatedPositioned(
        top: (service.isLoading && service.isLoaderRequired)
            ? SizeConfig.pageHorizontalMargins
            : -400,
        duration: const Duration(seconds: 1),
        curve: Curves.decelerate,
        left: SizeConfig.pageHorizontalMargins,
        child: SafeArea(
          child: Container(
            width:
                SizeConfig.screenWidth! - SizeConfig.pageHorizontalMargins * 2,
            height: SizeConfig.padding80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.roundness16),
              color: Colors.black54,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black,
                radius: SizeConfig.avatarRadius * 2,
                child: SpinKitCircle(
                  color: UiConstants.primaryColor,
                  size: SizeConfig.avatarRadius * 1.5,
                ),
              ),
              title: Text(
                locale.btnLoading,
                style: TextStyles.rajdhaniB.title3.colour(Colors.white),
              ),
              subtitle: Text(
                locale.jLoadinglevels,
                style: TextStyles.sourceSans.body3.colour(Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
