import '../detection/face_detector.dart';
import '../ml/tflite_service.dart';
import '../ml/embedding_generator.dart';
import '../camera/camera_service.dart';

class FlutterFaceLivenessCore {
  final FaceDetectorService faceDetector = FaceDetectorService();
  final TFLiteService tfliteService = TFLiteService();
  late final EmbeddingGenerator embeddingGenerator;
  final CameraService cameraService = CameraService();

  FlutterFaceLivenessCore() {
    embeddingGenerator = EmbeddingGenerator(tfliteService);
  }

  Future<void> initialize() async {
    await cameraService.initialize();
    // await tfliteService.loadModel('assets/models/mobile_facenet.tflite');
  }

  void dispose() {
    faceDetector.stop();
    tfliteService.dispose();
    cameraService.dispose();
  }
}
