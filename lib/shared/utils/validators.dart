abstract final class Validators {
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static bool isValidEmail(String value) {
    final trimmed = value.trim();
    return trimmed.isNotEmpty && _emailRegex.hasMatch(trimmed);
  }

  static bool isValidPassword(String value) {
    return value.length >= 6;
  }

  static bool isValidDisplayName(String value) {
    final trimmed = value.trim();
    return trimmed.isNotEmpty && trimmed.length <= 40;
  }

  static bool isValidListingTitle(String value) {
    final trimmed = value.trim();
    return trimmed.isNotEmpty && trimmed.length <= 80;
  }
}
