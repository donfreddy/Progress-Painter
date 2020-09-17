import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  dynamic _scanResults;
  CameraController _camera;

  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.front;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<CameraDescription> _getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  void _initializeCamera() async {
    _camera = CameraController(
      await _getCamera(_direction),
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.low
          : ResolutionPreset.medium,
    );
    await _camera.initialize();
    _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;
      _isDetecting = true;
      try {
        // await doSomethingWith(image)
        print(image.);
      } catch (e) {
        // await handleExepction(e)
      } finally {
        _isDetecting = false;
      }
    });
  }



  Widget build(BuildContext context) {
    if (!_camera.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
      aspectRatio: _camera.value.aspectRatio,
      child: CameraPreview(_camera),
    );
  }
}

// https://medium.com/@hugand/capture-photos-from-camera-using-image-stream-with-flutter-e9af94bc2bee
// https://blog.usejournal.com/real-time-object-detection-in-flutter-b31c7ff9ef96
// https://github.com/shaqian/flutter_realtime_detection/tree/master/lib