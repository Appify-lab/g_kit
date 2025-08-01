import 'package:g_core/storage/common/g_storage_type.dart' show GStorageType;
import 'package:g_core/storage/g_storage_initializer.dart';

class GStorage {
  /// 읽기
  static Future<dynamic> get({
    required String key,
    bool isSecure = false,
  }) async {
    final type = isSecure ? GStorageType.secure : GStorageType.prefs;
    return GStorageInitializer.context.get(key: key, type: type);
  }

  /// 쓰기
  static Future<void> set({
    required String key,
    required dynamic value,
    DateTime? until,
    bool isSecure = false,
  }) async {
    if (key.isEmpty) {
      throw ArgumentError('Key cannot be empty');
    }

    final type = isSecure ? GStorageType.secure : GStorageType.prefs;
    return GStorageInitializer.context
        .set(key: key, value: value, until: until, type: type);
  }

  /// 삭제
  static Future<void> delete({
    required String key,
    bool isSecure = false,
  }) async {
    final type = isSecure ? GStorageType.secure : GStorageType.prefs;
    return GStorageInitializer.context.delete(key: key, type: type);
  }

  /// 삭제
  static Future<void> clear({
    required String key,
    bool isSecure = false,
  }) async {
    final type = isSecure ? GStorageType.secure : GStorageType.prefs;
    return GStorageInitializer.context.clear(key: key, type: type);
  }

  /// 모두 삭제
  static Future<void> clearAll({
    bool isSecure = false,
  }) async {
    final type = isSecure ? GStorageType.secure : GStorageType.prefs;
    return GStorageInitializer.context.clearAll(type: type);
  }

  /// 키 조회
  static Future<List<String>?> getKeys({
    bool isSecure = false,
  }) async {
    final type = isSecure ? GStorageType.secure : GStorageType.prefs;
    return GStorageInitializer.context.getKeys(type: type);
  }

  /// 만료된 데이터 정리
  static Future<void> cleanupExpired({
    bool? isSecure,
  }) async {
    if (isSecure != null) {
      final type = isSecure ? GStorageType.secure : GStorageType.prefs;
      return GStorageInitializer.context.cleanupExpired(type: type);
    } else {
      // 모든 타입에서 만료된 데이터 정리
      return GStorageInitializer.context.cleanupExpired();
    }
  }

  /// 특정 키의 만료 시간 확인
  static Future<DateTime?> getExpiration({
    required String key,
    bool isSecure = false,
  }) async {
    final type = isSecure ? GStorageType.secure : GStorageType.prefs;
    return GStorageInitializer.context.getExpiration(key: key, type: type);
  }

  /// TTL과 함께 데이터 저장
  static Future<void> setWithTtl({
    required String key,
    required String value,
    required Duration ttl,
    bool isSecure = false,
  }) async {
    final until = DateTime.now().add(ttl);
    return set(key: key, value: value, until: until, isSecure: isSecure);
  }

  /// 남은 TTL 시간 확인
  static Future<int?> getRemainingTtl({
    required String key,
    bool isSecure = false,
  }) async {
    final expiration = await getExpiration(key: key, isSecure: isSecure);
    if (expiration == null) return null;

    final remaining = expiration.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }
}
