import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/profile/settings/settings_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SettingsViewModel>(
      onModelReady: (model) {},
      onModelDispose: (model) {},
      builder: ((context, model, child) => Scaffold()),
    );
  }
}
