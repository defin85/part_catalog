import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mixin для экранов со списками, поддерживающими поиск
mixin SearchableListMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  /// Контроллер для поиска
  late final TextEditingController searchController;

  /// Текущий поисковый запрос
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  /// Обновить поисковый запрос
  void updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  /// Очистить поиск
  void clearSearch() {
    searchController.clear();
    updateSearchQuery('');
  }

  /// Проверить, содержит ли текст поисковый запрос
  bool containsSearchText(String text) {
    if (_searchQuery.isEmpty) return true;
    return text.toLowerCase().contains(_searchQuery.toLowerCase());
  }

  /// Проверить, соответствует ли элемент поисковому запросу по списку полей
  bool matchesSearchQuery(List<String> searchableFields) {
    if (_searchQuery.isEmpty) return true;
    final query = _searchQuery.toLowerCase();
    return searchableFields.any((field) =>
      field.toLowerCase().contains(query));
  }
}