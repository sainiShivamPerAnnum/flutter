import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/shared/spotlight_controller.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class Play extends StatelessWidget {
  Play({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<PlayViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Container(
            height: SizeConfig.screenHeight,
            child: ShowCaseWidget(
              enableAutoScroll: true,
              onFinish: () {
                SpotLightController.instance.completer.complete();
                SpotLightController.instance.isTourStarted = false;
                SpotLightController.instance.startShowCase = false;
              },
              onSkipButtonClicked: () {
                SpotLightController.instance.isSkipButtonClicked = true;
                SpotLightController.instance.startShowCase = false;
              },
              builder: Builder(builder: (context) {
                SpotLightController.instance.playViewContext = context;
                return Column(
                  children: [
                    SizedBox(height: SizeConfig.fToolBarHeight),
                    Expanded(
                      child: ListView(
                        cacheExtent: 500,
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        children: model.getOrderedPlayViewItems(model),
                      ),
                    ),
                  ],
                );
              }),
            ));
      },
    );
  }
}
