class ApiResponse<T> {
  final T? model;
  final String? errorMessage;
  final int? code;

  const ApiResponse({
    this.model,
    this.errorMessage,
    this.code,
  });

  const ApiResponse.withError(String this.errorMessage, int this.code)
      : model = null;

  bool isSuccess() {
    return code == 200;
  }

  @override
  String toString() =>
      'ApiResponse(model: $model, errorMessage: $errorMessage, code: $code)';
}
