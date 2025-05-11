// TODO: Заменить на более гибкое решение в будущем (например, загрузка из конфига или БД)

enum SupplierCode {
  armtek,
  autodoc,
  // emex, // Пример другого поставщика
  // berg, // Пример другого поставщика
}

extension SupplierCodeExtension on SupplierCode {
  String get displayName {
    switch (this) {
      case SupplierCode.armtek:
        return 'Armtek';
      case SupplierCode.autodoc:
        return 'Autodoc';
      // case SupplierCode.emex:
      //   return 'Emex';
      // case SupplierCode.berg:
      //   return 'Berg';
    }
  }

  String get code {
    return name; // 'armtek', 'autodoc'
  }

  // Можно добавить иконки или другую метаинформацию здесь
  // IconData get icon {
  //   switch (this) {
  //     case SupplierCode.armtek:
  //       return Icons.store;
  //     case SupplierCode.autodoc:
  //       return Icons.local_shipping;
  //   }
  // }
}

// Список всех поддерживаемых поставщиков
final List<SupplierCode> allSupportedSuppliers = SupplierCode.values;
