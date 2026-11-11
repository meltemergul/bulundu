import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

abstract final class PlatformInfo {
  static bool get isWeb => kIsWeb;

  static bool get isApple =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  static bool get isDesktop =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux);

  static bool supportsCamera([ImagePicker? picker]) {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.macOS) {
      return false;
    }
    return (picker ?? ImagePicker()).supportsImageSource(ImageSource.camera);
  }
}
