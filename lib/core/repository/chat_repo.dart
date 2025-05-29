import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/chat/chat_history.dart';
import 'package:felloapp/core/model/chat/chat_models.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';

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
