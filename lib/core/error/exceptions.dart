class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException(statusCode: $statusCode, message: $message)';
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});

  @override
  String toString() => 'CacheException(message: $message)';
}

class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'Device is disconnected from the network.'});

  @override
  String toString() => 'NetworkException(message: $message)';
}
