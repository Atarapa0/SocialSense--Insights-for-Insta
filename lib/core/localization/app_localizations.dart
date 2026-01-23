import 'package:flutter/material.dart';

/// Desteklenen diller
enum AppLanguage {
  turkish('tr', 'Türkçe'),
  english('en', 'English');

  final String code;
  final String name;
  const AppLanguage(this.code, this.name);
}

/// Uygulama çevirileri
/// Türkçe ve İngilizce dil desteği
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'tr': _turkishStrings,
    'en': _englishStrings,
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // ==========================================
  // TÜRKÇE
  // ==========================================
  static const Map<String, String> _turkishStrings = {
    // Genel
    'app_name': 'SocialSense',
    'app_slogan': 'Instagram İstatistiklerinizi Keşfedin',

    // Karşılama ekranı
    'welcome_title': 'Hoş Geldiniz',
    'welcome_subtitle':
        'Instagram verilerinizi analiz edin ve istatistiklerinizi görün',
    'get_started': 'Başlayın',

    // Tutorial
    'tutorial': 'TUTORIAL',
    'skip': 'Atla',
    'next_step': 'Sonraki Adım',
    'previous_step': 'Önceki Adım',

    // Tutorial Adım 1
    'tutorial_step1_title': 'Instagram Ayarlarını Açın',
    'tutorial_step1_desc':
        'Aktivite ayarlarınıza gidin ve indirme talebinde bulunun. JSON formatını seçtiğinizden emin olun, HTML değil.',
    'tutorial_step1_highlight': 'JSON formatı seçin',

    // Tutorial Adım 2
    'tutorial_step2_title': 'JSON Formatını Seçin',
    'tutorial_step2_desc':
        'Uygulamamızın verilerinizi doğru işleyebilmesi için dosya formatı olarak JSON seçtiğinizden emin olun.',
    'tutorial_step2_highlight': 'JSON formatı zorunludur',

    // Tutorial Adım 3
    'tutorial_step3_title': 'Veri Aralığını Belirleyin',
    'tutorial_step3_desc':
        'İndirmek istediğiniz veri aralığını seçin. Daha kapsamlı analiz için "Tüm Zamanlar" seçeneğini öneririz.',
    'tutorial_step3_highlight': 'Tüm zamanlar önerilir',

    // Tutorial Adım 4
    'tutorial_step4_title': 'Dosyanızı İndirin',
    'tutorial_step4_desc':
        'Instagram verilerinizi hazırladığında size bildirim gönderecek. Dosyayı indirin ve bu uygulamaya yükleyin.',
    'tutorial_step4_highlight': 'E-posta ile bildirim alacaksınız',

    // Veri yükleme
    'upload_title': 'Instagram Verilerinizi Yükleyin',
    'upload_description': 'Instagram\'dan indirdiğiniz ZIP dosyasını seçin',
    'select_zip_file': 'ZIP Dosyası Seç',
    'how_to_download': 'Nasıl indirilir?',
    'processing': 'İşleniyor...',
    'upload_success': 'Veriler başarıyla yüklendi!',
    'upload_error': 'Veri yüklenirken hata oluştu',
    'secure_upload': 'Güvenli Yükleme',
    'upload_zip': 'ZIP Yükle',
    'drag_drop_or_tap': 'Sürükle bırak veya tıkla',
    'secure_environment': 'GÜVENLİ ORTAM',
    'local_processing_title': 'Sadece Yerel İşleme - Sunucuya Yükleme Yok',
    'local_processing_desc': 'Verileriniz asla cihazınızdan çıkmaz.',
    'supported_formats': 'Desteklenen formatlar: .zip, .rar, .7z',
    'select_file': 'Dosya Seç',

    // Dashboard
    'good_morning': 'Günaydın',
    'good_afternoon': 'İyi Günler',
    'good_evening': 'İyi Akşamlar',
    'dashboard': 'Panel',
    'home': 'Ana Sayfa',
    'reports': 'Raporlar',
    'alerts': 'Uyarılar',
    'settings': 'Ayarlar',

    // İstatistikler
    'high_priority': 'Yüksek Öncelik',
    'unfollowers': 'Takipten Çıkanlar',
    'unfollowers_desc': 'Bu hafta %count takipçi kaybettiniz.',
    'analyze_drop': 'Düşüşü Analiz Et',
    'ghost_followers': 'Hayalet Takipçiler',
    'inactive': 'İNAKTİF',
    'ghosts': 'Hayaletler',
    'active': 'Aktif',
    'activity_hours': 'Aktivite Saatleri',
    'peak_time': 'Zirve saati',
    'engagement_rate': 'Etkileşim Oranı',
    'total_reach': 'Toplam Erişim',
    'weekly_report': 'Haftalık Rapor',
    'ready_for_download': 'İndirmeye hazır',

    // Genel istatistikler
    'followers': 'Takipçiler',
    'following': 'Takip Edilenler',
    'posts': 'Gönderiler',
    'likes': 'Beğeniler',
    'comments': 'Yorumlar',
    'stories': 'Hikayeler',
    'messages': 'Mesajlar',

    // Analiz
    'analysis': 'Analiz',
    'top_interactions': 'En Çok Etkileşim',
    'activity_history': 'Aktivite Geçmişi',
    'monthly_stats': 'Aylık İstatistikler',
    'top_fans': 'En Sadık Takipçiler',
    'view_all': 'Tümünü Gör',
    'active_hour': 'AKTİF SAAT',
    'new_unfollowers': 'Yeni Takipten Çıkanlar',
    'since_yesterday': 'Dünden beri',
    'this_week': 'bu hafta',
    'urgent': 'ACİL',

    // Ayarlar
    'delete_data': 'Verileri Sil',
    'about': 'Hakkında',
    'version': 'Versiyon',
    'language': 'Dil',
    'theme': 'Tema',
    'dark_mode': 'Karanlık Mod',
    'light_mode': 'Açık Mod',

    // Hatalar
    'error_general': 'Bir hata oluştu',
    'error_invalid_file': 'Geçersiz dosya formatı',
    'error_no_data': 'Veri bulunamadı',

    // Butonlar
    'btn_continue': 'Devam Et',
    'btn_cancel': 'İptal',
    'btn_retry': 'Tekrar Dene',
    'btn_close': 'Kapat',

    // Günler
    'mon': 'Pzt',
    'tue': 'Sal',
    'wed': 'Çar',
    'thu': 'Per',
    'fri': 'Cum',
    'sat': 'Cmt',
    'sun': 'Paz',
  };

  // ==========================================
  // ENGLISH
  // ==========================================
  static const Map<String, String> _englishStrings = {
    // General
    'app_name': 'SocialSense',
    'app_slogan': 'Discover Your Instagram Insights',

    // Welcome screen
    'welcome_title': 'Welcome',
    'welcome_subtitle': 'Analyze your Instagram data and view your statistics',
    'get_started': 'Get Started',

    // Tutorial
    'tutorial': 'TUTORIAL',
    'skip': 'Skip',
    'next_step': 'Next Step',
    'previous_step': 'Previous Step',

    // Tutorial Step 1
    'tutorial_step1_title': 'Open Instagram Settings',
    'tutorial_step1_desc':
        'Navigate to your activity settings and request a download. Ensure you select the JSON format option, not HTML.',
    'tutorial_step1_highlight': 'Select JSON format',

    // Tutorial Step 2
    'tutorial_step2_title': 'Select JSON Format',
    'tutorial_step2_desc':
        'Make sure to select JSON as the file format so our app can process your data correctly.',
    'tutorial_step2_highlight': 'JSON format is required',

    // Tutorial Step 3
    'tutorial_step3_title': 'Select Date Range',
    'tutorial_step3_desc':
        'Choose the date range for your data. We recommend selecting "All Time" for comprehensive analysis.',
    'tutorial_step3_highlight': 'All time recommended',

    // Tutorial Step 4
    'tutorial_step4_title': 'Download Your File',
    'tutorial_step4_desc':
        'Instagram will notify you when your data is ready. Download the file and upload it to this app.',
    'tutorial_step4_highlight': 'You will receive an email notification',

    // Data upload
    'upload_title': 'Upload Your Instagram Data',
    'upload_description': 'Select the ZIP file you downloaded from Instagram',
    'select_zip_file': 'Select ZIP File',
    'how_to_download': 'How to download?',
    'processing': 'Processing...',
    'upload_success': 'Data uploaded successfully!',
    'upload_error': 'Error uploading data',
    'secure_upload': 'Secure Upload',
    'upload_zip': 'Upload ZIP',
    'drag_drop_or_tap': 'Drag & drop or tap',
    'secure_environment': 'SECURE ENVIRONMENT',
    'local_processing_title': 'Local Processing Only - No Server Upload',
    'local_processing_desc': 'Your data never leaves this device.',
    'supported_formats': 'Supported formats: .zip, .rar, .7z',
    'select_file': 'Select File',

    // Dashboard
    'good_morning': 'Good Morning',
    'good_afternoon': 'Good Afternoon',
    'good_evening': 'Good Evening',
    'dashboard': 'Dashboard',
    'home': 'Home',
    'reports': 'Reports',
    'alerts': 'Alerts',
    'settings': 'Settings',

    // Statistics
    'high_priority': 'High Priority',
    'unfollowers': 'Unfollowers',
    'unfollowers_desc': 'You lost %count followers this week.',
    'analyze_drop': 'Analyze Drop',
    'ghost_followers': 'Ghost Followers',
    'inactive': 'INACTIVE',
    'ghosts': 'Ghosts',
    'active': 'Active',
    'activity_hours': 'Activity Hours',
    'peak_time': 'Peak time',
    'engagement_rate': 'Engagement Rate',
    'total_reach': 'Total Reach',
    'weekly_report': 'Weekly Report',
    'ready_for_download': 'Ready for download',

    // General statistics
    'followers': 'Followers',
    'following': 'Following',
    'posts': 'Posts',
    'likes': 'Likes',
    'comments': 'Comments',
    'stories': 'Stories',
    'messages': 'Messages',

    // Analysis
    'analysis': 'Analysis',
    'top_interactions': 'Top Interactions',
    'activity_history': 'Activity History',
    'monthly_stats': 'Monthly Statistics',
    'top_fans': 'Top 3 Fans',
    'view_all': 'View All',
    'active_hour': 'ACTIVE HOUR',
    'new_unfollowers': 'New Unfollowers',
    'since_yesterday': 'Since yesterday',
    'this_week': 'this week',
    'urgent': 'URGENT',

    // Settings
    'delete_data': 'Delete Data',
    'about': 'About',
    'version': 'Version',
    'language': 'Language',
    'theme': 'Theme',
    'dark_mode': 'Dark Mode',
    'light_mode': 'Light Mode',

    // Errors
    'error_general': 'An error occurred',
    'error_invalid_file': 'Invalid file format',
    'error_no_data': 'No data found',

    // Buttons
    'btn_continue': 'Continue',
    'btn_cancel': 'Cancel',
    'btn_retry': 'Retry',
    'btn_close': 'Close',

    // Days
    'mon': 'Mon',
    'tue': 'Tue',
    'wed': 'Wed',
    'thu': 'Thu',
    'fri': 'Fri',
    'sat': 'Sat',
    'sun': 'Sun',
  };
}

/// Localization Delegate
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['tr', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
