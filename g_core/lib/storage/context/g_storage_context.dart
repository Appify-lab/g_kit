import 'package:g_common/utils/g_resolve_strategy.dart';
import 'package:g_core/storage/storage.dart';

class GStorageContext implements GStorageStrategy {
  final Map<GStorageType, GStorageStrategy> _strategies = {};

  GStorageType _type = GStorageType.prefs;
  GStorageType get type => _type;

  set setType(GStorageType type) {
    _type = type;
  }

  void registerStrategy(GStorageType type, GStorageStrategy strategy) {
    _strategies[type] = strategy;
  }

  @override
  Future<void> initialize() async {
    final prefsStrategy = await GStorageFactory.create(GStorageType.prefs);
    final secureStrategy = await GStorageFactory.create(GStorageType.secure);

    registerStrategy(GStorageType.prefs, prefsStrategy);
    registerStrategy(GStorageType.secure, secureStrategy);
  }

  @override
  Future<dynamic> get({required String key, GStorageType? type}) async {
    final strategy =
        resolveStrategy(strategies: _strategies, type: type ?? _type);
    return strategy.get(key: key);
  }

  @override
  Future<void> set(
      {required String key,
      required String value,
      DateTime? until,
      GStorageType? type}) async {
    final strategy =
        resolveStrategy(strategies: _strategies, type: type ?? _type);
    return strategy.set(key: key, value: value, until: until);
  }

  @override
  Future<void> clear({required String key, GStorageType? type}) async {
    final strategy =
        resolveStrategy(strategies: _strategies, type: type ?? _type);
    return strategy.clear(key: key);
  }

  @override
  Future<void> delete({required String key, GStorageType? type}) async {
    final strategy =
        resolveStrategy(strategies: _strategies, type: type ?? _type);
    return strategy.delete(key: key);
  }

  @override
  Future<void> cleanupExpired({GStorageType? type}) async {
    if (type != null) {
      final strategy = resolveStrategy(strategies: _strategies, type: type);
      return strategy.cleanupExpired();
    } else {
      for (final strategy in _strategies.values) {
        await strategy.cleanupExpired();
      }
    }
  }

  @override
  Future<void> clearAll({GStorageType? type}) async {
    final strategy =
        resolveStrategy(strategies: _strategies, type: type ?? _type);
    return strategy.clearAll();
  }

  @override
  Future<DateTime?> getExpiration(
      {required String key, GStorageType? type}) async {
    final strategy =
        resolveStrategy(strategies: _strategies, type: type ?? _type);
    return strategy.getExpiration(key: key);
  }

  @override
  Future<List<String>?> getKeys({GStorageType? type}) async {
    final strategy =
        resolveStrategy(strategies: _strategies, type: type ?? _type);
    return strategy.getKeys();
  }
}
