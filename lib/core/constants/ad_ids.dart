class AdIds {
  // ===========================================================================
  // 1. ADMOB APP ID (Uygulama Kimliği)
  // Bu ID'yi AndroidManifest.xml ve Info.plist dosyalarına da koymanız gerekecek.
  // ===========================================================================
  // Şimdilik Test ID'si yazılıdır. Kendi ID'nizi aldığınızda buraya not düşün.
  static const String appIdAndroid = 'ca-app-pub-7473181850268727~4009779491';
  static const String appIdIOS = 'ca-app-pub-7473181850268727~2162285283';

  // ===========================================================================
  // 2. AD UNIT ID'leri (Reklam Birimi Kimlikleri)
  // AdMob panelinden oluşturduğunuz reklamların kodları buraya gelecek.
  // ===========================================================================

  // ZIP Yükleme Sonrası (Tam Ekran Reklam) - Interstitial
  // Test ID: ca-app-pub-3940256099942544/1033173712
  static const String interstitialAndroid =
      'ca-app-pub-7473181850268727/6587441994';
  static const String interstitialIOS =
      'ca-app-pub-7473181850268727/3806539447';

  // Uygulama Açılışı (Açılış Reklamı) - App Open
  // Test ID: ca-app-pub-3940256099942544/3419835294
  static const String appOpenAndroid = 'ca-app-pub-7473181850268727/7757452811';
  static const String appOpenIOS = 'ca-app-pub-7473181850268727/6049559406';

  // Banner Reklamlar
  // Test ID: ca-app-pub-3940256099942544/6300978111
  static const String bannerAndroid = 'ca-app-pub-7473181850268727/6863947628';
  static const String bannerIOS = 'ca-app-pub-7473181850268727/3222912053';
}
