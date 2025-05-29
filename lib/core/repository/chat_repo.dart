import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/chat/chat_history.dart';
import 'package:felloapp/core/model/chat/chat_models.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../util/custom_logger.dart';

class ChatRepository extends BaseRepo {
  final CustomLogger _logger = locator<CustomLogger>();
  final String _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://advisors.fello-dev.net/'
      : 'https://advisors.fello-prod.net/';

  static const _chat = 'chat';
  Future<ApiResponse<ChatSession>> getSession(String sessionId) async {
    try {
      final response = await APIService.instance.getData(
        '${ApiPath.chatSessionPath}/$sessionId',
        cBaseUrl: _baseUrl,
        apiName: '$_chat/getSession',
      );

      final responseData = response["data"];
      return ApiResponse<ChatSession>(
        model: ChatSession.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      _logger.e("getOrCreateSession => ${e.toString()}");
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<ChatSession>> getOrCreateSession(String advisorId) async {
    try {
      final response = await APIService.instance.postData(
        ApiPath.chatSessionPath,
        body: {
          "advisorId": advisorId,
        },
        cBaseUrl: _baseUrl,
        apiName: '$_chat/createSession',
      );

      final responseData = response["data"];
      return ApiResponse<ChatSession>(
        model: ChatSession.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      _logger.e("getOrCreateSession => ${e.toString()}");
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Stream<List<ChatHistory>> getUserChatHistoryStream() async* {
    CancelToken? cancelToken;
    try {
      final dio = Dio(
          // BaseOptions(
          //   baseUrl: _baseUrl,
          //   connectTimeout: const Duration(seconds: 30),
          //   receiveTimeout: const Duration(minutes: 10),
          //   sendTimeout: const Duration(seconds: 30),
          // ),
          );
      final isAdvisor = userService.baseUser!.isAdvisor ?? false;
      final advisorId = userService.baseUser!.advisorId ?? '';
      String path;
      if (isAdvisor) {
        path = 'chats/advisor-chats-stream/$advisorId';
      } else {
        path = 'chats/user-chats-stream';
      }
      final user = FirebaseAuth.instance.currentUser;
      final token = await user?.getIdToken();
      cancelToken = CancelToken();
      final options = Options(
        headers: {
          'Accept': 'text/event-stream',
          'Authorization': token ?? '',
          'Cache-Control': 'no-cache',
          'Connection': 'keep-alive',
        },
        responseType: ResponseType.stream,
      );

      _logger.i("Starting SSE connection to: $_baseUrl$path");
      final response = await dio.get<ResponseBody>(
        _baseUrl + path,
        options: options,
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200 && response.data != null) {
        _logger.i("SSE connection established successfully");

        final stream = response.data!.stream;
        String buffer = '';

        await for (final chunk
            in stream.transform(utf8.decoder.cast<Uint8List, String>())) {
          if (cancelToken.isCancelled == true) {
            _logger.i("SSE stream cancelled");
            break;
          }

          buffer += chunk;
          final lines = buffer.split('\n');
          buffer = lines.removeLast();

          for (final line in lines) {
            final trimmedLine = line.trim();

            if (trimmedLine.startsWith('data: ')) {
              final jsonData = trimmedLine.substring(6);

              if (jsonData.isEmpty || jsonData == '[DONE]') {
                continue;
              }

              try {
                final response = json.decode(jsonData);
                if (response['sessions'] != null &&
                    response['sessions'] is List) {
                  final List<ChatHistory> chatHistory =
                      (response['sessions'] as List)
                          .map((json) => ChatHistory.fromJson(json))
                          .toList();

                  if (chatHistory.isNotEmpty) {
                    yield chatHistory;
                  }
                }
              } catch (e) {
                _logger.w(
                  "Error parsing SSE data: $jsonData, Error: ${e.toString()}",
                );
              }
            } else if (trimmedLine.startsWith('event: ')) {
              final eventType = trimmedLine.substring(7);
              _logger.d("Received SSE event: $eventType");
            } else if (trimmedLine.startsWith('retry: ')) {
              final retryTime = trimmedLine.substring(7);
              _logger.d("Server suggested retry time: $retryTime ms");
            }
          }
        }

        _logger.i("SSE stream ended");
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to connect to SSE stream: ${response.statusCode}',
          response: response,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        _logger.i("SSE request was cancelled");
        return;
      }

      _logger.e("Dio error in getUserChatHistoryStream: ${e.message}");

      if (e.response?.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Access denied. Insufficient permissions.');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Connection error. Unable to reach server.');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      _logger.e("getUserChatHistoryStream => ${e.toString()}");
      throw Exception(
        'Error connecting to chat history stream: ${e.toString()}',
      );
    } finally {
      cancelToken?.cancel();
    }
  }

  Future<ApiResponse<List<ChatHistory>>> getUserChatHistory() async {
    try {
      final isAdvisor = userService.baseUser!.isAdvisor ?? false;
      final advisorId = userService.baseUser!.advisorId ?? '';

      if (isAdvisor) {
        final response = await APIService.instance.getData(
          '${ApiPath.chatHistoryPath}/$advisorId',
          cBaseUrl: _baseUrl,
          apiName: '$_chat/getUserHistory',
        );

        if (response['data'] != null && response['data'] is List) {
          final List<ChatHistory> messages = (response['data'] as List)
              .map((json) => ChatHistory.fromJson(json))
              .toList();

          return ApiResponse<List<ChatHistory>>(
            model: messages,
            code: 200,
          );
        }
        return const ApiResponse<List<ChatHistory>>(
          model: [],
          code: 200,
        );
      } else {
        final response = await APIService.instance.getData(
          ApiPath.chatHistoryPath,
          cBaseUrl: _baseUrl,
          apiName: '$_chat/getUserHistory',
        );

        if (response['data'] != null && response['data'] is List) {
          final List<ChatHistory> messages = (response['data'] as List)
              .map((json) => ChatHistory.fromJson(json))
              .toList();

          return ApiResponse<List<ChatHistory>>(
            model: messages,
            code: 200,
          );
        }
        return const ApiResponse<List<ChatHistory>>(
          model: [],
          code: 200,
        );
      }
    } catch (e) {
      _logger.e("getUserChatHistory => ${e.toString()}");
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
