import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:image_picker/image_picker.dart';

abstract final class ImageUtils {
  /// Compresses and downscales image bytes to keep them under [maxBytes].
  static Future<Uint8List> optimizeImageBytes(
    Uint8List bytes, {
    int maxBytes = 60 * 1024,
    List<int> targetWidths = const [512, 384, 256, 180],
  }) async {
    if (bytes.lengthInBytes <= maxBytes) {
      return bytes;
    }

    for (final targetWidth in targetWidths) {
      try {
        final codec = await ui.instantiateImageCodec(
          bytes,
          targetWidth: targetWidth,
        );
        final frame = await codec.getNextFrame();
        final byteData = await frame.image.toByteData(
          format: ui.ImageByteFormat.png,
        );
        if (byteData != null && byteData.lengthInBytes <= maxBytes) {
          return byteData.buffer.asUint8List();
        }
      } catch (_) {
        continue;
      }
    }
    return bytes;
  }

  /// Converts image bytes into a data URI (`data:image/png;base64,...` or jpeg).
  static String toDataUri(Uint8List bytes) {
    final isPng =
        bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47;
    final mimeType = isPng ? 'image/png' : 'image/jpeg';
    final base64String = base64Encode(bytes);
    return 'data:$mimeType;base64,$base64String';
  }

  /// Picks and optimizes an image from camera or gallery into a Base64 data URI.
  static Future<String?> pickAndOptimize({
    required ImageSource source,
    int maxDimension = 640,
    int quality = 80,
    int maxBytes = 60 * 1024,
  }) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: maxDimension.toDouble(),
      maxHeight: maxDimension.toDouble(),
      imageQuality: quality,
    );
    if (picked == null) return null;

    final rawBytes = await picked.readAsBytes();
    if (rawBytes.isEmpty) return null;

    final optimized = await optimizeImageBytes(rawBytes, maxBytes: maxBytes);
    return toDataUri(optimized);
  }
}
