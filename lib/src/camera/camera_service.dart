import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class CameraService {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isProcessing = false;

  CameraController? get controller => _cameraController;

  Future<void> initialize() async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) return;

    final frontCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21, // Best for Android/MLKit
    );

    await _cameraController?.initialize();
  }

  void startImageStream(Function(CameraImage image) onImage) {
    _cameraController?.startImageStream((image) {
      if (_isProcessing) return;
      _isProcessing = true;
      onImage(image);
      _isProcessing = false;
    });
  }

  Future<void> stopImageStream() async {
    await _cameraController?.stopImageStream();
  }

  InputImage? getInputImage(CameraImage image) {
    final sensorOrientation = _cameraController!.description.sensorOrientation;
    final InputImageRotation? rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    if (rotation == null) return null;

    final InputImageFormat? format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null || (format != InputImageFormat.yuv420 && format != InputImageFormat.nv21)) return null;

    if (image.planes.length != 1 && format == InputImageFormat.nv21) return null;
    if (image.planes.length != 3 && format == InputImageFormat.yuv420) return null;

    return InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  void dispose() {
    _cameraController?.dispose();
  }
}
