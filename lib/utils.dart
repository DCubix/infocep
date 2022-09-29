typedef JSON = Map<String, dynamic>;

enum ResultType {
  success,
  error
}

class Result<T> {

  final T? data;
  final String? message;
  final ResultType type;

  Result._({
    required this.type,
    this.data,
    this.message,
  });

  static Result<T> success<T>(T? payload, { String? message }) {
    return Result._(type: ResultType.success, data: payload, message: message);
  }

  static Result<T> error<T>({ String? message }) {
    return Result._(type: ResultType.success, data: null, message: message);
  }

}
