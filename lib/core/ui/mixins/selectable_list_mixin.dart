import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mixin для экранов со списками, поддерживающими выбор элементов
mixin SelectableListMixin<T extends ConsumerStatefulWidget, TItem> on ConsumerState<T> {
  /// Выбранный элемент
  TItem? _selectedItem;
  TItem? get selectedItem => _selectedItem;

  /// Выбрать элемент
  void selectItem(TItem? item) {
    setState(() {
      _selectedItem = item;
    });
  }

  /// Очистить выбор
  void clearSelection() {
    selectItem(null);
  }

  /// Проверить, выбран ли элемент
  bool isSelected(TItem item, bool Function(TItem, TItem) compareFn) {
    return _selectedItem != null && compareFn(_selectedItem as TItem, item);
  }

  /// Переключить выбор элемента
  void toggleSelection(TItem item) {
    if (_selectedItem == item) {
      clearSelection();
    } else {
      selectItem(item);
    }
  }
}