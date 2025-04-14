import 'dart:convert';

import 'package:felloapp/core/model/sdui/sdui_parsers/dynamic_view/dynamic_view_widget.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stac/src/utils/log.dart';
import 'package:stac/stac.dart';

abstract class DynamicViewState {}

class DynamicViewInitial extends DynamicViewState {}

class DynamicViewLoading extends DynamicViewState {}

class DynamicViewLoaded extends DynamicViewState {
  final Map<String, dynamic> renderedTemplate;

  DynamicViewLoaded(this.renderedTemplate);
}

class DynamicViewError extends DynamicViewState {
  final String error;

  DynamicViewError(this.error);
}

abstract class DynamicViewEvent {}

class FetchDynamicView extends DynamicViewEvent {
  final DynamicViewWidget model;
  final BuildContext context;

  FetchDynamicView(this.model, this.context);
}

class DynamicViewBloc extends Bloc<DynamicViewEvent, DynamicViewState> {
  DynamicViewBloc() : super(DynamicViewInitial()) {
    on<FetchDynamicView>(_onFetchDynamicView);
  }

  Future<void> _onFetchDynamicView(
    FetchDynamicView event,
    Emitter<DynamicViewState> emit,
  ) async {
    emit(DynamicViewLoading());

    try {
      final apiResponse = await await APIService.instance.callApiForEndpoint(
        event.model.request.url,
        method: event.model.request.method.name,
        body: event.model.request.body,
        headers: event.model.request.headers as Map<String, String>,
        queryParameters: event.model.request.queryParameters,
      );
      if (apiResponse.code == 200 && apiResponse.model != null) {
        dynamic responseData = apiResponse.model;

        final data = event.model.targetPath.isEmpty
            ? responseData
            : _extractNestedData(
                responseData,
                event.model.targetPath.split('.'),
              );

        if (data != null) {
          final renderedTemplate = _applyDataToTemplate(
            event.model.template,
            data,
          );

          emit(DynamicViewLoaded(renderedTemplate));
        } else {
          emit(DynamicViewError('Data not found at specified path'));
        }
      } else {
        emit(DynamicViewError(apiResponse.error ?? 'Unknown error'));
      }
    } catch (e) {
      Log.e('Error fetching dynamic content: $e');
      emit(DynamicViewError(e.toString()));
    }
  }

  dynamic _extractNestedData(dynamic data, List<String> keys) {
    dynamic current = data;
    for (final key in keys) {
      if (current is Map && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }
    return current;
  }

  Map<String, dynamic> _applyDataToTemplate(
    Map<String, dynamic> template,
    dynamic data,
  ) {
    Map<String, dynamic> result = {};

    if (data is List) {
      if (template.containsKey('ItemTemplate')) {
        final itemTemplate = template['ItemTemplate'] as Map<String, dynamic>;

        final items = <Map<String, dynamic>>[];
        for (final item in data) {
          if (item is Map) {
            final processedItem = _applyDataToItem(itemTemplate, item);
            items.add(processedItem);
          }
        }

        result = Map<String, dynamic>.from(template);
        result.remove('ItemTemplate');

        if (!result.containsKey('children')) {
          result['children'] = [];
        }

        if (result['children'] is List) {
          (result['children'] as List).addAll(items);
        } else {
          result['children'] = items;
        }
      } else {
        result = template;
      }
    } else if (data is Map) {
      result = _applyDataToItem(template, data);
    } else {
      result = template;
    }

    return result;
  }

  Map<String, dynamic> _applyDataToItem(
    Map<String, dynamic> template,
    Map<dynamic, dynamic> item,
  ) {
    final result = jsonDecode(jsonEncode(template)) as Map<String, dynamic>;

    _processTemplateRecursively(result, item);

    return result;
  }

  dynamic _processTemplateRecursively(
    dynamic template,
    Map<dynamic, dynamic> data,
  ) {
    if (template is Map) {
      for (final key in template.keys.toList()) {
        final value = template[key];

        if (value is String) {
          if (value.contains('{{') && value.contains('}}')) {
            // Process multiple placeholders in a single string
            String processedValue = value;
            final regex = RegExp(r'\{\{([^}]+)\}\}');
            final matches = regex.allMatches(value);

            for (final match in matches) {
              final placeholder = match.group(0)!;
              final dataKey = match.group(1)!.trim();
              final keys = dataKey.split('.');

              final dataValue = _extractNestedData(data, keys);
              if (dataValue != null) {
                processedValue = processedValue.replaceAll(
                    placeholder, dataValue.toString());
              }
            }

            template[key] = processedValue;
          }
        } else if (value is Map || value is List) {
          _processTemplateRecursively(value, data);
        }
      }
    } else if (template is List) {
      for (int i = 0; i < template.length; i++) {
        _processTemplateRecursively(template[i], data);
      }
    }
    return template;
  }
}

class ApiResponse<T> {
  final T? model;
  final int code;
  final String? error;

  ApiResponse({
    this.model,
    required this.code,
    this.error,
  });

  factory ApiResponse.withError(String errorMsg, int code) {
    return ApiResponse(
      code: code,
      error: errorMsg,
    );
  }
}

class CustomDynamicViewParser extends StacParser<DynamicViewWidget> {
  final Widget Function(BuildContext)? loadingBuilder;
  final Widget Function(BuildContext, String)? errorBuilder;

  const CustomDynamicViewParser({
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  String get type => 'dynamicView';

  @override
  DynamicViewWidget getModel(Map<String, dynamic> json) {
    return DynamicViewWidget.fromJson(json);
  }

  @override
  Widget parse(BuildContext context, DynamicViewWidget model) {
    final bloc = DynamicViewBloc();

    bloc.add(FetchDynamicView(model, context));

    return BlocBuilder<DynamicViewBloc, DynamicViewState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is DynamicViewLoading) {
          return loadingBuilder != null
              ? loadingBuilder!(context)
              : const Center(child: CircularProgressIndicator());
        } else if (state is DynamicViewLoaded) {
          return Stac.fromJson(state.renderedTemplate, context) ??
              const SizedBox();
        } else if (state is DynamicViewError) {
          return errorBuilder != null
              ? errorBuilder!(context, state.error)
              : Center(child: Text('Error: ${state.error}'));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
