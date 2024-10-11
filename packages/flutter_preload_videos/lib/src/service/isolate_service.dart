import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preload_videos/flutter_preload_videos.dart';

class IsolateService {
  static Future<void> createIsolate(
    int index,
    Bloc<PreloadEvent, PreloadState> preloadBloc,
  ) async {
    // Set loading to true
    preloadBloc.add(const PreloadEvent.setLoading());

    ReceivePort mainReceivePort = ReceivePort();

    // Spawn isolate
    await Isolate.spawn<SendPort>(_getVideosTask, mainReceivePort.sendPort);

    SendPort isolateSendPort = await mainReceivePort.first as SendPort;

    ReceivePort isolateResponseReceivePort = ReceivePort();

    isolateSendPort.send([index, isolateResponseReceivePort.sendPort]);

    final isolateResponse = await isolateResponseReceivePort.first;

    final List<VideoData> videos = isolateResponse as List<VideoData>;

    // Update new URLs in the main BLoC
    preloadBloc.add(PreloadEvent.updateUrls(videos));
  }

  static void _getVideosTask(SendPort mySendPort) async {
    ReceivePort isolateReceivePort = ReceivePort();

    // Send back the send port to the main isolate
    mySendPort.send(isolateReceivePort.sendPort);

    await for (var message in isolateReceivePort) {
      if (message is List) {
        final int index = message[0] as int;
        final SendPort isolateResponseSendPort = message[1] as SendPort;

        // Fetch videos using the API service and constants
        final List<VideoData> urls = await ApiService.getVideos(
            id: index + VideoPreloadConstants.preloadLimit);

        // Send the result back to the main isolate
        isolateResponseSendPort.send(urls);
      }
    }
  }
}
