import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stac/stac.dart';

/// A completely dynamic registry for BLoC types and operations
class BlocRegistry {
  // Map of BLoC instances by ID to prevent duplicate creation
  static final Map<String, dynamic> _blocInstances = {};

  // Map of BLoC factories that can be registered at runtime
  static final Map<String, Function(Map<String, dynamic>)> _blocFactories = {};

  // Map of event factories that can be registered at runtime
  static final Map<String, Function(String, Map<String, dynamic>)>
      _eventFactories = {};

  // Register a BLoC factory at runtime
  static void registerBlocFactory(
    String blocType,
    Function(Map<String, dynamic>) factory,
  ) {
    _blocFactories[blocType] = factory;
  }

  // Register an event factory at runtime
  static void registerEventFactory(
    String blocType,
    Function(String, Map<String, dynamic>) factory,
  ) {
    _eventFactories[blocType] = factory;
  }

  // Generic provider function that creates a provider for any BLoC type
  static Widget createGenericProvider(
    GenericBloc bloc,
    Widget child, {
    Map<String, dynamic>? initialEvent,
  }) {
    // Check if we need to fire an initial event
    if (initialEvent != null &&
        initialEvent.containsKey('type') &&
        initialEvent.containsKey('payload')) {
      // Extract event info
      final eventType = initialEvent['type'] as String;
      final payload = initialEvent['payload'] as Map<String, dynamic>? ?? {};

      // Create and add the event
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final event = createEvent(
          bloc.runtimeType.toString(),
          eventType,
          payload,
        );
        if (event != null) {
          bloc.add(event);
        }
      });
    }

    // This works for any BLoC type without needing specific registration
    return BlocProvider.value(
      value: bloc,
      child: child,
    );
  }

  // Generic builder function that works with any BLoC type
  static Widget buildGenericBuilder(
    BuildContext context,
    GenericBloc bloc, {
    required Widget child,
    bool Function(Object, Object)? buildWhen,
    Map<String, dynamic>? builderProperties,
  }) {
    return BlocBuilder(
      bloc: bloc,
      buildWhen: buildWhen,
      builder: (context, state) {
        // Process builderProperties if provided
        if (builderProperties != null) {
          // Create a BuildContext with state data that can be passed to child widgets
          final stateContext = _StateContext(context, state, builderProperties);

          // Check if we need to modify the widget based on state conditions
          if (builderProperties.containsKey('conditions')) {
            final conditions =
                builderProperties['conditions'] as List<dynamic>?;
            if (conditions != null) {
              for (final condition in conditions) {
                final whenExpr = condition['when'] as String?;
                final stateType = condition['stateType'] as String?;
                final thenWidget = condition['then'] as Map<String, dynamic>?;

                // Check if this condition applies to the current state type
                if (_matchStateType(state, stateType) &&
                    whenExpr != null &&
                    thenWidget != null) {
                  final conditionMet = _evaluateCondition(whenExpr, state);
                  if (conditionMet) {
                    // If condition is met, use the "then" widget
                    return Stac.fromJson(thenWidget, stateContext) ?? child;
                  }
                }
              }
            }
          }

          // Check if we need to replace placeholders in the child widget
          if (builderProperties.containsKey('bindVariables') &&
              builderProperties['bindVariables'] == true) {
            // Create a new child with state variables bound
            return _bindStateVariables(child, state);
          }

          // Use StateContext to pass state to child
          return _StateInheritedWidget(
            state: state,
            stateMapping:
                builderProperties['stateMapping'] as Map<String, String>?,
            child: child,
          );
        }

        // No special processing, just return the child
        return child;
      },
    );
  }

  // Generic consumer function that works with any BLoC type
  static Widget buildGenericConsumer(
    BuildContext context,
    GenericBloc bloc, {
    required Widget child,
    bool Function(Object, Object)? buildWhen,
    bool Function(Object, Object)? listenWhen,
    Map<String, dynamic>? builderProperties,
  }) {
    return BlocConsumer(
      bloc: bloc,
      buildWhen: buildWhen,
      listenWhen: listenWhen,
      builder: (context, state) {
        // Process builderProperties if provided
        if (builderProperties != null) {
          // Create a BuildContext with state data that can be passed to child widgets
          final stateContext = _StateContext(context, state, builderProperties);

          // Check if we need to modify the widget based on state conditions
          if (builderProperties.containsKey('conditions')) {
            final conditions =
                builderProperties['conditions'] as List<dynamic>?;
            if (conditions != null) {
              for (final condition in conditions) {
                final whenExpr = condition['when'] as String?;
                final stateType = condition['stateType'] as String?;
                final thenWidget = condition['then'] as Map<String, dynamic>?;

                // Check if this condition applies to the current state type
                if (_matchStateType(state, stateType) &&
                    whenExpr != null &&
                    thenWidget != null) {
                  final conditionMet = _evaluateCondition(whenExpr, state);
                  if (conditionMet) {
                    // If condition is met, use the "then" widget
                    return Stac.fromJson(thenWidget, stateContext) ?? child;
                  }
                }
              }
            }
          }

          // Check if we need to replace placeholders in the child widget
          if (builderProperties.containsKey('bindVariables') &&
              builderProperties['bindVariables'] == true) {
            // Create a new child with state variables bound
            return _bindStateVariables(child, state);
          }

          // Use StateContext to pass state to child
          return _StateInheritedWidget(
            state: state,
            stateMapping:
                builderProperties['stateMapping'] as Map<String, String>?,
            child: child,
          );
        }

        // No special processing, just return the child
        return child;
      },
      listener: (context, state) {
        // Handle listener logic based on builderProperties
        if (builderProperties != null &&
            builderProperties.containsKey('onStateChange')) {
          final actions = builderProperties['onStateChange'] as List<dynamic>?;
          if (actions != null) {
            // Check if any actions are restricted to specific state types
            for (final action in actions) {
              final stateType = action['stateType'] as String?;

              // Only process actions for matching state types (or ones without type restriction)
              if (stateType == null || _matchStateType(state, stateType)) {
                _processActions(context, [action], state);
              }
            }
          }
        }
      },
    );
  }

  // Generic listener function that works with any BLoC type
  static Widget buildGenericListener(
    BuildContext context,
    GenericBloc bloc, {
    required Widget child,
    bool Function(Object, Object)? listenWhen,
    Map<String, dynamic>? builderProperties,
  }) {
    return BlocListener(
      bloc: bloc,
      listenWhen: listenWhen,
      listener: (context, state) {
        // Handle listener logic based on the widget's builderProperties
        if (builderProperties != null &&
            builderProperties.containsKey('onStateChange')) {
          final actions = builderProperties['onStateChange'] as List<dynamic>?;
          if (actions != null) {
            // Check if any actions are restricted to specific state types
            for (final action in actions) {
              final stateType = action['stateType'] as String?;

              // Only process actions for matching state types (or ones without type restriction)
              if (stateType == null || _matchStateType(state, stateType)) {
                _processActions(context, [action], state);
              }
            }
          }
        }
      },
      child: child,
    );
  }

  // Check if a state matches a specific state type
  static bool _matchStateType(
    state,
    String? stateType,
  ) {
    if (stateType == null) return true;

    // Check if this is a specific state class
    final stateClassName = state.runtimeType.toString();
    return stateClassName == stateType;
  }

  // Process actions defined in JSON
  static void _processActions(
    BuildContext context,
    List<dynamic> actions,
    state,
  ) {
    for (final action in actions) {
      final actionType = action['type'] as String?;
      final target = action['target'] as String?;
      final value = action['value'];

      if (actionType == null || target == null) continue;

      switch (actionType) {
        case 'navigate':
          _handleNavigationAction(context, target, value);
          break;
        case 'showDialog':
          _handleDialogAction(context, target, value);
          break;
        case 'showSnackbar':
          _handleSnackbarAction(context, target, value);
          break;
        case 'dispatchEvent':
          _handleDispatchEventAction(context, target, value);
          break;
        // Add more action types as needed
      }
    }
  }

  // Handle navigation actions
  static void _handleNavigationAction(
    BuildContext context,
    String target,
    value,
  ) {
    switch (target) {
      case 'push':
        if (value is Map && value.containsKey('route')) {
          final route = value['route'] as String;
          final arguments = value['arguments'] as Map<String, dynamic>?;
          Navigator.of(context).pushNamed(route, arguments: arguments);
        }
        break;
      case 'pop':
        Navigator.of(context).pop();
        break;
      case 'replace':
        if (value is Map && value.containsKey('route')) {
          final route = value['route'] as String;
          final arguments = value['arguments'] as Map<String, dynamic>?;
          Navigator.of(context)
              .pushReplacementNamed(route, arguments: arguments);
        }
        break;
      // More navigation actions
    }
  }

  // Handle dialog actions
  static void _handleDialogAction(
    BuildContext context,
    String target,
    value,
  ) {
    // Show dialog based on the value
    if (target == 'show' && value is Map && value.containsKey('content')) {
      final content = value['content'] as Map<String, dynamic>?;
      if (content != null) {
        showDialog(
          context: context,
          builder: (dialogContext) {
            return Dialog(
              child: Stac.fromJson(content, dialogContext) ??
                  const SizedBox(height: 100, width: 100),
            );
          },
        );
      }
    }
  }

  // Handle snackbar actions
  static void _handleSnackbarAction(
    BuildContext context,
    String target,
    value,
  ) {
    final message = value is Map
        ? (value['message'] as String? ?? 'Action completed')
        : 'Action completed';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Handle dispatching events to other BLoCs
  static void _handleDispatchEventAction(
    BuildContext context,
    String target,
    value,
  ) {
    if (value is Map &&
        value.containsKey('eventType') &&
        value.containsKey('payload')) {
      final eventType = value['eventType'] as String;
      final payload = value['payload'] as Map<String, dynamic>? ?? {};

      try {
        // Target is the BLoC type
        final bloc = getBlocFromContext(context, target);
        if (bloc != null) {
          final event = createEvent(target, eventType, payload);
          if (event != null) {
            bloc.add(event);
          }
        }
      } catch (e) {
        debugPrint('Error dispatching event: $e');
      }
    }
  }

  // Create a BLoC from type and initialState - fully dynamic
  static dynamic createBloc(String type, Map<String, dynamic> initialState) {
    // Generate a unique ID for this BLoC type + initialState
    final blocId = '${type}_${initialState.hashCode}';

    // Return existing instance if available to prevent duplication
    if (_blocInstances.containsKey(blocId)) {
      return _blocInstances[blocId];
    }

    // Check if we have a registered factory for this BLoC type
    if (_blocFactories.containsKey(type)) {
      final factory = _blocFactories[type]!;
      final bloc = factory(initialState);

      // Store the instance for future use
      if (bloc != null) {
        _blocInstances[blocId] = bloc;
      }

      return bloc;
    }

    // If no factory is registered, create a generic BLoC
    final bloc = GenericBloc(initialState);

    // Store the instance for future use
    _blocInstances[blocId] = bloc;

    return bloc;
  }

  // Create an event from type and payload - fully dynamic
  static dynamic createEvent(
    String blocType,
    String eventType,
    Map<String, dynamic> payload,
  ) {
    // Check if we have a registered factory for this BLoC's events
    if (_eventFactories.containsKey(blocType)) {
      final factory = _eventFactories[blocType]!;
      return factory(eventType, payload);
    }

    // Create a generic event with type and payload
    return GenericBlocEvent(
      type: eventType,
      payload: payload,
    );
  }

  // Get a BLoC from context by type name
  static dynamic getBlocFromContext(BuildContext context, String blocType) {
    try {
      // Try to get the BLoC using the registered factories
      for (final entry in _blocFactories.entries) {
        if (entry.key == blocType) {
          // This is a registered BLoC type, try to get it from the context
          final value = BlocProvider.of(context, listen: false);
          if (value.runtimeType.toString().contains(blocType)) {
            return value;
          }
        }
      }

      // If not found, try to find a GenericBloc
      return BlocProvider.of<GenericBloc>(context, listen: false);
    } catch (e) {
      debugPrint('Error getting BLoC of type $blocType: $e');
      return null;
    }
  }

  // Helper method to evaluate conditions like "count > 5" or "isLoggedIn == true"
  static bool _evaluateCondition(
    String expression,
    state,
  ) {
    // Handle state objects that aren't Maps
    if (state is! Map<String, dynamic>) {
      // Try to access properties using reflection or runtime type checking

      // For LoadingRatingDetails, UploadingRatingDetails, etc.
      if (expression == 'isLoading' &&
          state.runtimeType.toString().contains('Loading')) {
        return true;
      }

      // For RatingDetailsLoaded
      if (state.runtimeType.toString().contains('Loaded')) {
        // Try to access properties that might exist on this state
        // Depending on what properties the state has
        if (expression.contains('viewMore')) {
          try {
            // Access using dynamic property access
            final viewMore = state.viewMore as bool?;
            if (expression == 'viewMore') return viewMore == true;
            if (expression == '!viewMore') return viewMore == false;
          } catch (e) {
            // Property doesn't exist or can't be accessed
            return false;
          }
        }

        // Check for userRatings related expressions
        if (expression.contains('userRatings')) {
          try {
            final userRatings = state.userRatings;
            if (expression == 'userRatings.isEmpty') {
              return userRatings == null || userRatings.isEmpty;
            }
            if (expression == 'userRatings.isNotEmpty') {
              return userRatings != null && userRatings.isNotEmpty;
            }

            // Handle expressions like userRatings.length > 5
            if (expression.contains('userRatings.length')) {
              final length = userRatings?.length ?? 0;

              if (expression.contains('>')) {
                final parts = expression.split('>');
                if (parts.length == 2) {
                  final rightValue = int.tryParse(parts[1].trim());
                  if (rightValue != null) {
                    return length > rightValue;
                  }
                }
              } else if (expression.contains('<')) {
                final parts = expression.split('<');
                if (parts.length == 2) {
                  final rightValue = int.tryParse(parts[1].trim());
                  if (rightValue != null) {
                    return length < rightValue;
                  }
                }
              }
            }
          } catch (e) {
            // Property doesn't exist or can't be accessed
            return false;
          }
        }
      }

      // Return based on state type for expressions that match state class names
      return expression == state.runtimeType.toString();
    }

    // Regular expression handling for Map states
    if (expression.contains('==')) {
      final parts = expression.split('==');
      if (parts.length == 2) {
        final leftPath = parts[0].trim().split('.');
        final leftValue = _getNestedStateValue(state, leftPath);

        final rightStr = parts[1].trim();
        final rightValue = _parseValue(rightStr);

        return leftValue == rightValue;
      }
    } else if (expression.contains('!=')) {
      final parts = expression.split('!=');
      if (parts.length == 2) {
        final leftPath = parts[0].trim().split('.');
        final leftValue = _getNestedStateValue(state, leftPath);

        final rightStr = parts[1].trim();
        final rightValue = _parseValue(rightStr);

        return leftValue != rightValue;
      }
    } else if (expression.contains('>')) {
      final parts = expression.split('>');
      if (parts.length == 2) {
        final leftPath = parts[0].trim().split('.');
        final leftValue = _getNestedStateValue(state, leftPath);

        final rightStr = parts[1].trim();
        final rightValue = _parseValue(rightStr);

        if (leftValue is num && rightValue is num) {
          return leftValue > rightValue;
        }
      }
    } else if (expression.contains('<')) {
      final parts = expression.split('<');
      if (parts.length == 2) {
        final leftPath = parts[0].trim().split('.');
        final leftValue = _getNestedStateValue(state, leftPath);

        final rightStr = parts[1].trim();
        final rightValue = _parseValue(rightStr);

        if (leftValue is num && rightValue is num) {
          return leftValue < rightValue;
        }
      }
    }

    // Check if a value exists and is truthy
    try {
      // Try direct access for a property on a class
      if (state is! Map) {
        try {
          final value = state[expression];
          if (value is bool) return value;
          return value != null;
        } catch (e) {
          // Not accessible as property
          return false;
        }
      }

      // For maps, use path access
      final path = expression.trim().split('.');
      final value = _getNestedStateValue(state, path);
      if (value is bool) {
        return value;
      } else {
        return value != null;
      }
    } catch (e) {
      // If all other attempts fail, just check state type
      return state.runtimeType.toString() == expression;
    }
  }

  // Helper method to get a nested value from state
  static dynamic _getNestedStateValue(
    state,
    List<String> path,
  ) {
    if (state is! Map) {
      // For non-Map objects, try to access properties directly
      if (path.isEmpty) return state;

      try {
        return state[path[0]];
      } catch (e) {
        return null;
      }
    }

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

  // Helper method to parse string values to the appropriate type
  static dynamic _parseValue(String value) {
    // Try to parse as number
    final number = num.tryParse(value);
    if (number != null) return number;

    // Try to parse as boolean
    if (value.toLowerCase() == 'true') return true;
    if (value.toLowerCase() == 'false') return false;

    // Remove quotes if present
    if (value.startsWith('"') && value.endsWith('"')) {
      return value.substring(1, value.length - 1);
    }
    if (value.startsWith("'") && value.endsWith("'")) {
      return value.substring(1, value.length - 1);
    }

    // Return as string
    return value;
  }

  // Bind state variables to text widgets recursively
  static Widget _bindStateVariables(
    Widget widget,
    state,
  ) {
    // Handle Text widgets
    if (widget is Text) {
      final text = widget.data ?? '';
      if (text.contains('{{') && text.contains('}}')) {
        // Replace variables in format {{variable.path}}
        final newText = _replaceVariables(text, state);
        return Text(
          newText,
          style: widget.style,
          textAlign: widget.textAlign,
          overflow: widget.overflow,
          maxLines: widget.maxLines,
          strutStyle: widget.strutStyle,
          textDirection: widget.textDirection,
          locale: widget.locale,
          softWrap: widget.softWrap,
          textScaler: widget.textScaler,
          semanticsLabel: widget.semanticsLabel,
          textWidthBasis: widget.textWidthBasis,
          textHeightBehavior: widget.textHeightBehavior,
          selectionColor: widget.selectionColor,
        );
      }
      return widget;
    }

    // Handle containers with children
    if (widget is Container && widget.child != null) {
      return Container(
        key: widget.key,
        alignment: widget.alignment,
        padding: widget.padding,
        color: widget.color,
        decoration: widget.decoration,
        foregroundDecoration: widget.foregroundDecoration,
        // width: widget.width,
        // height: widget.height,
        constraints: widget.constraints,
        margin: widget.margin,
        transform: widget.transform,
        transformAlignment: widget.transformAlignment,
        clipBehavior: widget.clipBehavior,
        child: _bindStateVariables(widget.child!, state),
      );
    }

    // Handle Column and Row with multiple children
    if (widget is Column) {
      return Column(
        key: widget.key,
        mainAxisAlignment: widget.mainAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        crossAxisAlignment: widget.crossAxisAlignment,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        textBaseline: widget.textBaseline,
        children: widget.children
            .map((child) => _bindStateVariables(child, state))
            .toList(),
      );
    }

    if (widget is Row) {
      return Row(
        key: widget.key,
        mainAxisAlignment: widget.mainAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        crossAxisAlignment: widget.crossAxisAlignment,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        textBaseline: widget.textBaseline,
        children: widget.children
            .map((child) => _bindStateVariables(child, state))
            .toList(),
      );
    }

    // Fall back to the original widget if we can't process it
    return widget;
  }

  // Replace variables in a string with state values
  static String _replaceVariables(String text, Map<String, dynamic> stateMap) {
    final regex = RegExp(r'\{\{([^}]+)\}\}');
    return text.replaceAllMapped(regex, (match) {
      final path = match.group(1)?.trim().split('.') ?? [];
      final value = _getNestedStateValue(stateMap, path);
      return value?.toString() ?? '';
    });
  }
}

// An InheritedWidget that makes state accessible to descendants
class _StateInheritedWidget extends InheritedWidget {
  final dynamic state;
  final Map<String, String>? stateMapping;

  const _StateInheritedWidget({
    required this.state,
    required Widget child,
    this.stateMapping,
  }) : super(child: child);

  @override
  bool updateShouldNotify(_StateInheritedWidget old) {
    return old.state != state;
  }

  // Helper method to get state from context
  static dynamic of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_StateInheritedWidget>()
        ?.state;
  }
}

