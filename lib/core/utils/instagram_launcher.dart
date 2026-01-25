import 'package:url_launcher/url_launcher.dart';

/// Instagram profil ve içerik açma yardımcı sınıfı
class InstagramLauncher {
  /// Instagram profil sayfasını aç
  /// [username] @ işareti olmadan veya ile verilebilir
  static Future<bool> openProfile(String username) async {
    // @ işaretini temizle
    final cleanUsername = username.replaceAll('@', '').trim();

    if (cleanUsername.isEmpty) return false;

    // Önce Instagram uygulamasını dene
    final instagramAppUri = Uri.parse(
      'instagram://user?username=$cleanUsername',
    );

    try {
      if (await canLaunchUrl(instagramAppUri)) {
        return await launchUrl(
          instagramAppUri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (_) {
      // Instagram uygulaması yüklü değil, web'e düş
    }

    // Web URL'i aç
    final webUri = Uri.parse('https://www.instagram.com/$cleanUsername/');

    try {
      return await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      return false;
    }
  }

  /// Instagram gönderisini aç
  static Future<bool> openPost(String postUrl) async {
    if (postUrl.isEmpty) return false;

    final uri = Uri.parse(postUrl);

    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      return false;
    }
  }

  /// Instagram reel'ini aç
  static Future<bool> openReel(String reelUrl) async {
    return openPost(reelUrl);
  }
}
