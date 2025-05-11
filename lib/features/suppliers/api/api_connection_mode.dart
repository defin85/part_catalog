enum ApiConnectionMode {
  direct,
  proxy,
  // hybrid, // Можно добавить позже, если потребуется
}

extension ApiConnectionModeExtension on ApiConnectionMode {
  String get name {
    switch (this) {
      case ApiConnectionMode.direct:
        return 'direct';
      case ApiConnectionMode.proxy:
        return 'proxy';
    }
  }

  static ApiConnectionMode fromName(String? name) {
    switch (name) {
      case 'direct':
        return ApiConnectionMode.direct;
      case 'proxy':
        return ApiConnectionMode.proxy;
      default:
        return ApiConnectionMode.direct; // Значение по умолчанию
    }
  }
}
