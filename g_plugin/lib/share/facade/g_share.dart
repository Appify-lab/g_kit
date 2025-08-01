import '../g_share_initializer.dart';
import '../models/share_type.dart';

/// 공유 모듈의 Facade 클래스
///
/// 공유 기능을 쉽게 사용할 수 있도록 정적 메서드를 제공합니다.
///
/// 주의: 사용 전에 GPluginInitializer.initializeAll()을 통해 초기화해야 합니다.
class GShare {
  static final GShareInitializer _initializer = GShareInitializer();

  static Future<void> dispose() async => await _initializer.dispose();

  // 텍스트 공유
  static Future<void> text(String text,
      {String? title, String? subject}) async {
    return await _initializer.service
        .text(text, title: title, subject: subject);
  }

  // 파일 공유
  static Future<void> files(List<String> files,
      {String? title, String? subject, String? text}) async {
    return await _initializer.service
        .files(files, title: title, subject: subject, text: text);
  }

  // 이미지 공유
  static Future<void> images(List<String> images,
      {String? title, String? subject, String? text}) async {
    return await _initializer.service
        .images(images, title: title, subject: subject, text: text);
  }

  // 링크 공유
  static Future<void> links(String link,
      {String? title, String? subject, String? text}) async {
    return await _initializer.service
        .links(link, title: title, subject: subject, text: text);
  }

  // 공유 가능 여부 확인
  static Future<bool> canShare(ShareType type) async {
    return await _initializer.service.canShare(type);
  }

  // 공유 가능한 앱 목록 가져오기
  static Future<List<String>> getAvailableApps(ShareType type) async {
    return await _initializer.service.getAvailableApps(type);
  }
}
