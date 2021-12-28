import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_controller_vm.dart';
import 'package:flutter/material.dart';

class LoginControllerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<LoginControllerViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) => model.exit(),
      builder: (ctx, model, child) => Scaffold(),
    );
  }
}
