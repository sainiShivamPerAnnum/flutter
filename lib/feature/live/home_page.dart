import 'dart:io';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveHomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LiveHomePage());
  }

  const LiveHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final meetingTextController = TextEditingController(
      text: "https://yogi-livestreamingkit.app.100ms.live/meeting/xuq-zjx-ovh",
    );
    final nameTextController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/icons/hms_icon_1024.png"),
          title: const Text("100ms and Bloc Demo App"),
          actions: [
            Image.asset("assets/icons/bloc_logo.png"),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300.0,
                child: TextField(
                  controller: meetingTextController,
                  autofocus: true,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: 'Enter Room URL',
                    suffixIcon: IconButton(
                      onPressed: meetingTextController.clear,
                      icon: const Icon(Icons.clear),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                width: 300.0,
                child: TextField(
                  controller: nameTextController,
                  autofocus: true,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: 'Enter Name',
                    suffixIcon: IconButton(
                      onPressed: nameTextController.clear,
                      icon: const Icon(Icons.clear),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                width: 300.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (meetingTextController.text.isNotEmpty &&
                        nameTextController.text.isNotEmpty) {
                      bool res = await getPermissions();
                      if (res) {
                        AppState.delegate!.appState.currentAction = PageAction(
                          page: LivePreviewPageConfig,
                          state: PageState.addWidget,
                          widget: //add heere
                              HMSPrebuilt(
                            roomCode: meetingTextController.text,
                            options: HMSPrebuiltOptions(
                              userName: nameTextController.text,
                            ),
                          ),
                        );
                        // Room(meetingTextController.text,
                        //     nameTextController.text, true, true, false));
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.video_call_outlined, size: 48),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Join Meeting',
                          style: TextStyle(height: 1, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> getPermissions() async {
    if (Platform.isIOS) return true;
    await Permission.bluetoothConnect.request();
    await Permission.microphone.request();
    await Permission.camera.request();

    while (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }

    while (await Permission.microphone.isDenied) {
      await Permission.microphone.request();
    }

    while (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }
    return true;
  }
}
