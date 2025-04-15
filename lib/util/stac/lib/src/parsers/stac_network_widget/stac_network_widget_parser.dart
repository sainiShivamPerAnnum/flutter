import 'package:flutter/cupertino.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_network_widget/stac_network_widget.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacNetworkWidgetParser extends StacParser<StacNetworkWidget> {
  const StacNetworkWidgetParser();

  @override
  String get type => WidgetType.networkWidget.name;

  @override
  StacNetworkWidget getModel(Map<String, dynamic> json) =>
      StacNetworkWidget.fromJson(json);

  @override
  Widget parse(BuildContext context, StacNetworkWidget model) {
    return Stac.fromNetwork(context: context, request: model.request);
  }
}
