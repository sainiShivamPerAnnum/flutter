import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_scaffold_widget.freezed.dart';
part 'base_scaffold_widget.g.dart';

@freezed
class BaseScaffoldWidget with _$BaseScaffoldWidget {
  const factory BaseScaffoldWidget({
    bool? extendBody,
    bool? extendBodyBehindAppBar,
    Map<String, dynamic>? appBar,
    Map<String, dynamic>? body,
    Map<String, dynamic>? floatingActionButton,
    String? floatingActionButtonLocation,
    String? floatingActionButtonAnimator,
    List<dynamic>? persistentFooterButtons,
    Map<String, dynamic>? drawer,
    Map<String, dynamic>? endDrawer,
    String? drawerScrimColor,
    String? backgroundColor,
    Map<String, dynamic>? bottomNavigationBar,
    Map<String, dynamic>? bottomSheet,
    bool? resizeToAvoidBottomInset,
    bool? primary,
    String? drawerDragStartBehavior,
    double? drawerEdgeDragWidth,
    bool? drawerEnableOpenDragGesture,
    bool? endDrawerEnableOpenDragGesture,
    bool? showBackgroundGrid,
    String? restorationId,
  }) = _BaseScaffoldWidget;

  factory BaseScaffoldWidget.fromJson(Map<String, dynamic> json) =>
      _$BaseScaffoldWidgetFromJson(json);
}
