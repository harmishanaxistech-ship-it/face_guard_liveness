import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../core/liveness_engine.dart';
import '../camera/camera_service.dart';
import '../detection/face_detector.dart';
import '../enums/liveness_action.dart';
import '../models/liveness_result.dart';
import 'face_overlay.dart';
import 'instruction_widget.dart';

/// A widget that provides a camera preview and guides the user through liveness actions.
class LivenessCameraView extends StatefulWidget {
  /// The list of actions the user must perform.
  final List<LivenessAction> actions;

  /// Callback when the liveness check is completed (success or failure).
  final Function(LivenessResult) onCompleted;

  /// Creates a [LivenessCameraView].
  const LivenessCameraView({
    super.key,
    required this.actions,
    required this.onCompleted,
  });

  @override
  State<LivenessCameraView> createState() => _LivenessCameraViewState();
}

class _LivenessCameraViewState extends State<LivenessCameraView> {
  final CameraService _cameraService = CameraService();
  final FaceDetectorService _faceDetectorService = FaceDetectorService();
  late LivenessEngine _livenessEngine;
  
  Face? _detectedFace;
  bool _isProcessing = false;
  Size? _imageSize;
  InputImageRotation? _rotation;

  @override
  void initState() {
    super.initState();
    _livenessEngine = LivenessEngine(requiredActions: widget.actions);
    _initialize();
  }

  Future<void> _initialize() async {
    await _cameraService.initialize();
    if (mounted) {
      setState(() {});
      _livenessEngine.start((reason) {
        widget.onCompleted(_livenessEngine.getResult());
      });
      _startStreaming();
    }
  }

  void _startStreaming() {
    _cameraService.startImageStream((image) async {
      if (_isProcessing) return;
      _isProcessing = true;

      final inputImage = _cameraService.getInputImage(image);
      if (inputImage != null) {
        _imageSize = inputImage.metadata?.size;
        _rotation = inputImage.metadata?.rotation;
        
        final faces = await _faceDetectorService.detectFaces(inputImage);
        if (mounted) {
          setState(() {
            if (faces.isNotEmpty) {
              _detectedFace = faces.first;
              final isDone = _livenessEngine.processFace(_detectedFace!);
              if (isDone) {
                _stopAndFinish();
              }
            } else {
              _detectedFace = null;
            }
          });
        }
      }
      _isProcessing = false;
    });
  }

  void _stopAndFinish() async {
    await _cameraService.stopImageStream();
    widget.onCompleted(_livenessEngine.getResult());
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _faceDetectorService.stop();
    _livenessEngine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraService.controller == null || !_cameraService.controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_cameraService.controller!),
          if (_imageSize != null && _rotation != null)
            CustomPaint(
              painter: FaceOverlayPainter(
                face: _detectedFace,
                imageSize: _imageSize!,
                rotation: _rotation!,
              ),
            ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: InstructionWidget(action: _livenessEngine.currentAction),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: _buildProgress(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return LinearProgressIndicator(
      value: _livenessEngine.progress,
      backgroundColor: Colors.white24,
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
    );
  }
}
