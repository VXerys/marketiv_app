class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}

class ConflictException implements Exception {
  final String message;
  ConflictException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}
