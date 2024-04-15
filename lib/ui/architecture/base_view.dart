//Project Imports
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
//Flutter Imports
import 'package:flutter/material.dart';
//Pub Imports
import 'package:provider/provider.dart';

class BaseView<T extends BaseViewModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child)? builder;
  final void Function(T)? onModelReady;
  final void Function(T)? onModelDispose;
  final Widget? child;
  final T Function()? create;

  const BaseView({
    super.key,
    this.builder,
    this.onModelReady,
    this.onModelDispose,
    this.child,
    this.create,
  });

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  T? model;

  @override
  void initState() {
    super.initState();
    model = widget.create?.call() ?? locator<T>();
    widget.onModelReady?.call(model!);
  }

  @override
  void dispose() {
    if (widget.onModelDispose != null) widget.onModelDispose!(model!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => model,
      child: Consumer<T>(
        builder: widget.builder!,
        child: widget.child,
      ),
    );
  }
}
