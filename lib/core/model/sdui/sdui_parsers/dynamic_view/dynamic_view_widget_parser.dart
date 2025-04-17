import 'dart:convert';

import 'package:felloapp/core/model/sdui/sdui_parsers/dynamic_view/dynamic_view_widget.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/stac/lib/src/framework/stac.dart';
import 'package:felloapp/util/stac_framework/lib/src/stac_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class DynamicViewState {}

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
  DynamicViewBloc() : super(DynamicViewLoading()) {
    on<FetchDynamicView>(_onFetchDynamicView);
  }

  Future<void> _onFetchDynamicView(
    FetchDynamicView event,
    Emitter<DynamicViewState> emit,
  ) async {
    emit(DynamicViewLoading());

    try {
      final response = await APIService.instance.callApiForEndpoint(
        event.model.request.url,
        method: event.model.request.method.name,
        body: event.model.request.body,
        headers: event.model.request.headers,
        cBaseUrl: event.model.request.cBaseUrl,
        queryParameters: event.model.request.queryParameters,
      );
      final apiResponse = ApiResponse<Map<String, dynamic>>(
        model: response,
        code: response['statusCode'],
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
      emit(DynamicViewError(e.toString()));
    }
  }

  dynamic _extractNestedData(data, List<String> keys) {
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
    data,
  ) {
    Map<String, dynamic> result = {};

    if (data is List) {
      if (template.containsKey('ItemTemplate')) {
        final itemTemplate = template['ItemTemplate'] as Map<String, dynamic>;

        final items = <Map<String, dynamic>>[];
        for (int index = 0; index < data.length; index++) {
          final item = data[index];
          if (item is Map) {
            final processedItem = _applyDataToItem(itemTemplate, item, index);
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
      result = _applyDataToItem(template, data, -1);
    } else {
      result = template;
    }

    return result;
  }

  Map<String, dynamic> _applyDataToItem(
    Map<String, dynamic> template,
    Map<dynamic, dynamic> item, [
    int index = -1,
  ]) {
    final result = jsonDecode(jsonEncode(template)) as Map<String, dynamic>;

    _processTemplateRecursively(result, item, index);

    return result;
  }

  dynamic _processTemplateRecursively(
    template,
    Map<dynamic, dynamic> data, [
    int index = -1,
  ]) {
    if (template is Map) {
      for (final key in template.keys.toList()) {
        final value = template[key];

        if (value is String) {
          if (value.contains('{{') && value.contains('}}')) {
            // Process multiple placeholders in a single string
            String processedValue = value;
            // Handle {{index}} placeholder first
            if (index >= 0 && processedValue.contains('{{index}}')) {
              processedValue = processedValue.replaceAll(
                '{{index}}',
                (index + 1).toString(),
              );
            }

            final regex = RegExp(r'\{\{([^}]+)\}\}');
            final matches = regex.allMatches(value);

            for (final match in matches) {
              final placeholder = match.group(0)!;
              final dataKey = match.group(1)!.trim();
              if (dataKey == 'index') continue;
              final keys = dataKey.split('.');

              final dataValue = _extractNestedData(data, keys);
              if (dataValue != null) {
                processedValue = processedValue.replaceAll(
                  placeholder,
                  dataValue.toString(),
                );
              }
            }

            template[key] = processedValue;
          }
        } else if (value is Map || value is List) {
          _processTemplateRecursively(value, data, index);
        }
      }
    } else if (template is List) {
      for (int i = 0; i < template.length; i++) {
        _processTemplateRecursively(template[i], data, index);
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
    required this.code,
    this.model,
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
        switch (state) {
          case DynamicViewLoading():
            return loadingBuilder != null
                ? loadingBuilder!(context)
                : const Center(child: FullScreenLoader());
          case DynamicViewLoaded():
            return Stac.fromJson(state.renderedTemplate, context) ??
                const SizedBox.shrink();
          case DynamicViewError():
            return errorBuilder != null
                ? errorBuilder!(context, state.error)
                : const Center(child: NewErrorPage());
        }
      },
    );
  }
}