// A custom BuildContext that provides access to state
class _StateContext implements BuildContext {
  final BuildContext _context;
  final dynamic _state;
  final Map<String, dynamic> _properties;

  _StateContext(this._context, this._state, this._properties);

  // Pass through most context methods to the original context
  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>({
    Object? aspect,
  }) {
    return _context.dependOnInheritedWidgetOfExactType<T>(aspect: aspect);
  }

  // Override necessary methods to provide state

  // Implementation of other BuildContext methods
  // This is just a sampling of the methods you'd need to implement
  @override
  bool get mounted => _context.mounted;

  @override
  T? findAncestorWidgetOfExactType<T extends Widget>() {
    return _context.findAncestorWidgetOfExactType<T>();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return _context.noSuchMethod(invocation);
  }
}

/// A generic BLoC that can be used for any type
/// No need to create specific BLoC classes for each type
class GenericBloc extends Bloc<GenericBlocEvent, Map<String, dynamic>> {
  GenericBloc(Map<String, dynamic> initialState) : super(initialState) {
    on<GenericBlocEvent>(_handleEvent);
  }

  // Handle events dynamically based on their type
  void _handleEvent(
    GenericBlocEvent event,
    Emitter<Map<String, dynamic>> emit,
  ) {
    final currentState = state;
    final eventType = event.type;
    final payload = event.payload;

    // Handle different event types
    switch (eventType) {
      case 'set':
        // Set a specific value in the state
        if (payload.containsKey('key') && payload.containsKey('value')) {
          final key = payload['key'] as String;
          final value = payload['value'];
          final newState = Map<String, dynamic>.from(currentState);
          newState[key] = value;
          emit(newState);
        }
        break;

      case 'remove':
        // Remove a key from the state
        if (payload.containsKey('key')) {
          final key = payload['key'] as String;
          final newState = Map<String, dynamic>.from(currentState);
          newState.remove(key);
          emit(newState);
        }
        break;

      case 'increment':
        // Increment a numeric value in the state
        if (payload.containsKey('key')) {
          final key = payload['key'] as String;
          final amount = payload['amount'] as num? ?? 1;
          if (currentState.containsKey(key) && currentState[key] is num) {
            final newState = Map<String, dynamic>.from(currentState);
            newState[key] = (currentState[key] as num) + amount;
            emit(newState);
          }
        }
        break;

      case 'decrement':
        // Decrement a numeric value in the state
        if (payload.containsKey('key')) {
          final key = payload['key'] as String;
          final amount = payload['amount'] as num? ?? 1;
          if (currentState.containsKey(key) && currentState[key] is num) {
            final newState = Map<String, dynamic>.from(currentState);
            newState[key] = (currentState[key] as num) - amount;
            emit(newState);
          }
        }
        break;

      case 'append':
        // Append to a list in the state
        if (payload.containsKey('key') && payload.containsKey('value')) {
          final key = payload['key'] as String;
          final value = payload['value'];
          if (currentState.containsKey(key) && currentState[key] is List) {
            final newState = Map<String, dynamic>.from(currentState);
            final list = List.from(currentState[key] as List);
            list.add(value);
            newState[key] = list;
            emit(newState);
          }
        }
        break;

      case 'replace':
        // Replace the entire state
        if (payload.containsKey('state') &&
            payload['state'] is Map<String, dynamic>) {
          emit(payload['state'] as Map<String, dynamic>);
        }
        break;

      case 'toggle':
        // Toggle a boolean value in the state
        if (payload.containsKey('key')) {
          final key = payload['key'] as String;
          if (currentState.containsKey(key) && currentState[key] is bool) {
            final newState = Map<String, dynamic>.from(currentState);
            newState[key] = !(currentState[key] as bool);
            emit(newState);
          }
        }
        break;

      case 'merge':
        // Merge new values into the state
        if (payload.containsKey('values') &&
            payload['values'] is Map<String, dynamic>) {
          final newValues = payload['values'] as Map<String, dynamic>;
          final newState = Map<String, dynamic>.from(currentState);
          newState.addAll(newValues);
          emit(newState);
        }
        break;

      // Add more event types as needed
    }
  }
}

/// A generic event class for the GenericBloc
class GenericBlocEvent {
  final String type;
  final Map<String, dynamic> payload;

  GenericBlocEvent({
    required this.type,
    required this.payload,
  });
}
