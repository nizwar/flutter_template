import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart';
import 'package:mojang_nontr/core/utils/logger.dart';

import '../../../../core/utils/face_challenge.dart';
import '../../../../core/utils/face_detector_util.dart';
import '../../../../core/utils/utils.dart';

enum PresenceStep {
  idle(0),
  initial(1),
  scanning(2),
  analyzing(3),
  success(4),
  failed(4);

  final int stepProgress;
  const PresenceStep(this.stepProgress);
}

class PenugasanStartProvider extends ChangeNotifier {
  late CameraController cameraController;
  FaceDetectorUtil faceDetectorUtils = FaceDetectorUtil();
  final TextEditingController noteController = TextEditingController();

  bool _scannerReady = false;
  bool _onScanning = false;
  FaceChallenges? _currentChallenge;
  FaceChallenges? get currentChallenge => _currentChallenge;
  int _finishedChallenge = 0;

  PresenceStep _step = PresenceStep.idle;
  PresenceStep get step => _step;

  (Position, Placemark)? _location;

  (Position, Placemark)? get location => _location;

  int get progress {
    return step.stepProgress + (_finishedChallenge);
  }

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: false,
      enableContours: true,
      enableTracking: true,
      enableClassification: true,
      minFaceSize: .3,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  bool get scannerReady => _scannerReady;

  String? errorPrompt;

  String get prompt {
    if (step == PresenceStep.scanning) {
      return _currentChallenge!.instruction;
    } else {
      switch (step) {
        case PresenceStep.idle:
          return 'Tekan tombol untuk memulai pemindaian';
        case PresenceStep.initial:
          return 'Menginisialisasi...';
        case PresenceStep.success:
          return 'Pemindaian berhasil!';
        case PresenceStep.failed:
          return 'Pemindaian gagal, silakan coba lagi';
        case PresenceStep.analyzing:
          return 'Menganalisis gambar...';
        default:
          return '';
      }
    }
  }

  Future<void> initialize() async {
    _location = await getMyLocation().catchError((e) => null);
    await faceDetectorUtils.initialize();
    cameraController = await availableCameras().then((cameras) {
      if (cameras.isEmpty) throw ScannerException(code: -1, description: 'Tidak ada kamera yang tersedia');
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      return CameraController(
        frontCamera,
        ResolutionPreset.medium,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
        enableAudio: false,
      );
    });
    await cameraController.initialize();
    _scannerReady = true;
    notifyListeners();
  }

  void _setStep(PresenceStep step) {
    _failToIdle?.cancel();
    _step = step;
    HapticFeedback.vibrate();

    if (step == PresenceStep.failed) {
      _failToIdle = Timer(const Duration(seconds: 3), () {
        _step = PresenceStep.idle;
        _currentChallenge = null;
        errorPrompt = null;
        cameraController.resumePreview();
        notifyListeners();
      });
    }
    notifyListeners();
  }

  void _pauseCamera() async {
    await _stopStream();
    cameraController.pausePreview();
  }

  void reset() {
    _setStep(PresenceStep.idle);
    _currentChallenge = null;
    _finishedChallenge = 0;
    errorPrompt = null;
    _onScanning = false;
    cameraController.resumePreview();
    notifyListeners();
  }

  Future<ScannerResult> startScanning(BuildContext context, {Duration timeout = const Duration(seconds: 10)}) async {
    // File modelDummy;
    File target;
    try {
      final List<FaceChallenges> challenges = FaceChallenges.random(2);
      bool success = false;
      errorPrompt = null;
      _finishedChallenge = 0;
      _setStep(PresenceStep.initial);
      await cameraController.resumePreview();
      target = await _takePicture(context);

      if (kDebugMode) {
        return ScannerResult(target, 100);
      }
      _setStep(PresenceStep.scanning);

      for (var challenge in challenges) {
        final subscription = await _faceStream;
        _currentChallenge = challenge;
        notifyListeners();
        try {
          success = await challenge.validate(subscription.stream).timeout(timeout, onTimeout: () => false).then((value) {
            _finishedChallenge++;
            notifyListeners();
            subscription.close();
            return value;
          });
        } on TimeoutException {
          subscription.close();
          success = false;
        }
        if (!success) break;
      }
      _pauseCamera();
      _setStep(PresenceStep.analyzing);
      await Future.delayed(const Duration(milliseconds: 500));
      // target = await _takePicture();

      if (success) {
        // final score = await faceDetectorUtils.compareImage(modelDummy, target);
        _setStep(PresenceStep.success);
        return ScannerResult(target, 0.0);
      } else {
        _setStep(PresenceStep.failed);
      }
    } on ScannerException catch (e) {
      errorPrompt = e.description;
      _setStep(PresenceStep.failed);
      rethrow;
    }
    _pauseCamera();
    _onScanning = false;
    throw ScannerException(code: 5, description: errorPrompt ?? 'Terjadi kesalahan saat pemindaian. Silakan coba lagi.');
  }

