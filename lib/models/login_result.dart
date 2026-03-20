
enum LoginErrorType {
  none,
  emailNotFound,
  wrongPassword,
  other,
}

class LoginResult {
  final bool success;
  final LoginErrorType errorType;
  final String? message;

  LoginResult({
    required this.success,
    required this.errorType,
    this.message,
  });
}