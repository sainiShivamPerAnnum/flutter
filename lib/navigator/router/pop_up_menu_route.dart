import 'package:flutter/material.dart';

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;

typedef PositionedBuilder = Positioned Function(BuildContext context);

/// Displays a popup and returns the result from the popup.
///
/// This function is used to display a popup and returns the result obtained
/// from the popup.
///
/// Returns the result obtained from the popup, which can be of type [T]
Future<T?> showPopUp<T>(
  BuildContext context,
  PositionedBuilder positionedBuilder, [
  Function()? calculation,
]) async {
  calculation?.call();

  FocusScope.of(context).focusedChild?.unfocus();

  final NavigatorState navigator = Navigator.of(
    context,
  );

  final result = await navigator.push(
    _PopupMenuRoute<T>(
      positionedBuilder: positionedBuilder,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    ),
  );

  return result;
}

/// A custom popup route for displaying a popup menu.
///
/// This class represents a custom popup route that can be used to display a
/// popup menu.
class _PopupMenuRoute<T> extends PopupRoute<T> {
  /// Creates a new [_PopupMenuRoute] instance.
  ///
  /// The [positionedBuilder] is a callback function returns [Positioned] widget
  /// which will be passed as direct child of [Stack].
  _PopupMenuRoute({
    required this.barrierLabel,
    required this.positionedBuilder,
  });

  /// The callback function that builds the positioned widget for the popup.
  final PositionedBuilder positionedBuilder;
  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      reverseCurve: const Interval(0.0, _kMenuCloseIntervalEnd),
    );
  }

  @override
  Duration get transitionDuration => _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => Colors.black.withOpacity(.7);

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (context) {
          return Stack(
            children: [
              positionedBuilder(context),
            ],
          );
        },
      ),
    );
  }
}