  Future<StreamController<Face>> get _faceStream async {
    final controller = StreamController<Face>();
    Timer? timeoutTimer;

    void createTimeout() {
      timeoutTimer?.cancel();
      timeoutTimer = Timer(const Duration(seconds: 5), () {
        if (!controller.isClosed) {
          controller.addError(ScannerException(code: 3, description: 'Deteksi wajah timeout. Silakan coba lagi.'));
          controller.close();
        }
      });
    }

    createTimeout();

    await _stopStream();
    cameraController.startImageStream((CameraImage image) async {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) {
        clog("Failed to create input image from camera image");
        return;
      }
      if (_onScanning) {
        clog("On scanning, skip frame");
        return;
      }
      _onScanning = true;

      clog("Processing frame for face detection");
      final faces = await _faceDetector.processImage(inputImage);
      for (var face in faces) {
        clog("Smiling? ${face.smilingProbability}");
        if (controller.isClosed) return;
        createTimeout();
        controller.add(face);
      }

      _onScanning = false;
    });

    return controller;
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final orientations = {DeviceOrientation.portraitUp: 0, DeviceOrientation.landscapeLeft: 90, DeviceOrientation.portraitDown: 180, DeviceOrientation.landscapeRight: 270};
    final description = cameraController.description;
    final sensorOrientation = description.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = orientations[cameraController.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (description.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    if (rotation == null) return null;
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;
    Uint8List bytes;
    final plane = image.planes.first;
    if (format == InputImageFormat.yuv_420_888 && Platform.isAndroid) {
      bytes = faceDetectorUtils.convertYUV420ToNV21(image);
    } else {
      if (image.planes.length != 1) return null;
      bytes = plane.bytes; // for bgra8888 or nv21
    }

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  Future<void> _stopStream() async {
    if (cameraController.value.isStreamingImages) {
      return cameraController.stopImageStream().catchError((e) {});
    }
  }

  @override
  void dispose() {
    _stopStream().then((value) {
      cameraController.dispose();
    });
    _faceDetector.close();
    super.dispose();
  }

  Timer? _failToIdle;

  Future<File> _takePicture(BuildContext context) async {
    return await cameraController.takePicture().catchError((e) {
      var err = e as CameraException;
      throw ScannerException(code: 1, description: 'Gagal mengambil foto: ${err.description}');
    }).then((value) async {
      final decodedImage = await decodeImageFile(value.path);
      File jpg = File("${value.path}.jpg");
      await jpg.writeAsBytes(encodeJpg(decodedImage!, quality: 80));

      if (!kDebugMode) {
        await _faceDetector.processImage(InputImage.fromFile(jpg)).then((faces) {
          if (faces.isEmpty) {
            throw ScannerException(code: 2, description: 'Tidak ada wajah yang terdeteksi pada foto awal.');
          }
        });
      }

      ///Compress image and make it jpg
      final image = await decodeImageFile(value.path);
      if (image == null) {
        throw ScannerException(code: 4, description: 'Gagal mendecode gambar dari file.');
      }
      final output = File(value.path);
      await output.writeAsBytes(encodeJpg(image, quality: 80));
      return output;
    });
  }

  void stopScanner() {
    _stopStream();
    _onScanning = false;
    _setStep(PresenceStep.idle);
    _currentChallenge = null;
    _finishedChallenge = 0;
    errorPrompt = null;
    cameraController.pausePreview();
    notifyListeners();
  }
}

class ScannerResult {
  final File image;
  final double score;

  ScannerResult(this.image, this.score);
}

class ScannerException implements Exception {
  final int code;
  final String description;

  ScannerException({required this.code, required this.description});

  @override
  String toString() => description;
}
