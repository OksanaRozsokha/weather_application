class ApiEndpoint {
  final String route;
  final RequestMethod requestMethod;

  ApiEndpoint({required this.route, required this.requestMethod});
}

enum RequestMethod { get, post, put, update, patch, delete }
