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
    'tutorial_step1_title': 'Ayarlar > Hesaplar Merkezi',
    'tutorial_step1_desc':
        'Instagram Ayarlarına gidin > Hesaplar Merkezi > Bilgilerin ve izinlerin > Bilgilerini dışa aktar sayfasına tıklayın.',
    'tutorial_step1_highlight': 'Bilgilerini Dışa Aktar',

    // Tutorial Adım 2
    'tutorial_step2_title': 'Dışa Aktarım Oluşturun',
    'tutorial_step2_desc':
        '"Dışa aktarım oluştur" seçeneğine dokunun ve ardından "Cihaza aktar" seçeneğini seçin.',
    'tutorial_step2_highlight': 'Cihaza aktar',

    // Tutorial Adım 3
    'tutorial_step3_title': 'Format ve Aralık Seçimi',
    'tutorial_step3_desc':
        'Açılan sayfada:\n• Tüm mevcut bilgiler\n• Tarih aralığı: Her zaman\n• Format: JSON (ÖNEMLİ)',
    'tutorial_step3_highlight': 'JSON FORMATI ÖNEMLİ',

    // Tutorial Adım 4
    'tutorial_step4_title': 'İndir ve Yükle',
    'tutorial_step4_desc':
        'Instagram dosyanızı hazırladığında (e-posta ile bildirir), dosyayı indirin ve bu uygulamaya yükleyin.',
    'tutorial_step4_highlight': 'ZIP dosyasını yükleyin',

    // Veri yükleme
    'upload_title': 'Instagram Verilerinizi Yükleyin',
    'upload_description': 'Instagram\'dan indirdiğiniz ZIP dosyasını seçin',
    'select_zip_file': 'ZIP Dosyası Seç',
    'how_to_download': 'Nasıl indirilir?',
    'processing': 'İşleniyor...',
    'upload_success': 'Veriler başarıyla yüklendi!',
    'upload_error': 'Veri yüklenirken hata oluştu',
    'secure_upload': 'Güvenli Yükleme',
    'upload_zip_now': 'ZIP\'i Yükle',
    'drag_drop_or_tap': 'Sürükle bırak veya tıkla',
    'secure_environment': 'GÜVENLİ ORTAM',
    'local_processing_title': 'Sadece Yerel İşleme - Sunucuya Yükleme Yok',
    'local_processing_desc': 'Verileriniz asla cihazınızdan çıkmaz.',
    'supported_formats': 'Desteklenen formatlar: .zip, .rar, .7z',
    'select_file': 'Dosya Seç',
    'error_html_format':
        'Instagram verileriniz HTML formatında indirilmiş. Lütfen JSON formatında indirin.',
    'error_invalid_zip':
        'Bu ZIP dosyası Instagram verisi içermiyor. Lütfen doğru dosyayı seçin.',
    'error_generic': 'Bir hata oluştu. Lütfen tekrar deneyin.',

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
    'unfollowers': 'Seni Geri Takip Etmeyenler',
    'unfollowers_desc': 'Takip ettiğin %count kişi seni geri takip etmiyor.',
    'analyze_drop': 'Analiz Et',
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
    'activity_timeline': 'Aktivite Zaman Çizelgesi',
    'like_activity': 'Beğeni Aktivitesi',
    'comment_activity': 'Yorum Aktivitesi',
    'last_90_days': 'Son 90 gün',

    // Aktivite saati lakapları
    'early_bird': '🌅 Erken Kalkan Kuş',
    'morning_person': 'Sabah İnsanı',
    'lunch_break_scroller': 'Öğle Arası Gezgini',
    'afternoon_explorer': 'Öğleden Sonra Kaşifi',
    'evening_browser': 'Akşam Gezgini',
    'night_owl': '🦉 Gece Kuşu',
    'midnight_explorer': 'Gece Yarısı Kaşifi',

    // Analiz sayfası
    'unfollowers_this_week': 'Seni Geri Takip Etmeyen Kişiler',
    'drop_rate': 'Düşüş Oranı',
    'worst_day': 'En Kötü Gün',
    'daily_distribution': 'Günlük Dağılım',
    'recent_unfollowers': 'Geri Takip Etmeyenler',
    'total': 'toplam',
    'all_time': 'Tüm Zamanlar',

    // Güncelleme dialog
    'update_data_title': 'Verileri Güncelle',
    'update_data_message': 'Verilerinizi güncellemek mi istiyorsunuz?',
    'yes': 'Evet',
    'no': 'Hayır',
    'last_update': 'Son güncelleme',

    // Ayarlar
    'delete_data': 'Verileri Sil',
    'about': 'Hakkında',
    'version': 'Versiyon',
    'language': 'Dil',
    'theme': 'Tema',
    'dark_mode': 'Karanlık Mod',
    'light_mode': 'Açık Mod',
    'appearance': 'Görünüm',
    'data_management': 'Veri Yönetimi',
    'reload_data': 'Veriyi Yeniden Yükle',
    'clear_cache': 'Önbelleği Temizle',
    'default_view': 'Varsayılan Görünüm',
    'help': 'Yardım',
    'faq': 'Sıkça Sorulan Sorular',
    'contact': 'İletişim',
    'privacy_policy': 'Gizlilik Politikası',
    'terms_of_use': 'Kullanım Koşulları',
    'rate_app': 'Uygulamayı Değerlendir',
    'share_app': 'Uygulamayı Paylaş',
    'turkish': 'Türkçe',
    'english': 'English',
    'system_default': 'Sistem Varsayılanı',
    'confirm_delete': 'Silmek istediğinize emin misiniz?',
    'data_deleted': 'Veriler silindi',
    'cache_cleared': 'Önbellek temizlendi',

    // Uyarılar
    'no_alerts': 'Henüz uyarı yok',
    'no_alerts_desc':
        'Hesabınızda önemli değişiklikler olduğunda burada göreceksiniz',
    'follower_drop_alert': 'Takipçi Düşüşü',
    'follower_drop_desc': 'Son 7 günde takipçi kaybettiniz',
    'ghost_follower_alert': 'Hayalet Takipçi Uyarısı',
    'ghost_follower_desc': 'Hayalet takipçi oranınız yüksek',
    'engagement_drop_alert': 'Etkileşim Düşüşü',
    'engagement_drop_desc': 'Etkileşim oranınız düştü',
    'active_hour_changed': 'Aktif Saat Değişti',
    'active_hour_changed_desc': 'Takipçileriniz artık farklı saatlerde aktif',
    'new_unfollowers_alert': 'Yeni Takipten Çıkanlar',
    'new_unfollowers_desc': 'kişi sizi takipten çıktı',
    'tip_alert': 'İpucu',
    'tip_post_time': 'Paylaşım saatinizi değiştirmeyi deneyin',
    'tip_engagement': 'Hikaye paylaşarak etkileşimi artırın',
    'mark_as_read': 'Okundu İşaretle',
    'clear_all': 'Tümünü Temizle',
    'today': 'Bugün',
    'yesterday': 'Dün',
    'this_week_alerts': 'Bu Hafta',

    // Hatalar
    'error_general': 'Bir hata oluştu',
    'error_invalid_file': 'Geçersiz dosya formatı',
    'error_no_data': 'Veri bulunamadı',
    'no_data_available': 'Veri yok',

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
    'chats': 'sohbet',
    'direct_messages': 'Direkt Mesajlar',
    'reels_interactions': 'Reels Etkileşimleri',
    'sent_by_you': 'Senin Attıkların',
    'received_by_you': 'Sana Gelenler',
    'total_sent': 'Toplam Giden',
    'total_received': 'Toplam Gelen',
    'no_data': 'Veri yok',
    'see_all': 'Tümü',
    'pending_follow_requests_title': 'Bekleyen Takip İstekleri',
    'pending_follow_requests_desc': 'kişi takip isteğinizi henüz kabul etmedi',
    'most_messaged_sent': 'En Çok Mesaj Attıkların',
    'most_messaged_received': 'Sana En Çok Mesaj Atanlar',
    'most_reels_sent': 'En Çok Reels Gönderdiklerin',
    'most_reels_received': 'Sana En Çok Reels Gönderenler',
    'reels_stats_subtitle': 'Reels paylaşım istatistikleri',

    // İletişim & Yardım
    'get_in_touch': 'İletişime Geçin',
    'contact_desc':
        'Sorularınız veya geri bildirimleriniz varsa lütfen bize mesaj gönderin.',
    'email': 'E-posta',
    'website': 'Web sitesi',
    'instagram': 'Instagram',

    // SSS (FAQ)
    'faq_q1': 'Verilerim güvende mi?',
    'faq_a1':
        'Evet, SocialSense verilerinizi sadece cihazınızda yerel olarak işler. Hiçbir veriniz sunucularımıza yüklenmez veya üçüncü taraflarla paylaşılmaz.',
    'faq_q2': 'Verilerimi nasıl yüklerim?',
    'faq_a2':
        'Instagram ayarlarından "Bilgilerini İndir" seçeneği ile verilerinizi JSON formatında indirin, ardından uygulamanın "Veri Yükle" bölümünden ZIP dosyasını seçin.',
    'faq_q3': 'Hayalet Takipçi nedir?',
    'faq_a3':
        'Sizi takip eden ancak gönderilerinizi beğenmeyen veya yorum yapmayan kullanıcılardır.',
    'faq_q4': 'Analizler ne kadar doğru?',
    'faq_a4':
        'Analizler resmi Instagram verilerine dayandığı için %100 doğrudur.',
    'faq_q5': 'Uygulama ücretli mi?',
    'faq_a5': 'Şu anda tamamen ücretsizdir.',

    // Yasal
    'legal_disclaimer_title': 'Sorumluluk Reddi',
    'privacy_policy_content': '''
**Gizlilik Politikası**

**1. Veri Toplama ve Kullanım**
SocialSense, kişisel verilerinizi sunucularında toplamaz, saklamaz veya üçüncü taraflarla paylaşmaz. Uygulamaya yüklediğiniz Instagram verileri (ZIP dosyası), tamamen kendi cihazınızda (yerel olarak) işlenir ve analiz edilir.

**2. Veri Güvenliği**
Tüm analiz işlemleri çevrimdışı olarak telefonunuzda gerçekleşir. Verileriniz hiçbir şekilde internet üzerinden dışarıya aktarılmaz. Bu nedenle verilerinizin güvenliği ve gizliliği tam kontrolünüz altındadır.

**3. Sorumluluk Reddi**
Bu uygulamanın geliştiricisi, kullanıcı verilerine erişemez ve bu verilerin güvenliğinden sorumlu tutulamaz. Cihazınızın güvenliği ve verilerinizin korunması tamamen kullanıcının sorumluluğundadır.

**4. Değişiklikler**
Bu gizlilik politikası zaman zaman güncellenebilir. Değişiklikler bu sayfada yayınlanacaktır.

**Son Güncelleme:** Ocak 2026
''',
    'terms_of_use_content': '''
**Kullanım Koşulları**

**1. Kabul**
Bu uygulamayı indirerek ve kullanarak, aşağıdaki koşulları kabul etmiş sayılırsınız.

**2. Instagram ile Bağlantı**
SocialSense, Instagram veya Meta ile hiçbir şekilde bağlantılı değildir, onlar tarafından desteklenmemekte veya onaylanmamaktadır. Bu uygulama, kullanıcıların kendi verilerini analiz etmelerine yardımcı olan bağımsız bir araçtır.

**3. Sorumluluk Reddi**
Uygulamanın kullanımından doğabilecek her türlü risk kullanıcıya aittir. Geliştirici, bu uygulamanın kullanımı sonucunda oluşabilecek veri kaybı, hesap kısıtlaması veya diğer olumsuz durumlardan sorumlu tutulamaz.

**4. "Olduğu Gibi" Sunum**
Bu uygulama "olduğu gibi" sunulmaktadır. Geliştirici, uygulamanın hatasız olacağını veya sürekli çalışacağını garanti etmez.

**5. Kullanım Hakkı**
Uygulama sadece kişisel kullanım içindir. Uygulamanın kodlarını kopyalamak, değiştirmek veya dağıtmak yasaktır.

**Son Güncelleme:** Ocak 2026
''',
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
    'tutorial_step1_title': 'Settings > Accounts Center',
    'tutorial_step1_desc':
        'Go to Settings > Accounts Center > Your Information and Permissions > Export your information.',
    'tutorial_step1_highlight': 'Export Your Information',

    // Tutorial Step 2
    'tutorial_step2_title': 'Create & Transfer',
    'tutorial_step2_desc':
        'Tap "Create export", then select "Export to device".',
    'tutorial_step2_highlight': 'Export to Device',

    // Tutorial Step 3
    'tutorial_step3_title': 'Select Format & Range',
    'tutorial_step3_desc':
        'On the next page:\n• All available information\n• Date range: All time\n• Format: JSON (IMPORTANT)',
    'tutorial_step3_highlight': 'JSON FORMAT IS IMPORTANT',

    // Tutorial Step 4
    'tutorial_step4_title': 'Download & Upload',
    'tutorial_step4_desc':
        'When Instagram notifies you (via email), download the file and upload it to this app.',
    'tutorial_step4_highlight': 'Upload ZIP File',

    // Data upload
    'upload_title': 'Upload Your Instagram Data',
    'upload_description': 'Select the ZIP file you downloaded from Instagram',
    'select_zip_file': 'Select ZIP File',
    'how_to_download': 'How to download?',
    'processing': 'Processing...',
    'upload_success': 'Data uploaded successfully!',
    'upload_error': 'Error uploading data',
    'secure_upload': 'Secure Upload',
    'upload_zip_now': 'Upload ZIP',
    'drag_drop_or_tap': 'Drag & drop or tap',
    'secure_environment': 'SECURE ENVIRONMENT',
    'local_processing_title': 'Local Processing Only - No Server Upload',
    'local_processing_desc': 'Your data never leaves this device.',
    'supported_formats': 'Supported formats: .zip, .rar, .7z',
    'select_file': 'Select File',
    'error_html_format':
        'Your Instagram data was downloaded in HTML format. Please download in JSON format.',
    'error_invalid_zip':
        'This ZIP file does not contain Instagram data. Please select the correct file.',
    'error_generic': 'An error occurred. Please try again.',

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
    'unfollowers': 'Not Following Back',
    'unfollowers_desc': '%count people you follow are not following you back.',
    'analyze_drop': 'Analyze',
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
    'activity_timeline': 'Activity Timeline',
    'like_activity': 'Like Activity',
    'comment_activity': 'Comment Activity',
    'last_90_days': 'Last 90 days',

    // Activity hour nicknames
    'early_bird': '🌅 Early Bird',
    'morning_person': 'Morning Person',
    'lunch_break_scroller': 'Lunch Break Scroller',
    'afternoon_explorer': 'Afternoon Explorer',
    'evening_browser': 'Evening Browser',
    'night_owl': '🦉 Night Owl',
    'midnight_explorer': 'Midnight Explorer',

    // Analyze page
    'unfollowers_this_week': 'People Not Following You Back',
    'drop_rate': 'Drop Rate',
    'worst_day': 'Worst Day',
    'daily_distribution': 'Daily Distribution',
    'recent_unfollowers': 'Not Following Back',
    'total': 'total',
    'all_time': 'All Time',

    // Update dialog
    'update_data_title': 'Update Data',
    'update_data_message': 'Do you want to update your data?',
    'yes': 'Yes',
    'no': 'No',
    'last_update': 'Last update',

    // Settings
    'delete_data': 'Delete Data',
    'about': 'About',
    'version': 'Version',
    'language': 'Language',
    'theme': 'Theme',
    'dark_mode': 'Dark Mode',
    'light_mode': 'Light Mode',
    'appearance': 'Appearance',
    'data_management': 'Data Management',
    'reload_data': 'Reload Data',
    'clear_cache': 'Clear Cache',
    'default_view': 'Default View',
    'help': 'Help',
    'faq': 'FAQ',
    'contact': 'Contact',
    'privacy_policy': 'Privacy Policy',
    'terms_of_use': 'Terms of Use',
    'rate_app': 'Rate App',
    'share_app': 'Share App',
    'turkish': 'Türkçe',
    'english': 'English',
    'system_default': 'System Default',
    'confirm_delete': 'Are you sure you want to delete?',
    'data_deleted': 'Data deleted',
    'cache_cleared': 'Cache cleared',

    // Alerts
    'no_alerts': 'No alerts yet',
    'no_alerts_desc': 'You will see important changes to your account here',
    'follower_drop_alert': 'Follower Drop',
    'follower_drop_desc': 'You lost followers in the last 7 days',
    'ghost_follower_alert': 'Ghost Follower Alert',
    'ghost_follower_desc': 'Your ghost follower rate is high',
    'engagement_drop_alert': 'Engagement Drop',
    'engagement_drop_desc': 'Your engagement rate has dropped',
    'active_hour_changed': 'Active Hour Changed',
    'active_hour_changed_desc':
        'Your followers are now active at different times',
    'new_unfollowers_alert': 'New Unfollowers',
    'new_unfollowers_desc': 'people unfollowed you',
    'tip_alert': 'Tip',
    'tip_post_time': 'Try changing your posting time',
    'tip_engagement': 'Increase engagement by sharing stories',
    'mark_as_read': 'Mark as Read',
    'clear_all': 'Clear All',
    'today': 'Today',
    'yesterday': 'Yesterday',
    'this_week_alerts': 'This Week',

    // Errors
    'error_general': 'An error occurred',
    'error_invalid_file': 'Invalid file format',
    'error_no_data': 'No data found',
    'no_data_available':
        'No data available. Please upload your Instagram data first.',

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
    'chats': 'chats',
    'direct_messages': 'Direct Messages',
    'reels_interactions': 'Reels Interactions',
    'sent_by_you': 'Sent by You',
    'received_by_you': 'Received by You',
    'total_sent': 'Total Sent',
    'total_received': 'Total Received',
    'no_data': 'No data',
    'see_all': 'All',
    'pending_follow_requests_title': 'Pending Follow Requests',
    'pending_follow_requests_desc':
        'people haven\'t accepted your follow request yet',
    'most_messaged_sent': 'Most Messaged (Sent)',
    'most_messaged_received': 'Most Messaged (Received)',
    'most_reels_sent': 'Top Reels Sent',
    'most_reels_received': 'Top Reels Received',
    'reels_stats_subtitle': 'Reels sharing statistics',

    // Contact & Help
    'get_in_touch': 'Get in Touch',
    'contact_desc':
        'If you have any questions or feedback, please send us a message.',
    'email': 'Email',
    'website': 'Website',
    'instagram': 'Instagram',

    // FAQ
    'faq_q1': 'Is my data safe?',
    'faq_a1':
        'Yes, SocialSense processes your data locally on your device only. None of your data is uploaded to our servers or shared with third parties.',
    'faq_q2': 'How do I upload my data?',
    'faq_a2':
        'Download your data in JSON format from Instagram settings ("Download Your Information"), then select the ZIP file in the app\'s "Upload Data" section.',
    'faq_q3': 'What are Ghost Followers?',
    'faq_a3': 'Users who follow you but do not like or comment on your posts.',
    'faq_q4': 'How accurate is the analysis?',
    'faq_a4':
        'The analysis is 100% accurate as it is based on official Instagram data.',
    'faq_q5': 'Is the app free?',
    'faq_a5': 'It is currently completely free.',

    // Legal
    'legal_disclaimer_title': 'Disclaimer',
    'privacy_policy_content': '''
**Privacy Policy**

**1. Data Collection and Usage**
SocialSense does not collect, store, or share your personal data on its servers. The Instagram data (ZIP file) you upload to the app is processed and analyzed entirely locally on your device.

**2. Data Security**
All analysis operations occur offline on your phone. Your data is never transferred externally over the internet. Therefore, the security and privacy of your data are under your full control.

**3. Disclaimer**
The developer of this application has no access to user data and cannot be held responsible for the security of this data. The security of your device and the protection of your data are entirely the user's responsibility.

**4. Changes**
This privacy policy may be updated from time to time. Changes will be posted on this page.

**Last Updated:** January 2026
''',
    'terms_of_use_content': '''
**Terms of Use**

**1. Acceptance**
By downloading and using this application, you agree to the following terms.

**2. Affiliation with Instagram**
SocialSense is in no way affiliated with, supported by, or endorsed by Instagram or Meta. This application is an independent tool that helps users analyze their own data.

**3. Disclaimer**
Any risk arising from the use of the application belongs to the user. The developer cannot be held responsible for data loss, account restriction, or other negative situations that may occur as a result of using this application.

**4. "As Is" Presentation**
This application is provided "as is". The developer does not guarantee that the application will be error-free or operate continuously.

**5. Right of Use**
The application is for personal use only. Copying, modifying, or distributing the application's codes is prohibited.

**Last Updated:** January 2026
''',
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
