import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import '../../main.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: CameraPreview(
        controller,
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.play_arrow_outlined),
                onPressed: () {
                  // controller.;
                  _startVideoRecording();
                }),
            IconButton(
                icon: Icon(Icons.stop),
                onPressed: () {
                  // controller.stopVideoRecording();
                  _stopVideoRecording();
                }),
          ],
        ),
      ),
    );
  }

  Future<String> _startVideoRecording() async {
    if (!controller.value.isInitialized) {
      return null;
    }

    // Do nothing if a recording is on progress
    if (controller.value.isRecordingVideo) {
      return null;
    }

    // final Directory appDirectory = await getApplicationDocumentsDirectory();
    // final String videoDirectory = '${appDirectory.path}/Videos';
    // await Directory(videoDirectory).create(recursive: true);
    // final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    // final String filePath = '$videoDirectory/${currentTime}.mp4';

    try {
      await controller.startVideoRecording();
      // videoPath = filePath;
    } on CameraException catch (e) {
      String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
      print(errorText);
    }

    // return filePath;
  }

  Future<String> _stopVideoRecording() async {
    if (!controller.value.isInitialized) {
      return null;
    }

    // Do nothing if a recording is on progress
    if (controller.value.isRecordingVideo) {
      return null;
    }

    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$videoDirectory/$currentTime.mp4';

    try {
      XFile file = await controller.stopVideoRecording();
      file.readAsBytes();
      // videoPath = filePath;
    } on CameraException catch (e) {
      String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
      print(errorText);
    }

    // return filePath;
  }
}
