import 'dart:developer';

import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';

import '../../../widgets/appbar/appbar.dart';

class Play extends StatelessWidget {
  final ScrollController _controller = ScrollController();

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
          backgroundColor: Colors.transparent,
          appBar: FAppBar(
            type: FaqsType.play,
            backgroundColor: Colors.transparent,
            showAvatar: false,
            title: 'Play',
          ),
          body: SingleChildScrollView(
            controller: _controller,
            physics: BouncingScrollPhysics(),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: model.getOrderedPlayViewItems(model)),
          ),
        );
      },
    );
  }
}
