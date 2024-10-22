// import 'dart:isolate';
// import 'package:felloapp/util/flavor_config.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/services.dart'; // For RootIsolateToken
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../flutter_preload_videos.dart';
// import 'comment_data.dart';
// import 'video_data.dart';

// enum TaskType { commentsFetch, videoFetch }

// class IsolateService {
//   static Isolate? _isolate; // Long-living isolate
//   static SendPort? _isolateSendPort; // SendPort for communicating with the isolate
//   static ReceivePort? _mainReceivePort; // ReceivePort for the main isolate

//   // Create the long-living isolate if it doesn't exist
//   static Future<void> createIsolate({
//     required TaskType taskType,
//     required Bloc<PreloadEvent, PreloadState> preloadBloc,
//     int? index,
//     String? videoId,
//   }) async {
//     // Create the isolate only if it doesn't already exist
//     RootIsolateToken? rootIsolateToken = RootIsolateToken.instance;
//     if (_isolate == null) {
//       _mainReceivePort = ReceivePort();

//       // Spawn the isolate and pass the rootIsolateToken
//       _isolate = await Isolate.spawn(
//         _isolateEntry,
//         [_mainReceivePort!.sendPort, rootIsolateToken], // Send both the SendPort and RootIsolateToken
//         debugName: 'LongLivingVideoIsolate',
//       );

//       // Wait for the SendPort from the isolate
//       _isolateSendPort = await _mainReceivePort!.first as SendPort;
//     }

//     // Send tasks to the isolate using the SendPort
//     ReceivePort isolateResponseReceivePort = ReceivePort();

//     _isolateSendPort!.send([
//       taskType,
//       index,
//       videoId,
//       isolateResponseReceivePort.sendPort,
//     ]);

//     // Listen for the response from the isolate
//     final isolateResponse = await isolateResponseReceivePort.first;

//     // Handle the isolate's response
//     if (taskType == TaskType.videoFetch) {
      
//     }
//     if (taskType == TaskType.commentsFetch) {
//       final List<CommentData> comments = isolateResponse as List<CommentData>;
//       preloadBloc.add(
//         PreloadEvent.addCommentToState(videoId: videoId!, comment: comments),
//       );
//     }
//   }

//   // The entry function for the isolate
//   static Future<void> _isolateEntry(List<dynamic> args) async {
//     SendPort mainSendPort = args[0] as SendPort;
//     RootIsolateToken rootIsolateToken = args[1] as RootIsolateToken;

//     ReceivePort isolateReceivePort = ReceivePort();

//     // Send the isolate's SendPort back to the main isolate
//     mainSendPort.send(isolateReceivePort.sendPort);

//     // Ensure platform channels are initialized in the isolate
//     BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

//     try {
//       FlavorConfig.configureDev();
//       await Firebase.initializeApp(); // Initialize Firebase here
//       print('Firebase initialized in the isolate');
//     } catch (e) {
//       print('Failed to initialize Firebase: $e');
//     }

//     await for (final message in isolateReceivePort) {
//       if (message is List) {
//         final TaskType taskType = message[0] as TaskType;
//         final int? index = message[1] as int?;
//         final String? videoId = message[2] as String?;
//         final SendPort isolateResponseSendPort = message[3] as SendPort;

//         if (taskType == TaskType.videoFetch) {
//           // Fetch videos using the API service and constants
//           final data = await ShortsRepo.getVideos(
//             page: index! + VideoPreloadConstants.preloadLimit,
//           );
         

//           // Send the result back to the main isolate
//           isolateResponseSendPort.send(urls);
//         }

//         if (taskType == TaskType.commentsFetch) {
//           final data = await ShortsRepo.getComments(videoId!);
//           final List<CommentData> comments = data.model ?? [];
//           isolateResponseSendPort.send(comments);
//         }
//       }
//     }
//   }

//   // Terminate the isolate when done
//   static void killIsolate() {
//     _isolate?.kill(priority: Isolate.immediate);
//     _isolate = null;
//     _isolateSendPort = null;
//     _mainReceivePort?.close();
//     _mainReceivePort = null;
//   }
// }
