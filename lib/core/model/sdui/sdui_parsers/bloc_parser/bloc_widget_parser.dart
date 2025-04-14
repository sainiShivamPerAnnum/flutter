import 'package:felloapp/core/model/sdui/sdui_parsers/bloc_parser/bloc_registry.dart';
import 'package:felloapp/core/model/sdui/sdui_parsers/bloc_parser/bloc_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stac/stac.dart';

/// The actual parser class that implements StacParser
class BlocWidgetParser extends StacParser<BlocWidget> {
  const BlocWidgetParser();

  @override
  BlocWidget getModel(Map<String, dynamic> json) => BlocWidget.fromJson(json);

  @override
  String get type => 'bloc';

  @override
  Widget parse(BuildContext context, BlocWidget model) {
    return _BlocWidgetBuilder(
      model: model,
    );
  }
}

/// Builder widget that handles the BLoC functionality
class _BlocWidgetBuilder extends StatefulWidget {
  const _BlocWidgetBuilder({
    required this.model,
  });

  final BlocWidget model;

  @override
  State<_BlocWidgetBuilder> createState() => _BlocWidgetBuilderState();
}

class _BlocWidgetBuilderState extends State<_BlocWidgetBuilder> {
  // BLoC instance - will be created based on blocType
  dynamic _bloc;

  @override
  void initState() {
    super.initState();
    _createBloc();
  }

