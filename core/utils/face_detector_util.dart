import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';

import 'logger.dart';
import 'utils.dart';

class FaceDetectorUtil {
  // Interpreter? faceRecognition;
  // Interpreter? faceSpoofing;

  bool breath = false;

  FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: false,
      enableContours: true,
      enableTracking: true,
      enableClassification: true,
      minFaceSize: .3,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  bool isInitialized = false;

  Future initialize() async {
    if (isInitialized) return;
    // faceRecognition = await Interpreter.fromAsset("assets/model/face_model.tflite");
    isInitialized = true;
  }

  bool _scanning = false;
  Future<void> faceScanner(
    CameraController controller,
    CameraImage cameraImage, {
    Function(Face face, img.Image image)? onFaceFounded,
    Function()? noFaceFounded,
  }) async {
    if (_scanning) return;
    _scanning = true;
    var visionImage = _inputImageFromCameraImage(controller, cameraImage);
    if (visionImage == null) {
      _scanning = false;
      return;
    }
    try {
      var faces = await faceDetector.processImage(visionImage);
      if (faces.isNotEmpty) {
        var face = faces.first;
        var image = await _convertCameraImage(cameraImage, controller.description.lensDirection);
        image = img.copyCrop(image!, x: face.boundingBox.left.toInt(), y: face.boundingBox.top.toInt(), height: face.boundingBox.height.toInt(), width: face.boundingBox.width.toInt());
        image = img.copyResize(image, width: 112, height: 112);
        image = img.copyResizeCropSquare(image, size: 112);

        _scanning = false;
        return onFaceFounded?.call(faces.first, image);
      }
    } catch (_) {}
    _scanning = false;
    return noFaceFounded?.call();
  }

  double calculateBrightness(img.Image image) {
    try {
      int totalLuminance = 0;
      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          final pixel = image.getPixel(x, y);
          // Luminance formula: 0.299*R + 0.587*G + 0.114*B
          totalLuminance += (0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b).toInt();
        }
      }

