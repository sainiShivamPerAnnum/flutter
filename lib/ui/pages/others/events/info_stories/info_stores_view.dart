import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/events/info_stories/info_stores_vm.dart';
import 'package:flutter/material.dart';

class InfoStories extends StatelessWidget {
  final String topic;

  const InfoStories({Key key, @required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<InfoStoriesViewModel>(
      onModelReady: (model) {
        model.init(topic);
      },
      onModelDispose: (model) {
        model.dump();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          body: Container(),
        );
      },
    );
  }
}
