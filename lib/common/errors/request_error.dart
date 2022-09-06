class RequestError extends Error {
  final int statusCode;
  final String? message;
  final Map<String, dynamic>? data;

  RequestError({required this.statusCode, this.message, this.data});
}