      return totalLuminance / (image.width * image.height);
    } catch (e) {
      clog("$e");
    }

    return -1.0;
  }

  Future<double> compareImage(File model, File takenPhoto) async {
    var takenImage = await autoCropFace(takenPhoto).then((value) => value?.$2);
    var modelImage = await autoCropFace(model).then((value) => value?.$2);

    var intrTakenImage = await _interpreterRecogImage(takenImage!);
    var intrModel = await _interpreterRecogImage(modelImage!);

    clog("Comparing image");
    var compareResult = await _euclideanDistance(intrTakenImage!, intrModel!);
    clog("Result : $compareResult");

    return compareResult;
  }

  Future<double> _euclideanDistance(List e1, List e2) {
    return Isolate.run(() {
      double sum = 0.0;
      for (int i = 0; i < e1.length; i++) {
        sum += pow((e1[i] - e2[i]), 2);
      }
      return sqrt(sum);
    });
  }

  Future<List?> _interpreterRecogImage(img.Image image) {
    // List input = imageToByteListFloat32(image, 112, 128, 128);
    List output = List.generate(1, (index) => List.filled(192, 0));

    return Isolate.run(() {
      // input = input.reshape([1, 112, 112, 3]);
      // faceRecognition?.run(input, output);
      // output = output.reshape([192]);
      return output;
    });
  }

  Future<img.Image?> _convertCameraImage(CameraImage image, CameraLensDirection dir) async {
    try {
      img.Image? output;
      if (image.format.group == ImageFormatGroup.nv21) {
        if (kDebugMode) {
          output = _convertNV21(image);
        } else {
          output = await _convertNV21Isolated(image);
        }
      } else if (image.format.group == ImageFormatGroup.yuv420) {
        output = _convertYUV420(image, dir);
      } else if (image.format.group == ImageFormatGroup.bgra8888) {
        output = _convertBGRA8888(image, dir);
      }

      return output;
    } catch (_) {}
    return null;
  }

  Future<img.Image> _convertNV21Isolated(CameraImage image) {
    final width = image.width.toInt();
    final height = image.height.toInt();
    Uint8List yuv420sp = image.planes[0].bytes;

    // Initial conversion from NV21 to RGB
    return Isolate.run(() {
      final outImg = img.Image(height: height, width: width); // Note the swapped dimensions
      final int frameSize = width * height;

      for (int j = 0, yp = 0; j < height; j++) {
        int uvp = frameSize + (j >> 1) * width, u = 0, v = 0;
        for (int i = 0; i < width; i++, yp++) {
          int y = (0xff & yuv420sp[yp]) - 16;
          if (y < 0) y = 0;
          if ((i & 1) == 0) {
            v = (0xff & yuv420sp[uvp++]) - 128;
            u = (0xff & yuv420sp[uvp++]) - 128;
          }
          int y1192 = 1192 * y;
          int r = (y1192 + 1634 * v);
          int g = (y1192 - 833 * v - 400 * u);
          int b = (y1192 + 2066 * u);

          if (r < 0) {
            r = 0;
          } else if (r > 262143) {
            r = 262143;
          }
          if (g < 0) {
            g = 0;
          } else if (g > 262143) {
            g = 262143;
          }
          if (b < 0) {
            b = 0;
          } else if (b > 262143) {
            b = 262143;
          }

          outImg.setPixelRgba(width - i - 1, j, ((r << 6) & 0xff0000) >> 16, ((g >> 2) & 0xff00) >> 8, (b >> 10) & 0xff, 255);
        }
      }
      return outImg;
    });
    // Rotate the image by 90 degrees (or 270 degrees if needed)
    // return img.copyRotate(outImg, -90); // Use -90 for a 270 degrees rotation
  }

  img.Image _convertNV21(CameraImage image) {
    final width = image.width.toInt();
    final height = image.height.toInt();
    Uint8List yuv420sp = image.planes[0].bytes;

    // Initial conversion from NV21 to RGB
    final outImg = img.Image(height: height, width: width); // Note the swapped dimensions
    final int frameSize = width * height;

    for (int j = 0, yp = 0; j < height; j++) {
      int uvp = frameSize + (j >> 1) * width, u = 0, v = 0;
      for (int i = 0; i < width; i++, yp++) {
        int y = (0xff & yuv420sp[yp]) - 16;
        if (y < 0) y = 0;
        if ((i & 1) == 0) {
          v = (0xff & yuv420sp[uvp++]) - 128;
          u = (0xff & yuv420sp[uvp++]) - 128;
        }
        int y1192 = 1192 * y;
        int r = (y1192 + 1634 * v);
        int g = (y1192 - 833 * v - 400 * u);
        int b = (y1192 + 2066 * u);

        if (r < 0) {
          r = 0;
        } else if (r > 262143) {
          r = 262143;
        }
        if (g < 0) {
          g = 0;
        } else if (g > 262143) {
          g = 262143;
        }
        if (b < 0) {
          b = 0;
        } else if (b > 262143) {
          b = 262143;
        }

        outImg.setPixelRgba(width - i - 1, j, ((r << 6) & 0xff0000) >> 16, ((g >> 2) & 0xff00) >> 8, (b >> 10) & 0xff, 255);
      }
    }
    return outImg;

    // Rotate the image by 90 degrees (or 270 degrees if needed)
    // return img.copyRotate(outImg, -90); // Use -90 for a 270 degrees rotation
  }

  img.Image _convertBGRA8888(CameraImage image, CameraLensDirection dir) {
    var output = img.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: image.planes[0].bytes.buffer,
    );
    return output;
  }

  img.Image _convertYUV420(CameraImage image, CameraLensDirection dir) {
    int width = image.width;
    int height = image.height;
    var output = img.Image(width: width, height: height);
    const int hexFF = 0xFF000000;
    final int uvyButtonStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel ?? -1;
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex = uvPixelStride * (x / 2).floor() + uvyButtonStride * (y / 2).floor();
        final int index = y * width + x;
        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91).round().clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

        output.setPixelIndex(x, y, hexFF | (b << 16) | (g << 8) | r);
      }
    }
    var img1 = (dir == CameraLensDirection.front) ? img.copyRotate(output, angle: -90) : img.copyRotate(output, angle: 90);
    return img1;
  }

  Float32List imageToByteListFloat32(img.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (pixel.r - mean) / std;
        buffer[pixelIndex++] = (pixel.g - mean) / std;
        buffer[pixelIndex++] = (pixel.b - mean) / std;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  final orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraController controller, CameraImage image) {
    final description = controller.description;
    final sensorOrientation = description.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = orientations[controller.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (description.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    if (format == null || (Platform.isAndroid && format != InputImageFormat.nv21) || (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  void dispose() {
    isInitialized = false;
    faceDetector.close();
  }

  Uint8List convertYUV420ToNV21(CameraImage image) {
    final width = image.width;
    final height = image.height;

    // Planes from CameraImage
    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    // Buffers from Y, U, and V planes
    final yBuffer = yPlane.bytes;
    final uBuffer = uPlane.bytes;
    final vBuffer = vPlane.bytes;

    // Total number of pixels in NV21 format
    final numPixels = width * height + (width * height ~/ 2);
    final nv21 = Uint8List(numPixels);

    // Y (Luma) plane metadata
    int idY = 0;
    int idUV = width * height; // Start UV after Y plane
    final uvWidth = width ~/ 2;
    final uvHeight = height ~/ 2;

    // Strides and pixel strides for Y and UV planes
    final yRowStride = yPlane.bytesPerRow;
    final yPixelStride = yPlane.bytesPerPixel ?? 1;
    final uvRowStride = uPlane.bytesPerRow;
    final uvPixelStride = uPlane.bytesPerPixel ?? 2;

    // Copy Y (Luma) channel
    for (int y = 0; y < height; ++y) {
      final yOffset = y * yRowStride;
      for (int x = 0; x < width; ++x) {
        nv21[idY++] = yBuffer[yOffset + x * yPixelStride];
      }
    }

    // Copy UV (Chroma) channels in NV21 format (YYYYVU interleaved)
    for (int y = 0; y < uvHeight; ++y) {
      final uvOffset = y * uvRowStride;
      for (int x = 0; x < uvWidth; ++x) {
        final bufferIndex = uvOffset + (x * uvPixelStride);
        nv21[idUV++] = vBuffer[bufferIndex]; // V channel
        nv21[idUV++] = uBuffer[bufferIndex]; // U channel
      }
    }

    return nv21;
  }

  static FaceDetectorUtil read(BuildContext context) => context.read();

  Future<(File, img.Image)?> autoCropFace(File fileModel, {String? name, InputImageFormat? format}) async {
    var image = await img.decodeImageFile(fileModel.path);
    var inputImage = InputImage.fromFile(fileModel);

    var detectedUser = await faceDetector.processImage(inputImage);

    var filename = name ?? randomString(16);
    if (detectedUser.isNotEmpty) {
      var face = detectedUser.first;
      image = img.copyCrop(image!, x: face.boundingBox.left.toInt(), y: face.boundingBox.top.toInt(), height: face.boundingBox.height.toInt(), width: face.boundingBox.width.toInt());
      image = img.copyResize(image, width: 112, height: 112);

      var dir = await getApplicationCacheDirectory();
      var file = File("${dir.path}/$filename.jpg");
      await file.writeAsBytes(img.encodeJpg(image), flush: true);
      return (file, image);
    }

    return null;
  }
}

class FaceDetectorResult {
  final bool success;
  final String message;
  final File? data;

  FaceDetectorResult(this.success, this.message, [this.data]);
}
