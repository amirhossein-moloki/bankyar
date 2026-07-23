import '../logging/logger.dart';

/// Lightweight, in-memory volatile cache storage with Time-To-Live (TTL) support.
/// Conforms to DATABASE_ARCHITECTURE.md Caching Strategy guidelines.
class CacheStorage {
  /// Constructor injecting standard logger.
  CacheStorage(this._logger);

  final AppLogger _logger;
  final Map<String, _CacheEntry<dynamic>> _cacheMap = {};

  /// Writes an item to the cache with an explicit duration TTL.
  void set<T>(String key, T value, Duration ttl) {
    final expiresAt = DateTime.now().add(ttl);
    _cacheMap[key] = _CacheEntry<T>(value: value, expiresAt: expiresAt);
    _logger.log(
      LogLevel.debug,
      LogCategories.stateManagement,
      'BY_CACHE_SET',
      'Saved item to volatile memory cache.',
      metadata: {'key': key, 'expires_at': expiresAt.toIso8601String()},
    );
  }

  /// Reads a typed item from the cache. Returns null if missing or expired.
  T? get<T>(String key) {
    final entry = _cacheMap[key];
    if (entry == null) {
      return null;
    }

    if (entry.isExpired) {
      _logger.log(
        LogLevel.debug,
        LogCategories.stateManagement,
        'BY_CACHE_EXPIRED',
        'Cache entry expired and was removed.',
        metadata: {'key': key},
      );
      _cacheMap.remove(key);
      return null;
    }

    try {
      return entry.value as T;
    } catch (e) {
      _logger.log(
        LogLevel.warn,
        LogCategories.stateManagement,
        'BY_CACHE_CAST_FAILED',
        'Failed to cast cache item to target type.',
        metadata: {'key': key, 'target_type': T.toString()},
      );
      return null;
    }
  }

  /// Manually invalidates and removes a cache key.
  void remove(String key) {
    _cacheMap.remove(key);
  }

  /// Flushes all entries from memory cache.
  void clear() {
    _cacheMap.clear();
    _logger.log(
      LogLevel.info,
      LogCategories.stateManagement,
      'BY_CACHE_CLEAR',
      'Flushed all volatile cache keys.',
    );
  }

  /// Housekeeping routine to prune all expired cache keys.
  void pruneExpired() {
    final now = DateTime.now();
    _cacheMap.removeWhere((key, entry) => entry.expiresAt.isBefore(now));
  }
}

class _CacheEntry<T> {
  const _CacheEntry({required this.value, required this.expiresAt});

  final T value;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
