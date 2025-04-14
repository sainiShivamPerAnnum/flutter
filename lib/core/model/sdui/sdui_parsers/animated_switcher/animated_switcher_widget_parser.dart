import 'package:felloapp/core/model/sdui/sdui_parsers/animated_switcher/animated_switcher_widget.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

class AnimatedSwitcherWidgetParser extends StacParser<AnimatedSwitcherWidget> {
  const AnimatedSwitcherWidgetParser();

  @override
  AnimatedSwitcherWidget getModel(Map<String, dynamic> json) =>
      AnimatedSwitcherWidget.fromJson(json);

  @override
  String get type => 'animatedSwitcher';

  @override
  Widget parse(BuildContext context, AnimatedSwitcherWidget model) {
    return _CustomAnimatedSwitcherBuilder(
      model: model,
    );
  }
}

class _CustomAnimatedSwitcherBuilder extends StatefulWidget {
  const _CustomAnimatedSwitcherBuilder({
    required this.model,
  });

  final AnimatedSwitcherWidget model;

  @override
  State<_CustomAnimatedSwitcherBuilder> createState() =>
      _CustomAnimatedSwitcherBuilderState();
}

class _CustomAnimatedSwitcherBuilderState
    extends State<_CustomAnimatedSwitcherBuilder> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: widget.model.durationInMs ?? 300),
      reverseDuration: widget.model.reverseDurationInMs != null
          ? Duration(milliseconds: widget.model.reverseDurationInMs!)
          : null,
      switchInCurve: _getCurve(widget.model.switchInCurve),
      switchOutCurve: _getCurve(widget.model.switchOutCurve),
      transitionBuilder: widget.model.transitionBuilder != null
          ? _getTransitionBuilder(widget.model.transitionBuilder!)
          : AnimatedSwitcher.defaultTransitionBuilder,
      layoutBuilder: widget.model.layoutBuilder != null
          ? _getLayoutBuilder(widget.model.layoutBuilder!)
          : AnimatedSwitcher.defaultLayoutBuilder,
      child: widget.model.child != null
          ? Stac.fromJson(widget.model.child, context)
          : null,
    );
  }

  Curve _getCurve(String? curveName) {
    switch (curveName) {
      case 'linear':
        return Curves.linear;
      case 'decelerate':
        return Curves.decelerate;
      case 'ease':
        return Curves.ease;
      case 'easeIn':
        return Curves.easeIn;
      case 'easeOut':
        return Curves.easeOut;
      case 'easeInOut':
        return Curves.easeInOut;
      case 'fastOutSlowIn':
        return Curves.fastOutSlowIn;
      case 'bounceIn':
        return Curves.bounceIn;
      case 'bounceOut':
        return Curves.bounceOut;
      case 'bounceInOut':
        return Curves.bounceInOut;
      case 'elasticIn':
        return Curves.elasticIn;
      case 'elasticOut':
        return Curves.elasticOut;
      case 'elasticInOut':
        return Curves.elasticInOut;
      default:
        return Curves.linear;
    }
  }

  Widget Function(Widget, Animation<double>) _getTransitionBuilder(
      String transitionType) {
    switch (transitionType) {
      case 'fade':
        return (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        };
      case 'scale':
        return (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        };
      case 'rotation':
        return (Widget child, Animation<double> animation) {
          return RotationTransition(turns: animation, child: child);
        };
      case 'slide':
        return (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        };
      default:
        return AnimatedSwitcher.defaultTransitionBuilder;
    }
  }

  Widget Function(Widget?, List<Widget>) _getLayoutBuilder(String layoutType) {
    switch (layoutType) {
      case 'stack':
        return (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        };
      default:
        return AnimatedSwitcher.defaultLayoutBuilder;
    }
  }
}
