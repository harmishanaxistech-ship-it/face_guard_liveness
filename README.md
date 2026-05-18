# Face Guard Liveness SDK

A production-ready Flutter package for real-time AI-powered face liveness detection and face verification.

## Features

✅ **Real-time face detection** using Google ML Kit.
✅ **Guided Liveness Actions**: Blink, Smile, Turn Head, Look Up/Down.
✅ **Face Verification**: On-device face embedding comparison.
✅ **Anti-Spoofing**: Basic texture and motion analysis to prevent replay attacks.
✅ **Fully On-Device**: No data leaves the device.
✅ **Clean Architecture**: Easy to extend and maintain.

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  face_guard_liveness: ^1.0.0
```

### Android Setup

1. Change the minimum Android sdk version to 21 (or higher) in your `android/app/build.gradle` file.
2. Add camera permission to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

### iOS Setup

1. Add camera permission to `Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access for face liveness detection.</string>
```

## Usage

### Initialize

```dart
await FaceGuardLiveness.initialize();
```

### Start Liveness Check

```dart
final result = await FaceGuardLiveness.startLivenessCheck(
  context,
  actions: [
    LivenessAction.blink,
    LivenessAction.smile,
    LivenessAction.turnLeft,
  ],
);

if (result != null && result.isLive) {
  print("Liveness check passed!");
}
```

### Face Verification

```dart
final result = FaceVerifier.verify(embedding1, embedding2);
if (result.matched) {
  print("Faces matched with similarity: ${result.similarity}");
}
```

## TensorFlow Lite Models

This package requires TFLite models for face embeddings. You should place your `.tflite` models in the `assets/models/` directory and list them in your `pubspec.yaml`.

Example:
```yaml
flutter:
  assets:
    - assets/models/mobile_facenet.tflite
```

## Security & Privacy

- All processing is done offline.
- No images are uploaded to any server.
- Biometric data is processed in memory and not persisted unless explicitly saved by the developer.

## License

MIT
