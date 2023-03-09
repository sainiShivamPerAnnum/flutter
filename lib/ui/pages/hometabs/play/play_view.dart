import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class Play extends StatelessWidget {
  Play({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<PlayViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Container(
          height: SizeConfig.screenHeight,
          child: Column(
            children: [
              SizedBox(height: SizeConfig.fToolBarHeight),
              Expanded(
                child: ListView(
                  cacheExtent: 500,
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  children: model.getOrderedPlayViewItems(model),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
