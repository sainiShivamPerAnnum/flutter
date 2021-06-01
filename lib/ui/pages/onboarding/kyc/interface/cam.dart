import 'dart:io';
import 'package:camera/camera.dart';
import 'package:felloapp/core/ops/kyc_ops.dart';
import 'package:felloapp/ui/pages/onboarding/kyc/interface/kyc_onboard_data.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MyCam extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String randNum;
  MyCam({@required this.cameras, @required this.randNum});
  @override
  _MyCamState createState() => _MyCamState();
}

class _MyCamState extends State<MyCam> {
  CameraController controller;
  double _minAvailableZoom;
  double _maxAvailableZoom;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  bool enableAudio = true;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  XFile videoFile;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;

  KYCModel kycModel = KYCModel();

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    onNewCameraSelected(widget.cameras[1]);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff333333),
      appBar: AppBar(
        backgroundColor: Color(0xff333333),
        elevation: 0,
        centerTitle: true,
        title: Text("Video Verification"),
      ),
      body: Container(
          height: _height,
          width: _width,
          child: Stack(
            children: [
              Column(
                children: [
                  Center(
                    child: _cameraPreviewWidget(),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      width: _width,
                      color: Color(0xff333333),
                    ),
                  )
                ],
              ),
              Positioned(
                top: SizeConfig.screenHeight * 0.03,
                child: Container(
                  width: SizeConfig.screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(200),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Please say '${widget.randNum}' while recording video",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                child: Container(
                  width: SizeConfig.screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // CircleAvatar(
                      //   backgroundColor: Colors.black,
                      //   radius: _width * 0.05,
                      //   child: IconButton(
                      //     icon: controller != null &&
                      //             controller.value.isRecordingPaused
                      //         ? Icon(
                      //             Icons.play_arrow,
                      //             color: Colors.white,
                      //           )
                      //         : Icon(
                      //             Icons.pause,
                      //             color: Colors.white,
                      //           ),
                      //     onPressed: controller != null &&
                      //             controller.value.isInitialized &&
                      //             controller.value.isRecordingVideo
                      //         ? (controller != null &&
                      //                 controller.value.isRecordingPaused
                      //             ? onResumeButtonPressed
                      //             : onPauseButtonPressed)
                      //         : null,
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: 20,
                      // ),
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: _width * 0.08,
                        child: IconButton(
                          icon: Icon(
                            Icons.videocam,
                            size: _width * 0.06,
                          ),
                          color: Colors.amber,
                          onPressed: controller != null &&
                                  controller.value.isInitialized &&
                                  !controller.value.isRecordingVideo
                              ? onVideoRecordButtonPressed
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: _width * 0.05,
                        child: IconButton(
                          icon: const Icon(
                            Icons.stop,
                            color: Colors.red,
                          ),
                          onPressed: controller != null &&
                                  controller.value.isInitialized &&
                                  controller.value.isRecordingVideo
                              ? onStopButtonPressed
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(
          milliseconds: 2000,
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    return Listener(
      // onPointerDown: (_) => _pointers++,
      // onPointerUp: (_) => _pointers--,
      child: AspectRatio(
        aspectRatio: 4 / 6,
        child: CameraPreview(
          controller,
        ),
      ),
    );
    //}
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
      await Future.wait([
        controller
            .getMinExposureOffset()
            .then((value) => _minAvailableExposureOffset = value),
        controller
            .getMaxExposureOffset()
            .then((value) => _maxAvailableExposureOffset = value),
        controller.getMaxZoomLevel().then((value) => _maxAvailableZoom = value),
        controller.getMinZoomLevel().then((value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((file) {
      if (mounted) setState(() {});
      if (file != null) {
        showInSnackBar('Video recorded to ${file.path}');
        videoFile = file;
        //_startVideoPlayer();
        videoController = VideoPlayerController.file(File(videoFile.path))
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() async {
              await videoController.setLooping(true);
              await videoController.initialize();
              await videoController.play();
            });
          });

        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  backgroundColor: Color(0xff333333),
                  content: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: Container(
                        child: VideoPlayer(videoController),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text("Looks Good"),
                      onPressed: () async{
                        print(videoFile.path);

                       var result =  await kycModel.recordVideo(videoFile.path);

                       print(result);


                        Navigator.pop(context);
                        Navigator.of(context).pop(videoFile.path);
                      },
                    ),
                    TextButton(
                      child: Text("Retake"),
                      onPressed: () {
                        videoController.pause();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
            barrierDismissible: false);
      }
    });
  }

  Future<XFile> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      return controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await controller.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');
}
