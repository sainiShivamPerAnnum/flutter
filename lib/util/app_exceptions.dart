class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  const AppException([
    this._message,
    this._prefix = '',
  ]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  const FetchDataException([
    super.message,
  ]);
}

class BadRequestException extends AppException {
  const BadRequestException([
    super.message,
  ]);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([message])
      : super(
          message,
          "Unauthorized: ",
        );
}

class InvalidInputException extends AppException {
  const InvalidInputException([String? message])
      : super(
          message,
          "Invalid Input: ",
        );
}

class InternalServerException extends AppException {
  const InternalServerException([
    super._message,
  ]);
}
