class AppException implements Exception {
  const AppException(this.code, [this.debugDetails]);

  final String code;
  final Object? debugDetails;

  @override
  String toString() => 'AppException($code)';
}
