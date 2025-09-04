/// Исключение для отображения понятных пользователю ошибок в UI
class UserFriendlyException implements Exception {
  /// Сообщение, которое безопасно и полезно показывать пользователю
  final String message;

  /// Технические детали (необязательно), для логов/диагностики
  final String? details;

  UserFriendlyException(this.message, {this.details});

  @override
  String toString() => message;
}
