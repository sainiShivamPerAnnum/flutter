import 'dart:developer';

import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

import '../../../widgets/appbar/appbar.dart';

class Play extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  final RootViewModel rootVm;

   Play({Key? key, required this.rootVm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    log("ROOT: Play view build called");

    return BaseView<PlayViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) {
        log("ROOT: Play view baseView build called");
        return Scaffold(
          key: ValueKey(Constants.PLAY_SCREEN_TAG),
          backgroundColor: Colors.transparent,
          appBar: FAppBar(
              type: FaqsType.play,
              backgroundColor: Colors.transparent,
              showAvatar: true,
              leftPad: SizeConfig.padding10),
          body: SingleChildScrollView(
            controller: _controller,
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: model.getOrderedPlayViewItems(model,rootVm),
            ),
          ),
        );
      },
    );
  }
}
