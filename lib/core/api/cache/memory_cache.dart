import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'api_cache.dart';

/// Реализация кеша в памяти с поддержкой LRU и TTL
class MemoryCache implements ApiCache {
  final CacheConfig _config;
  final CacheMetrics _metrics = CacheMetrics();
  final LinkedHashMap<String, _CacheItem> _cache = LinkedHashMap();
  int _currentSize = 0;

  MemoryCache(this._config);

  CacheMetrics get metrics => _metrics;

  @override
  Future<T?> get<T>(
      String key, T Function(Map<String, dynamic>) fromJson) async {
    if (!_config.enabled) return null;

    final item = _cache[key];
    if (item == null) {
      _metrics.recordMiss();
      return null;
    }

    // Проверяем TTL
    if (item.isExpired) {
      await remove(key);
      _metrics.recordMiss();
      return null;
    }

    // Обновляем позицию в LRU (перемещаем в конец)
    _cache.remove(key);
    _cache[key] = item.copyWith(lastAccessed: DateTime.now());

    _metrics.recordHit();

    try {
      final json = jsonDecode(item.data);
      return fromJson(json);
    } catch (e) {
      await remove(key);
      _metrics.recordMiss();
      return null;
    }
  }

  @override
  Future<void> set<T>(String key, T data, Function(T) toJson) async {
    if (!_config.enabled) return;

    final jsonString = jsonEncode(toJson(data));
    final dataSize = utf8.encode(jsonString).length;

    // Проверяем, поместится ли новый элемент
    await _ensureSpace(dataSize);

    final ttl = _config.getTtlForKey(key);
    final item = _CacheItem(
      data: jsonString,
      size: dataSize,
      createdAt: DateTime.now(),
      lastAccessed: DateTime.now(),
      expiresAt: DateTime.now().add(ttl),
    );

    // Удаляем старое значение, если оно есть
    if (_cache.containsKey(key)) {
      final oldItem = _cache[key]!;
      _currentSize -= oldItem.size;
    }

    _cache[key] = item;
    _currentSize += dataSize;
    _metrics.recordWrite();
  }

  @override
  Future<Uint8List?> getRaw(String key) async {
    final item = _cache[key];
    if (item == null || item.isExpired) {
      _metrics.recordMiss();
      return null;
    }

    // Обновляем позицию в LRU
    _cache.remove(key);
    _cache[key] = item.copyWith(lastAccessed: DateTime.now());

    _metrics.recordHit();
    return Uint8List.fromList(utf8.encode(item.data));
  }

  @override
  Future<void> setRaw(String key, Uint8List data) async {
    if (!_config.enabled) return;

    final dataString = utf8.decode(data);
    await _ensureSpace(data.length);

    final ttl = _config.getTtlForKey(key);
    final item = _CacheItem(
      data: dataString,
      size: data.length,
      createdAt: DateTime.now(),
      lastAccessed: DateTime.now(),
      expiresAt: DateTime.now().add(ttl),
    );

    if (_cache.containsKey(key)) {
      final oldItem = _cache[key]!;
      _currentSize -= oldItem.size;
    }

    _cache[key] = item;
    _currentSize += data.length;
    _metrics.recordWrite();
  }

  @override
  Future<void> remove(String key) async {
    final item = _cache.remove(key);
    if (item != null) {
      _currentSize -= item.size;
    }
  }

  @override
  Future<bool> contains(String key) async {
    final item = _cache[key];
    if (item == null) return false;

    if (item.isExpired) {
      await remove(key);
      return false;
    }

    return true;
  }

  @override
  Future<void> clear() async {
    _cache.clear();
    _currentSize = 0;
    _metrics.reset();
  }

  @override
  Future<int> size() async {
    await _cleanupExpired();
    return _currentSize;
  }

  @override
  Future<List<String>> keys() async {
    await _cleanupExpired();
    return _cache.keys.toList();
  }

  /// Очищает просроченные элементы
  Future<void> _cleanupExpired() async {
    final expiredKeys = <String>[];
    final now = DateTime.now();

    for (final entry in _cache.entries) {
      if (entry.value.expiresAt.isBefore(now)) {
        expiredKeys.add(entry.key);
      }
    }

    for (final key in expiredKeys) {
      await remove(key);
    }
  }

  /// Освобождает место в кеше для нового элемента
  Future<void> _ensureSpace(int requiredSize) async {
    // Сначала очищаем просроченные элементы
    await _cleanupExpired();

    // Если места все еще недостаточно, используем LRU eviction
    while (_currentSize + requiredSize > _config.maxSize && _cache.isNotEmpty) {
      final oldestKey = _cache.keys.first;
      await remove(oldestKey);
      _metrics.recordEviction();
    }
  }

  /// Получает информацию о состоянии кеша
  Map<String, dynamic> getStats() {
    return {
      'enabled': _config.enabled,
      'currentSize': _currentSize,
      'maxSize': _config.maxSize,
      'itemCount': _cache.length,
      'metrics': _metrics.toJson(),
      'utilizationPercent':
          (_currentSize / _config.maxSize * 100).toStringAsFixed(2),
    };
  }

  /// Получает детальную информацию о кеше для отладки
  Map<String, dynamic> getDebugInfo() {
    final now = DateTime.now();
    final items = <String, Map<String, dynamic>>{};

    for (final entry in _cache.entries) {
      final item = entry.value;
      items[entry.key] = {
        'size': item.size,
        'createdAt': item.createdAt.toIso8601String(),
        'lastAccessed': item.lastAccessed.toIso8601String(),
        'expiresAt': item.expiresAt.toIso8601String(),
        'age': now.difference(item.createdAt).inSeconds,
        'ttl': item.expiresAt.difference(now).inSeconds,
        'isExpired': item.isExpired,
      };
    }

    return {
      'stats': getStats(),
      'items': items,
    };
  }
}

/// Внутренний класс для элемента кеша
class _CacheItem {
  final String data;
  final int size;
  final DateTime createdAt;
  final DateTime lastAccessed;
  final DateTime expiresAt;

  const _CacheItem({
    required this.data,
    required this.size,
    required this.createdAt,
    required this.lastAccessed,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  _CacheItem copyWith({
    String? data,
    int? size,
    DateTime? createdAt,
    DateTime? lastAccessed,
    DateTime? expiresAt,
  }) {
    return _CacheItem(
      data: data ?? this.data,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
