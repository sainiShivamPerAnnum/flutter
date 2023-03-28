import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/tambola_card/tambola_card_vm.dart';
import 'package:felloapp/ui/pages/hometabs/play/widgets/tambola/tambola_controller.dart';
import 'package:felloapp/ui/pages/hometabs/play/widgets/tambola/tambola_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TambolaCard extends StatelessWidget {
  const TambolaCard({Key? key, required this.tambolaController})
      : super(key: key);
  final TambolaWidgetController tambolaController;
  @override
  Widget build(BuildContext context) {
    return BaseView<TambolaCardModel>(onModelReady: (model) {
      model.init();
    }, builder: (ctx, model, child) {
      return TambolaWidget(tambolaController, model);
    });
  }
}
