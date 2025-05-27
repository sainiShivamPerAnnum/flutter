import 'package:felloapp/core/constants/apis_path_constants.dart';
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
      ? "https://dev-chat-api.fello.in"
      : "https://prod-chat-api.fello.in";

  static const _chat = 'chat';

  /// Create or get existing chat session with advisor
  Future<ApiResponse<ChatSession>> getOrCreateSession(String advisorId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return const ApiResponse.withError("User not authenticated", 401);
      }

      // Create session with advisorId in POST body
      final createResponse = await APIService.instance.postData(
        ApiPath.chatSessionPath,
        body: {
          "advisorId": advisorId,
          "userId": user.uid, // Include userId if needed by backend
        },
        cBaseUrl: _baseUrl,
        apiName: '$_chat/createSession',
      );

      if (createResponse['data'] != null) {
        return ApiResponse<ChatSession>(
          model: ChatSession.fromJson(createResponse['data']),
          code: createResponse['statusCode'] ?? 201,
        );
      }

      // If API response doesn't have data, check for success flag
      if (createResponse['success'] == true &&
          createResponse['session'] != null) {
        return ApiResponse<ChatSession>(
          model: ChatSession.fromJson(createResponse['session']),
          code: createResponse['statusCode'] ?? 201,
        );
      }

      // Return default session if API response is unexpected
      _logger.w("Unexpected API response, creating default session");
      return ApiResponse<ChatSession>(
        model: _createDefaultSession(advisorId),
        code: 200,
      );
    } catch (e) {
      _logger.e("getOrCreateSession => ${e.toString()}");

      // Return default session on error to ensure app doesn't break
      return ApiResponse<ChatSession>(
        model: _createDefaultSession(advisorId),
        code: 200,
      );
    }
  }

  /// Create default session for fallback scenarios
  ChatSession _createDefaultSession(String advisorId) {
    final user = FirebaseAuth.instance.currentUser;
    const sessionId = 'CSMB6DUOXS6QMHXX';

    return ChatSession(
      id: sessionId,
      messages: _getInitialMessages(sessionId, user?.uid ?? ''),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Get initial welcome messages
  List<ChatMessage> _getInitialMessages(String sessionId, String userId) {
    return [
      ChatMessage(
        id: 'welcome-${DateTime.now().millisecondsSinceEpoch}',
        messageType: MessageType.ai,
        sessionId: sessionId,
        senderId: 'ai',
        receiverId: userId,
        message:
            'Hello! I\'m here to assist you on behalf of Anil Singhvi. How can I help you today?',
        handler: 'ai',
        timestamp: DateTime.now().subtract(const Duration(seconds: 1)),
      ),
    ];
  }

  /// Get user chat history (for multi-user support)
  /// This method can be used as backup if socket-based history loading fails
  Future<ApiResponse<List<ChatMessage>>> getUserChatHistory(
    String userId,
  ) async {
    try {
      final response = await APIService.instance.getData(
        ApiPath
            .chatHistoryPath, // You'll need to add this to your ApiPath constants
        queryParams: {"userId": userId},
        cBaseUrl: _baseUrl,
        apiName: '$_chat/getUserHistory',
      );

      if (response['data'] != null && response['data'] is List) {
        final List<ChatMessage> messages = (response['data'] as List)
            .map((json) => ChatMessage.fromJson(json))
            .toList();

        return ApiResponse<List<ChatMessage>>(
          model: messages,
          code: 200,
        );
      }

      return const ApiResponse<List<ChatMessage>>(
        model: [],
        code: 200,
      );
    } catch (e) {
      _logger.e("getUserChatHistory => ${e.toString()}");
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
