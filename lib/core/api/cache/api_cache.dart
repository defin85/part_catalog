import 'dart:typed_data';

/// Интерфейс для кеша API
abstract class ApiCache {
  /// Получает данные из кеша
  Future<T?> get<T>(String key, T Function(Map<String, dynamic>) fromJson);
  
  /// Сохраняет данные в кеш
  Future<void> set<T>(String key, T data, T Function(T) toJson);
  
  /// Получает сырые данные из кеша
  Future<Uint8List?> getRaw(String key);
  
  /// Сохраняет сырые данные в кеш
  Future<void> setRaw(String key, Uint8List data);
  
  /// Удаляет данные из кеша
  Future<void> remove(String key);
  
  /// Проверяет существование ключа в кеше
  Future<bool> contains(String key);
  
  /// Очищает весь кеш
  Future<void> clear();
  
  /// Получает размер кеша в байтах
  Future<int> size();
  
  /// Получает все ключи в кеше
  Future<List<String>> keys();
}

/// Запись кеша с метаданными
class CacheEntry<T> {
  final T data;
  final DateTime createdAt;
  final DateTime expiresAt;
  final Map<String, dynamic>? metadata;
  
  const CacheEntry({
    required this.data,
    required this.createdAt,
    required this.expiresAt,
    this.metadata,
  });
  
  bool get isExpired => DateTime.now().isAfter(expiresAt);
  
  Duration get age => DateTime.now().difference(createdAt);
  
  Duration get timeToLive => expiresAt.difference(DateTime.now());
  
  Map<String, dynamic> toJson(dynamic Function(T) dataToJson) {
    return {
      'data': dataToJson(data),
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'metadata': metadata,
    };
  }
  
  static CacheEntry<T> fromJson<T>(
    Map<String, dynamic> json,
    T Function(dynamic) dataFromJson,
  ) {
    return CacheEntry<T>(
      data: dataFromJson(json['data']),
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
      metadata: json['metadata'],
    );
  }
}

/// Конфигурация кеша
class CacheConfig {
  final Duration defaultTtl;
  final int maxSize;
  final bool enabled;
  final Map<String, Duration> keySpecificTtl;
  
  const CacheConfig({
    this.defaultTtl = const Duration(minutes: 5),
    this.maxSize = 50 * 1024 * 1024, // 50MB
    this.enabled = true,
    this.keySpecificTtl = const {},
  });
  
  Duration getTtlForKey(String key) {
    return keySpecificTtl[key] ?? defaultTtl;
  }
}

/// Стратегии очистки кеша
enum EvictionStrategy {
  lru,    // Least Recently Used
  lfu,    // Least Frequently Used
  fifo,   // First In, First Out
  ttl,    // Time To Live based
}

/// Метрики кеша
class CacheMetrics {
  int hits = 0;
  int misses = 0;
  int evictions = 0;
  int writes = 0;
  DateTime lastAccess = DateTime.now();
  
  double get hitRate => hits + misses > 0 ? hits / (hits + misses) : 0.0;
  
  void recordHit() {
    hits++;
    lastAccess = DateTime.now();
  }
  
  void recordMiss() {
    misses++;
    lastAccess = DateTime.now();
  }
  
  void recordEviction() {
    evictions++;
  }
  
  void recordWrite() {
    writes++;
  }
  
  void reset() {
    hits = 0;
    misses = 0;
    evictions = 0;
    writes = 0;
    lastAccess = DateTime.now();
  }
  
  Map<String, dynamic> toJson() {
    return {
      'hits': hits,
      'misses': misses,
      'evictions': evictions,
      'writes': writes,
      'hitRate': hitRate,
      'lastAccess': lastAccess.toIso8601String(),
    };
  }
}