  @override
  void dispose() {
    // Close the BLoC when widget is disposed
    if (_bloc != null && _bloc is Bloc) {
      (_bloc as Bloc).close();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(_BlocWidgetBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recreate BLoC if the type changes
    if (oldWidget.model.blocType != widget.model.blocType) {
      if (_bloc != null && _bloc is Bloc) {
        (_bloc as Bloc).close();
      }
      _createBloc();
    }
  }

  void _createBloc() {
    // Create the appropriate BLoC based on blocType
    _bloc = BlocRegistry.createBloc(
      widget.model.blocType,
      widget.model.initialState ?? {},
    );
  }

  @override
  Widget build(BuildContext context) {
    // Return appropriate widget based on widgetType
    switch (widget.model.widgetType) {
      case 'provider':
        return _buildProvider(context);
      case 'builder':
        return _buildBuilder(context);
      case 'consumer':
        return _buildConsumer(context);
      case 'listener':
        return _buildListener(context);
      case 'eventDispatcher':
        return _buildEventDispatcher(context);
      default:
        return _buildProvider(context);
    }
  }

  // Build a BlocProvider
  Widget _buildProvider(BuildContext context) {
    // Get the BLoC instance
    if (_bloc == null) {
      return const SizedBox();
    }

    // Create the child widget
    Widget childWidget = widget.model.child != null
        ? Stac.fromJson(widget.model.child!, context)!
        : const SizedBox();

    // Create the provider with the child - using initialEvent if specified
    return BlocRegistry.createGenericProvider(
      _bloc,
      childWidget,
      initialEvent: widget.model.initialEvent,
    );
  }

  // Build a BlocBuilder
  Widget _buildBuilder(BuildContext context) {
    // For the builder, we get the BLoC from context using the blocType
    final blocType = widget.model.blocType;
    final bloc = BlocRegistry.getBlocFromContext(context, blocType);

    if (bloc == null) {
      debugPrint('Could not find BLoC of type $blocType in the context');
      return const SizedBox();
    }

    // Get buildWhen function if specified
    final buildWhen = _getBuildWhen();

    // Create the child widget
    Widget childWidget = widget.model.child != null
        ? Stac.fromJson(widget.model.child!, context)!
        : const SizedBox();

    // Use the generic builder that works with any BLoC type
    return BlocRegistry.buildGenericBuilder(
      context,
      bloc,
      buildWhen: buildWhen,
      builderProperties: widget.model.builderProperties,
      child: childWidget,
    );
  }

  // Build a BlocConsumer
  Widget _buildConsumer(BuildContext context) {
    // Similar to builder but with listener functionality
    final blocType = widget.model.blocType;
    final bloc = BlocRegistry.getBlocFromContext(context, blocType);

    if (bloc == null) {
      debugPrint('Could not find BLoC of type $blocType in the context');
      return const SizedBox();
    }

    // Create the child widget
    Widget childWidget = widget.model.child != null
        ? Stac.fromJson(widget.model.child!, context)!
        : const SizedBox();

    // Use the generic consumer that works with any BLoC type
    return BlocRegistry.buildGenericConsumer(
      context,
      bloc,
      buildWhen: _getBuildWhen(),
      listenWhen: _getListenWhen(),
      builderProperties: widget.model.builderProperties,
      child: childWidget,
    );
  }

  // Build a BlocListener
  Widget _buildListener(BuildContext context) {
    final blocType = widget.model.blocType;
    final bloc = BlocRegistry.getBlocFromContext(context, blocType);

    if (bloc == null) {
      debugPrint('Could not find BLoC of type $blocType in the context');
      return widget.model.child != null
          ? Stac.fromJson(widget.model.child!, context)!
          : const SizedBox();
    }

    // Create the child widget
    Widget childWidget = widget.model.child != null
        ? Stac.fromJson(widget.model.child!, context)!
        : const SizedBox();

    // Use the generic listener that works with any BLoC type
    return BlocRegistry.buildGenericListener(
      context,
      bloc,
      listenWhen: _getListenWhen(),
      child: childWidget,
      builderProperties: widget.model.builderProperties,
    );
  }

  // Build an event dispatcher
  Widget _buildEventDispatcher(BuildContext context) {
    if (widget.model.events == null || widget.model.events!.isEmpty) {
      return widget.model.child != null
          ? Stac.fromJson(widget.model.child!, context)!
          : const SizedBox();
    }

    // Create event dispatcher based on trigger type
    Widget childWidget = widget.model.child != null
        ? Stac.fromJson(widget.model.child!, context)!
        : const SizedBox();

    // Wrap child with GestureDetector for each event
    for (final event in widget.model.events!) {
      final blocType = widget.model.blocType;

      switch (event.trigger) {
        case 'tap':
          childWidget = GestureDetector(
            onTap: () => _dispatchEvent(context, blocType, event),
            child: childWidget,
          );
          break;
        case 'longPress':
          childWidget = GestureDetector(
            onLongPress: () => _dispatchEvent(context, blocType, event),
            child: childWidget,
          );
          break;
        case 'doubleTap':
          childWidget = GestureDetector(
            onDoubleTap: () => _dispatchEvent(context, blocType, event),
            child: childWidget,
          );
          break;
        default:
          childWidget = GestureDetector(
            onTap: () => _dispatchEvent(context, blocType, event),
            child: childWidget,
          );
          break;
      }
    }

    return childWidget;
  }

  // Dispatch an event to the BLoC
  void _dispatchEvent(
    BuildContext context,
    String blocType,
    BlocEventModel event,
  ) {
    // Get the appropriate BLoC from context
    final bloc = BlocRegistry.getBlocFromContext(context, blocType);
    if (bloc != null) {
      // Create and add event
      final blocEvent = BlocRegistry.createEvent(
        blocType,
        event.type,
        event.payload ?? {},
      );
      if (blocEvent != null) {
        bloc.add(blocEvent);
      }
    }
  }

  // Get buildWhen function from JSON configuration
  bool Function(dynamic, dynamic)? _getBuildWhen() {
    if (widget.model.buildWhen == null) return null;

    final buildWhenConfig = widget.model.buildWhen;

    // Create a dynamic buildWhen function based on the JSON configuration
    return (previous, current) {
      // Parse the buildWhen string to determine when to rebuild
      // This allows JSON to control when rebuilds happen

      if (buildWhenConfig!.contains('!=')) {
        // Handle not equals comparison
        final parts = buildWhenConfig.split('!=');
        if (parts.length == 2) {
          final leftPath = parts[0].trim().split('.');
          final rightPath = parts[1].trim().split('.');

          // Extract values from state using the paths
          final leftPrevValue = _getNestedValue(previous, leftPath);
          final leftCurrValue = _getNestedValue(current, leftPath);

          // If right side is a path, extract from state
          if (rightPath[0] == 'previous' || rightPath[0] == 'current') {
            // final rightPrevValue = _getNestedValue(previous, rightPath);
            final rightCurrValue = _getNestedValue(current, rightPath);

            // Compare appropriate values based on previous/current
            return leftCurrValue != rightCurrValue;
          } else {
            // Right side is a literal value
            final literalValue = rightPath.join('.').trim();

            // Check if previous value was equal but current is not
            return leftPrevValue == _parseValue(literalValue) &&
                leftCurrValue != _parseValue(literalValue);
          }
        }
      } else if (buildWhenConfig.contains('==')) {
        // Handle equals comparison
        final parts = buildWhenConfig.split('==');
        if (parts.length == 2) {
          final leftPath = parts[0].trim().split('.');
          final rightPath = parts[1].trim().split('.');

          // Extract values from state
          final leftPrevValue = _getNestedValue(previous, leftPath);
          final leftCurrValue = _getNestedValue(current, leftPath);

          // If right side is a path
          if (rightPath[0] == 'previous' || rightPath[0] == 'current') {
            final rightPrevValue = _getNestedValue(previous, rightPath);
            final rightCurrValue = _getNestedValue(current, rightPath);

            return leftCurrValue == rightCurrValue &&
                leftPrevValue != rightPrevValue;
          } else {
            // Right side is a literal value
            final literalValue = rightPath.join('.').trim();

            return leftPrevValue != _parseValue(literalValue) &&
                leftCurrValue == _parseValue(literalValue);
          }
        }
      } else if (buildWhenConfig.contains('>')) {
        // Handle greater than comparison
        final parts = buildWhenConfig.split('>');
        if (parts.length == 2) {
          final leftPath = parts[0].trim().split('.');
          final rightPath = parts[1].trim().split('.');

          // Extract numeric values
          final leftPrevValue = _getNestedValue(previous, leftPath);
          final leftCurrValue = _getNestedValue(current, leftPath);

          if (leftPrevValue is num && leftCurrValue is num) {
            if (rightPath[0] == 'previous' || rightPath[0] == 'current') {
              final rightPrevValue = _getNestedValue(previous, rightPath);
              final rightCurrValue = _getNestedValue(current, rightPath);

              if (rightPrevValue is num && rightCurrValue is num) {
                // Only rebuild if the comparison result changed
                final prevResult = leftPrevValue > rightPrevValue;
                final currResult = leftCurrValue > rightCurrValue;
                return prevResult != currResult;
              }
            } else {
              // Right side is a literal numeric value
              final literalValue = double.tryParse(rightPath.join('.').trim());
              if (literalValue != null) {
                final prevResult = leftPrevValue > literalValue;
                final currResult = leftCurrValue > literalValue;
                return prevResult != currResult;
              }
            }
          }
        }
      } else if (buildWhenConfig.contains('<')) {
        // Handle less than comparison
        final parts = buildWhenConfig.split('<');
        if (parts.length == 2) {
          final leftPath = parts[0].trim().split('.');
          final rightPath = parts[1].trim().split('.');

          // Extract numeric values
          final leftPrevValue = _getNestedValue(previous, leftPath);
          final leftCurrValue = _getNestedValue(current, leftPath);

          if (leftPrevValue is num && leftCurrValue is num) {
            if (rightPath[0] == 'previous' || rightPath[0] == 'current') {
              final rightPrevValue = _getNestedValue(previous, rightPath);
              final rightCurrValue = _getNestedValue(current, rightPath);

              if (rightPrevValue is num && rightCurrValue is num) {
                // Only rebuild if the comparison result changed
                final prevResult = leftPrevValue < rightPrevValue;
                final currResult = leftCurrValue < rightCurrValue;
                return prevResult != currResult;
              }
            } else {
              // Right side is a literal numeric value
              final literalValue = double.tryParse(rightPath.join('.').trim());
              if (literalValue != null) {
                final prevResult = leftPrevValue < literalValue;
                final currResult = leftCurrValue < literalValue;
                return prevResult != currResult;
              }
            }
          }
        }
      } else if (buildWhenConfig == 'always') {
        // Always rebuild
        return true;
      } else if (buildWhenConfig.startsWith('changed.')) {
        // Check if a specific property changed
        final propertyPath = buildWhenConfig.substring(8).split('.');
        final prevValue = _getNestedValue(previous, propertyPath);
        final currValue = _getNestedValue(current, propertyPath);
        return prevValue != currValue;
      } else if (buildWhenConfig.startsWith('type.')) {
        // Check if the state is of a specific type
        final stateType = buildWhenConfig.substring(5);
        final prevMatches = previous.runtimeType.toString() == stateType;
        final currMatches = current.runtimeType.toString() == stateType;
        return !prevMatches &&
            currMatches; // Only rebuild when changing to this type
      } else if (buildWhenConfig.startsWith('typeChanged')) {
        // Rebuild when state type changes
        return previous.runtimeType != current.runtimeType;
      }

      // For state classes, check if runtimeType matches state string
      if (previous.runtimeType.toString() != current.runtimeType.toString()) {
        return true; // Rebuild when state class changes
      }

      // Default fallback - rebuild on any state change
      return true;
    };
  }

  // Get listenWhen function based on JSON configuration
  bool Function(dynamic, dynamic)? _getListenWhen() {
    // Check if listenWhen is specified in the builderProperties
    if (widget.model.builderProperties == null ||
        !widget.model.builderProperties!.containsKey('listenWhen')) {
      return null;
    }

    final listenWhenConfig =
        widget.model.builderProperties!['listenWhen'] as String?;
    if (listenWhenConfig == null) return null;

    // Create a dynamic listenWhen function based on the JSON configuration
    return (previous, current) {
      // Similar implementation as buildWhen but for listen events

      if (listenWhenConfig.contains('!=')) {
        // Handle not equals comparison
        final parts = listenWhenConfig.split('!=');
        if (parts.length == 2) {
          final leftPath = parts[0].trim().split('.');
          final rightPath = parts[1].trim().split('.');

          // Extract values from state using the paths
          final leftPrevValue = _getNestedValue(previous, leftPath);
          final leftCurrValue = _getNestedValue(current, leftPath);

          // If right side is a path, extract from state
          if (rightPath[0] == 'previous' || rightPath[0] == 'current') {
            // final rightPrevValue = _getNestedValue(previous, rightPath);
            final rightCurrValue = _getNestedValue(current, rightPath);

            // Compare appropriate values based on previous/current
            return leftCurrValue != rightCurrValue;
          } else {
            // Right side is a literal value
            final literalValue = rightPath.join('.').trim();

            // Check if previous value was equal but current is not
            return leftPrevValue == _parseValue(literalValue) &&
                leftCurrValue != _parseValue(literalValue);
          }
        }
      } else if (listenWhenConfig.contains('==')) {
        // Handle equals comparison
        final parts = listenWhenConfig.split('==');
        if (parts.length == 2) {
          final leftPath = parts[0].trim().split('.');
          final rightPath = parts[1].trim().split('.');

          // Extract values from state
          final leftPrevValue = _getNestedValue(previous, leftPath);
          final leftCurrValue = _getNestedValue(current, leftPath);

          // If right side is a path
          if (rightPath[0] == 'previous' || rightPath[0] == 'current') {
            final rightPrevValue = _getNestedValue(previous, rightPath);
            final rightCurrValue = _getNestedValue(current, rightPath);

            return leftCurrValue == rightCurrValue &&
                leftPrevValue != rightPrevValue;
          } else {
            // Right side is a literal value
            final literalValue = rightPath.join('.').trim();

            return leftPrevValue != _parseValue(literalValue) &&
                leftCurrValue == _parseValue(literalValue);
          }
        }
      } else if (listenWhenConfig == 'always') {
        // Always listen
        return true;
      } else if (listenWhenConfig.startsWith('changed.')) {
        // Check if a specific property changed
        final propertyPath = listenWhenConfig.substring(8).split('.');
        final prevValue = _getNestedValue(previous, propertyPath);
        final currValue = _getNestedValue(current, propertyPath);
        return prevValue != currValue;
      } else if (listenWhenConfig.startsWith('type.')) {
        // Listen when the state is of a specific type
        final stateType = listenWhenConfig.substring(5);
        final prevMatches = previous.runtimeType.toString() == stateType;
        final currMatches = current.runtimeType.toString() == stateType;
        return !prevMatches &&
            currMatches; // Only listen when changing to this type
      } else if (listenWhenConfig.startsWith('typeChanged')) {
        // Listen when state type changes
        return previous.runtimeType != current.runtimeType;
      }

      // For state classes, check if runtime type matches the expected type
      if (listenWhenConfig.startsWith('is')) {
        final stateType = listenWhenConfig.substring(2);
        return current.runtimeType.toString() == stateType;
      }

      // Default fallback - listen on any state change
      return true;
    };
  }

  // Helper method to get a nested value from a dynamic object
  dynamic _getNestedValue(dynamic state, List<String> path) {
    if (path.isEmpty) return null;

    // Handle "previous" and "current" special keywords
    if (path[0] == 'previous' || path[0] == 'current') {
      path = path.sublist(1); // Remove the first element
    }

    // For class-based states, try property access
    if (state is! Map) {
      try {
        // Try to access the first property
        if (path.isEmpty) return state;

        var current = state;
        for (final key in path) {
          // Access property by name (this is dynamic and may fail)
          current = current?[key] ??
              current?.$key; // Try both map and property access
        }
        return current;
      } catch (e) {
        return null; // Path doesn't exist or can't be accessed
      }
    }

    // For Map states, use standard map access
    dynamic current = state;
    for (final key in path) {
      if (current is Map && current.containsKey(key)) {
        current = current[key];
      } else {
        return null; // Path doesn't exist
      }
    }

    return current;
  }

  // Helper method to parse string value to appropriate type
  dynamic _parseValue(String value) {
    // Try to parse as number
    final number = num.tryParse(value);
    if (number != null) return number;

    // Try to parse as boolean
    if (value.toLowerCase() == 'true') return true;
    if (value.toLowerCase() == 'false') return false;

    // Treat as string but remove quotes if present
    if (value.startsWith('"') && value.endsWith('"')) {
      return value.substring(1, value.length - 1);
    }
    if (value.startsWith("'") && value.endsWith("'")) {
      return value.substring(1, value.length - 1);
    }

    // Default as string
    return value;
  }
}
