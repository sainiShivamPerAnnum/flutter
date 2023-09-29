import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class Play extends StatelessWidget {
  const Play({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<PlayViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.kBackgroundColor,
          appBar: const FAppBar(
            showAvatar: false,
            type: FaqsType.play,
            title: "Play",
          ),
          body: SizedBox(
            height: SizeConfig.screenHeight,
            child: ListView(
              cacheExtent: 500,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: model.getOrderedPlayViewItems(model),
            ),
          ),
        );
      },
    );
  }
}