/// Утилиты для работы с ключами кеша
class CacheKeyBuilder {
  static String forApiRequest({
    required String endpoint,
    required String method,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) {
    final buffer = StringBuffer();
    buffer.write('${method.toUpperCase()}:$endpoint');
    
    if (queryParams != null && queryParams.isNotEmpty) {
      final sortedParams = queryParams.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      
      buffer.write('?');
      buffer.write(sortedParams
          .map((e) => '${e.key}=${e.value}')
          .join('&'));
    }
    
    if (body != null && body.isNotEmpty) {
      buffer.write('#body:${_hashObject(body)}');
    }
    
    if (headers != null && headers.isNotEmpty) {
      final relevantHeaders = headers.entries
          .where((e) => _isRelevantHeader(e.key))
          .toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      
      if (relevantHeaders.isNotEmpty) {
        buffer.write('#headers:${_hashObject(Map.fromEntries(relevantHeaders))}');
      }
    }
    
    return buffer.toString();
  }
  
  static String forUser(String userId) => 'user:$userId';
  
  static String forResource(String resource, String id) => '$resource:$id';
  
  static String withPrefix(String prefix, String key) => '$prefix:$key';
  
  static bool _isRelevantHeader(String headerName) {
    const relevantHeaders = {
      'authorization',
      'accept-language',
      'x-api-key',
      'x-client-version',
    };
    return relevantHeaders.contains(headerName.toLowerCase());
  }
  
  static String _hashObject(Object obj) {
    return obj.hashCode.toRadixString(36);
  }
}

/// Middleware для автоматического кеширования ответов API
class CacheMiddleware {
  final ApiCache cache;
  final CacheConfig config;
  final CacheMetrics metrics = CacheMetrics();
  
  CacheMiddleware({
    required this.cache,
    required this.config,
  });
  
  Future<T?> getCachedResponse<T>(
    String cacheKey,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    if (!config.enabled) return null;
    
    try {
      final entryData = await cache.get<Map<String, dynamic>>(
        cacheKey,
        (json) => json,
      );
      
      final entry = entryData != null 
          ? CacheEntry.fromJson<T>(entryData, (data) => fromJson(data as Map<String, dynamic>))
          : null;
      
      if (entry != null && !entry.isExpired) {
        metrics.recordHit();
        return entry.data;
      } else if (entry != null && entry.isExpired) {
        await cache.remove(cacheKey);
      }
      
      metrics.recordMiss();
      return null;
    } catch (e) {
      metrics.recordMiss();
      return null;
    }
  }
  
  Future<void> cacheResponse<T>(
    String cacheKey,
    T data,
    Map<String, dynamic> Function(T) toJson, {
    Duration? ttl,
  }) async {
    if (!config.enabled) return;
    
    try {
      final effectiveTtl = ttl ?? config.getTtlForKey(cacheKey);
      final entry = CacheEntry<T>(
        data: data,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(effectiveTtl),
      );
      
      await cache.set(cacheKey, entry.toJson(toJson), (data) => data);
      metrics.recordWrite();
    } catch (e) {
      // Игнорируем ошибки кеширования
    }
  }
}

/// Политики кеширования для разных типов запросов
class CachePolicies {
  // Статические данные (справочники, конфигурации)
  static const Duration staticData = Duration(hours: 24);
  
  // Пользовательские данные
  static const Duration userData = Duration(minutes: 15);
  
  // Поисковые запросы
  static const Duration searchResults = Duration(minutes: 5);
  
  // Каталоги товаров
  static const Duration productCatalog = Duration(hours: 1);
  
  // Цены и наличие
  static const Duration pricesAndStock = Duration(minutes: 2);
  
  // Информация о заказах
  static const Duration orderInfo = Duration(minutes: 30);
  
  // Настройки приложения
  static const Duration appSettings = Duration(days: 7);
  
  /// Получает TTL для конкретного типа данных
  static Duration getTtlForDataType(String dataType) {
    switch (dataType.toLowerCase()) {
      case 'static':
      case 'reference':
      case 'configuration':
        return staticData;
      case 'user':
      case 'profile':
        return userData;
      case 'search':
      case 'query':
        return searchResults;
      case 'product':
      case 'catalog':
        return productCatalog;
      case 'price':
      case 'stock':
      case 'availability':
        return pricesAndStock;
      case 'order':
      case 'orders':
        return orderInfo;
      case 'settings':
      case 'config':
        return appSettings;
      default:
        return const Duration(minutes: 5);
    }
  }
}