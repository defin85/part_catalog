/// Базовый тип для всех типов элементов табличных частей (enum).
enum BaseItemType {
  part('part'),
  service('service'),
  material('material'),
  workStage('workStage'),
  comment('comment'),
  attachment('attachment');
  // Добавляйте другие типы по мере необходимости

  final String type;
  const BaseItemType(this.type);

  /// Получить BaseItemType по строковому идентификатору
  static BaseItemType fromType(String type) {
    return BaseItemType.values.firstWhere(
      (e) => e.type == type,
      orElse: () => throw ArgumentError('Неизвестный тип BaseItemType: $type'),
    );
  }

  @override
  String toString() => type;
}
