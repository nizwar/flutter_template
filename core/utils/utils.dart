import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mojang_nontr/core/utils/navigations.dart';

import '../../ui/components/custom_divider.dart';

export 'navigations.dart';
export 'preferences.dart';

/// Converts a [Color] to a [MaterialColor].
///
/// This function takes a [Color] object and generates a [MaterialColor]
/// object from it. A [MaterialColor] is a color swatch that includes
/// different shades of the primary color.
///
/// - Parameter color: The [Color] to convert to a [MaterialColor].
///
/// - Returns: A [MaterialColor] object that represents the given [Color].
MaterialColor getMaterialColor(Color color) {
  int float(double number) {
    return (number * 255).round();
  }

  final int red = float(color.r);
  final int green = float(color.g);
  final int blue = float(color.b);

  // Function to lighten or darken color
  Color adjustBrightness(Color color, double factor) {
    int r = (float(color.r) * factor).clamp(0, 255).toInt();
    int g = (float(color.g) * factor).clamp(0, 255).toInt();
    int b = (float(color.b) * factor).clamp(0, 255).toInt();
    return Color.fromRGBO(r, g, b, 1);
  }

  final Map<int, Color> shades = {
    50: adjustBrightness(color, 1.2), // Lighter shade
    100: adjustBrightness(color, 1.1),
    200: adjustBrightness(color, 1.05),
    300: color, // Base color
    400: adjustBrightness(color, 0.95),
    500: adjustBrightness(color, 0.9),
    600: adjustBrightness(color, 0.85),
    700: adjustBrightness(color, 0.8), // Darker shade
    800: adjustBrightness(color, 0.75),
    900: adjustBrightness(color, 0.7),
  };

  int colorInt = (255 << 24) | (red << 16) | (green << 8) | blue;
  return MaterialColor(colorInt, shades);
}

/// Returns the size of the media in the given [BuildContext].
///
/// This function uses the [MediaQuery] widget to obtain the size of the
/// screen or parent widget in the provided [context].
///
/// Example usage:
/// ```dart
/// Size screenSize = size(context);
/// ```
///
/// - Parameter context: The [BuildContext] from which to obtain the media size.
/// - Returns: A [Size] object representing the width and height of the media.
Size size(BuildContext context) => MediaQuery.of(context).size;

/// Generates a random string of the specified length.
///
/// The generated string will contain a mix of uppercase and lowercase
/// letters, as well as digits.
///
/// [length] specifies the length of the generated string. It must be a
/// positive integer.
///
/// Returns a random string of the specified length.
///
/// Example:
/// ```dart
/// String result = randomString(10);
/// print(result); // Output: a random string of 10 characters
/// ```
String randomString(int length) {
  const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

Future<(Position, Placemark)?> getMyLocation([int permissionAttempt = 1]) async {
  Position location = await Geolocator.checkPermission().then((permission) async {
    var result = permission;
    if (result == LocationPermission.denied || result == LocationPermission.deniedForever) {
      result = await Geolocator.requestPermission();
    }

    if (result == LocationPermission.whileInUse || result == LocationPermission.always) {
      return await Geolocator.getCurrentPosition();
    } else {
      throw Exception("Location permission denied");
    }
  });

  final placeMark = await GeocodingPlatform.instance!.placemarkFromCoordinates(location.latitude, location.longitude).then((value) {
    if (value.isNotEmpty) {
      return value.first;
    } else {
      throw Exception("No placemark found for the given coordinates");
    }
  });

  return (location, placeMark);
}

ScaffoldFeatureController showErrorSnackbar(BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
  ));
}

ScaffoldFeatureController showSuccessSnackbar(BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Colors.green,
  ));
}

Future<File?> pickAttachment(BuildContext context, {bool gallery = true, bool camera = true, bool file = true, List<String>? allowedExtension}) {
  var picker = ImagePicker();
  if (gallery && !camera && !file) {
    return picker.pickImage(source: ImageSource.gallery).then((value) => value != null ? File(value.path) : null);
  }
  if (!gallery && camera && !file) {
    return picker.pickImage(source: ImageSource.camera).then((value) => value != null ? File(value.path) : null);
  }
  if (!gallery && !camera && file) {
    return FilePicker.platform
        .pickFiles(allowMultiple: false, allowedExtensions: allowedExtension, type: (allowedExtension?.isNotEmpty ?? false) ? FileType.custom : FileType.media)
        .then((value) => (value?.files.isNotEmpty ?? false) ? File(value!.files.first.path!) : null);
  }
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    context: context,
    builder: (context) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 20,
                alignment: Alignment.center,
                child: Container(width: 80, height: 3, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
              ),
              if (file)
                ListTile(
                  leading: const Icon(IconsaxPlusLinear.document_1),
                  title: const Text("Lampiran File"),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  onTap: () =>
                      FilePicker.platform.pickFiles(allowMultiple: false, type: (allowedExtension?.isNotEmpty ?? false) ? FileType.custom : FileType.media, allowedExtensions: allowedExtension).then(
                            (value) => closeScreen(context, (value?.files.isNotEmpty ?? false) ? File(value!.files.first.path!) : null),
                          ),
                ),
              if (gallery)
                ListTile(
                  leading: const Icon(IconsaxPlusLinear.gallery),
                  title: const Text("Pilih Foto"),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  onTap: () => picker.pickImage(source: ImageSource.gallery).then((value) => closeScreen(context, value != null ? File(value.path) : null)),
                ),
              if (camera)
                ListTile(
                  leading: const Icon(IconsaxPlusLinear.camera),
                  title: const Text("Ambil Foto"),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  onTap: () => picker.pickImage(source: ImageSource.camera).then((value) => closeScreen(context, value != null ? File(value.path) : null)),
                ),
              const ColumnDivider(),
            ],
          ),
        ),
      );
    },
  );
}
