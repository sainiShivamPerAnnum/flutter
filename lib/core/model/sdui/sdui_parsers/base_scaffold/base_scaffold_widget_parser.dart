import 'package:felloapp/core/model/sdui/sdui_parsers/base_scaffold/base_scaffold_widget.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

class BaseScaffoldWidgetParser extends StacParser<BaseScaffoldWidget> {
  const BaseScaffoldWidgetParser();

  @override
  BaseScaffoldWidget getModel(Map<String, dynamic> json) =>
      BaseScaffoldWidget.fromJson(json);

  @override
  String get type => 'baseScaffold';

  @override
  Widget parse(BuildContext context, BaseScaffoldWidget model) {
    return _CustomBaseScaffoldBuilder(
      model: model,
    );
  }
}

class _CustomBaseScaffoldBuilder extends StatefulWidget {
  const _CustomBaseScaffoldBuilder({
    required this.model,
  });

  final BaseScaffoldWidget model;

  @override
  State<_CustomBaseScaffoldBuilder> createState() =>
      _CustomBaseScaffoldBuilderState();
}

class _CustomBaseScaffoldBuilderState
    extends State<_CustomBaseScaffoldBuilder> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      extendBody: widget.model.extendBody ?? false,
      extendBodyBehindAppBar: widget.model.extendBodyBehindAppBar ?? false,
      appBar: widget.model.appBar != null
          ? _buildAppBar(context, widget.model.appBar!)
          : null,
      body: widget.model.body != null
          ? Stac.fromJson(widget.model.body!, context)
          : null,
      floatingActionButton: widget.model.floatingActionButton != null
          ? Stac.fromJson(
              widget.model.floatingActionButton!,
              context,
            )
          : null,
      floatingActionButtonLocation: _getFloatingActionButtonLocation(
        widget.model.floatingActionButtonLocation,
      ),
      // persistentFooterButtons: widget.model.persistentFooterButtons != null
      //     ? _buildPersistentFooterButtons(
      //         context,
      //         widget.model.persistentFooterButtons!,
      //       )
      //     : null,
      drawer: widget.model.drawer != null
          ? Stac.fromJson(
              widget.model.drawer!,
              context,
            )
          : null,
      endDrawer: widget.model.endDrawer != null
          ? Stac.fromJson(
              widget.model.endDrawer!,
              context,
            )
          : null,
      drawerScrimColor: widget.model.drawerScrimColor?.toColor(context),
      backgroundColor: widget.model.backgroundColor?.toColor(context),
      bottomNavigationBar: widget.model.bottomNavigationBar != null
          ? Stac.fromJson(
              widget.model.bottomNavigationBar!,
              context,
            )
          : null,
      bottomSheet: widget.model.bottomSheet != null
          ? Stac.fromJson(
              widget.model.bottomSheet!,
              context,
            )
          : null,
      resizeToAvoidBottomInset: widget.model.resizeToAvoidBottomInset,
      primary: widget.model.primary ?? true,
      drawerDragStartBehavior:
          _getDragStartBehavior(widget.model.drawerDragStartBehavior),
      drawerEdgeDragWidth: widget.model.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture:
          widget.model.drawerEnableOpenDragGesture ?? true,
      endDrawerEnableOpenDragGesture:
          widget.model.endDrawerEnableOpenDragGesture ?? true,
      restorationId: widget.model.restorationId,
      showBackgroundGrid: widget.model.showBackgroundGrid ?? true,
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, Map<String, dynamic> appBarData) {
    // This is a simplified implementation. You would need to create a proper AppBar parser
    // and use it here for a complete solution
    return AppBar(
      title: appBarData['title'] != null
          ? Stac.fromJson(
              appBarData['title'],
              context,
            )
          : null,
      backgroundColor: appBarData['backgroundColor'] != null
          ? (appBarData['backgroundColor'] as String).toColor(context)
          : null,
      // Add other AppBar properties as needed
    );
  }

  // List<Widget> _buildPersistentFooterButtons(
  //     BuildContext context, List<dynamic> buttonsData) {
  //   return buttonsData
  //       .map((buttonData) =>
  //           Stac.fromJson(context, buttonData as Map<String, dynamic>))
  //       .toList();
  // }

  FloatingActionButtonLocation? _getFloatingActionButtonLocation(
      String? location) {
    if (location == null) return null;

    switch (location) {
      case 'centerDocked':
        return FloatingActionButtonLocation.centerDocked;
      case 'centerFloat':
        return FloatingActionButtonLocation.centerFloat;
      case 'endDocked':
        return FloatingActionButtonLocation.endDocked;
      case 'endFloat':
        return FloatingActionButtonLocation.endFloat;
      case 'startDocked':
        return FloatingActionButtonLocation.startDocked;
      case 'startFloat':
        return FloatingActionButtonLocation.startFloat;
      case 'centerTop':
        return FloatingActionButtonLocation.centerTop;
      case 'startTop':
        return FloatingActionButtonLocation.startTop;
      case 'endTop':
        return FloatingActionButtonLocation.endTop;
      case 'miniCenterDocked':
        return FloatingActionButtonLocation.miniCenterDocked;
      case 'miniCenterFloat':
        return FloatingActionButtonLocation.miniCenterFloat;
      case 'miniCenterTop':
        return FloatingActionButtonLocation.miniCenterTop;
      case 'miniEndDocked':
        return FloatingActionButtonLocation.miniEndDocked;
      case 'miniEndFloat':
        return FloatingActionButtonLocation.miniEndFloat;
      case 'miniEndTop':
        return FloatingActionButtonLocation.miniEndTop;
      case 'miniStartDocked':
        return FloatingActionButtonLocation.miniStartDocked;
      case 'miniStartFloat':
        return FloatingActionButtonLocation.miniStartFloat;
      case 'miniStartTop':
        return FloatingActionButtonLocation.miniStartTop;
      default:
        return null;
    }
  }

  DragStartBehavior _getDragStartBehavior(String? behavior) {
    switch (behavior) {
      case 'down':
        return DragStartBehavior.down;
      case 'start':
      default:
        return DragStartBehavior.start;
    }
  }
}
