import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/instagram_data.dart';
import '../services/instagram_data_parser.dart';

/// Instagram verilerini yöneten provider
/// Verileri parse eder, saklar ve uygulamaya sunar
class InstagramDataProvider extends ChangeNotifier {
  InstagramData? _data;
  bool _isLoading = false;
  String? _error;
  DateTime? _lastUpdateDate;

  /// Mevcut veri
  InstagramData? get data => _data;

  /// Yükleme durumu
  bool get isLoading => _isLoading;

  /// Hata mesajı
  String? get error => _error;

  /// Son güncelleme tarihi
  DateTime? get lastUpdateDate => _lastUpdateDate;

  /// Veri var mı kontrolü
  bool get hasData => _data != null && _data!.hasData;

  /// ZIP dosyasından veri yükle
  Future<bool> loadFromZipFile(File zipFile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('🔄 ZIP dosyası yükleniyor: ${zipFile.path}');
      _data = await InstagramDataParser.parseZipFile(zipFile);

      // Dosya adından kullanıcı adını çıkarmaya çalış
      try {
        final filename = zipFile.uri.pathSegments.last;
        final lowerName = filename.toLowerCase();
        // instagram_kullaniciadi... veya instagram-kullaniciadi... formatı
        if (lowerName.startsWith('instagram_') ||
            lowerName.startsWith('instagram-')) {
          // 'instagram_' veya 'instagram-' (10 karakter)
          String rawName = filename.substring(10);

          // Eğer _ tarih vs varsa onlardan öncesini al, yoksa .zip'ten öncesini al
          if (rawName.contains('_')) {
            rawName = rawName.split('_').first;
          } else if (rawName.contains('-')) {
            // Hyphen case
            rawName = rawName.split('-').first;
          } else if (rawName.contains('.')) {
            rawName = rawName.split('.').first;
          }

          if (rawName.isNotEmpty && _data != null) {
            // Eğer parser zaten bulduysa onu ezme (veya boşsa yaz)
            if (_data!.username == null || _data!.username!.isEmpty) {
              _data = _data!.copyWith(username: rawName);
              debugPrint('👤 Kullanıcı adı dosyadan alındı: $rawName');
            }
          }
        }
      } catch (e) {
        debugPrint('⚠️ Kullanıcı adı çıkarma hatası: $e');
      }

      _lastUpdateDate = DateTime.now();

      // Debug log
      debugPrint('✅ Parse başarılı!');
      debugPrint('📊 Takipçi: ${_data?.followers.length ?? 0}');
      debugPrint('📊 Takip edilen: ${_data?.following.length ?? 0}');
      debugPrint('📊 Beğeni: ${_data?.likes.length ?? 0}');
      debugPrint('📊 Yorum: ${_data?.comments.length ?? 0}');
      debugPrint('📊 hasData: ${_data?.hasData}');

      // Başarılı yükleme tarihini kaydet
      await _saveLastUpdateDate();
      await saveData();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ Parse hatası: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Web için bytes'tan veri yükle
  Future<bool> loadFromBytes(Uint8List bytes) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _data = await InstagramDataParser.parseZipBytes(bytes);
      _lastUpdateDate = DateTime.now();

      await _saveLastUpdateDate();
      await saveData();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Verileri temizle
  Future<void> clearData() async {
    _data = null;
    _lastUpdateDate = null;
    _error = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('last_update_date');

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/instagram_data.json');
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}

    notifyListeners();
  }

  Future<void> saveData() async {
    if (_data == null) return;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/instagram_data.json');
      final jsonStr = jsonEncode(_data!.toMap());
      await file.writeAsString(jsonStr);
      debugPrint('✅ Veriler diske kaydedildi.');
    } catch (e) {
      debugPrint('❌ Kaydetme hatası: $e');
    }
  }

  Future<bool> loadFromDisk() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/instagram_data.json');
      if (await file.exists()) {
        _isLoading = true;
        notifyListeners();

        final jsonStr = await file.readAsString();
        final map = jsonDecode(jsonStr);
        _data = InstagramData.fromMap(map);

        // Tarihi güncelle
        await loadLastUpdateDate();

        _isLoading = false;
        notifyListeners();
        debugPrint('✅ Veriler diskten yüklendi.');
        return true;
      }
    } catch (e) {
      debugPrint('❌ Diskten yükleme hatası: $e');
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  /// Son güncelleme tarihini kaydet
  Future<void> _saveLastUpdateDate() async {
    if (_lastUpdateDate == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'last_update_date',
      _lastUpdateDate!.toIso8601String(),
    );
  }

  /// Son güncelleme tarihini yükle
  Future<void> loadLastUpdateDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString('last_update_date');
    if (dateStr != null) {
      _lastUpdateDate = DateTime.tryParse(dateStr);
      notifyListeners();
    }
  }

  // ==================== HESAPLANMIŞ ÖZELLİKLER ====================

  /// Kullanıcı adı
  String? get username => _data?.username;

  /// Takipçi sayısı
  int get followersCount => _data?.followers.length ?? 0;

  /// Takip edilen sayısı
  int get followingCount => _data?.following.length ?? 0;

  /// Toplam beğeni sayısı
  int get totalLikesCount => _data?.likes.length ?? 0;

  /// Toplam yorum sayısı
  int get totalCommentsCount => _data?.comments.length ?? 0;

  /// Karşılıklı takipleşenler
  List<String> get mutualFollowers => _data?.mutualFollowers ?? [];

  /// Sizi takip etmeyenler
  List<String> get notFollowingBack => _data?.notFollowingBack ?? [];

  /// Ghost follower listesi
  List<String> get ghostFollowersList => _data?.ghostFollowersList ?? [];

  /// Sizin takip etmedikleriniz
  List<String> get youDontFollow => _data?.youDontFollow ?? [];

  /// Ghost follower sayısı
  int get ghostFollowersCount => _data?.estimatedGhostFollowers ?? 0;

  /// Ghost follower yüzdesi
  double get ghostFollowerPercentage => _data?.ghostFollowerPercentage ?? 0.0;

  /// Engagement rate
  double get engagementRate => _data?.estimatedEngagementRate ?? 0.0;

  /// En aktif saat
  int get mostActiveHour => _data?.mostActiveHour ?? 12;

  /// Saatlik aktivite
  Map<int, int> get hourlyActivity => _data?.hourlyLikeActivity ?? {};

  /// Haftalık aktivite
  Map<int, int> get weekdayActivity => _data?.weekdayActivity ?? {};

  /// Aylık beğeni aktivitesi
  List<Map<String, dynamic>> get monthlyLikeActivity =>
      _data?.monthlyLikeActivity ?? [];

  /// En çok beğenilen hesaplar
  Map<String, int> get topLikedAccounts => _data?.topLikedAccounts ?? {};

  /// En çok yorum yapılan hesaplar
  Map<String, int> get topCommentedAccounts =>
      _data?.topCommentedAccounts ?? {};

  /// En çok kaydedilen hesaplar
  Map<String, int> get topSavedAccounts => _data?.topSavedAccounts ?? {};

  /// En çok mesajlaşılan kişiler
  List<InstagramMessage> get topMessagedUsers => _data?.topMessagedUsers ?? [];

  /// Toplam mesaj sayısı
  int get totalMessageCount => _data?.totalMessageCount ?? 0;

  /// Toplam konuşma sayısı
  int get totalConversationCount => _data?.totalConversationCount ?? 0;

  /// İlgi alanları
  List<InstagramInterest> get interests => _data?.interests ?? [];

  /// Zaman dağılımı
  Map<String, double> get timeDistribution => _data?.timeDistribution ?? {};

  /// Haftalık dağılım (Weekday vs Weekend)
  Map<String, double> get weekDistribution => _data?.weekDistribution ?? {};

  /// Kategorize edilmiş ilgi alanları
  Map<String, List<String>> get categorizedInterests =>
      _data?.categorizedInterests ?? {};

  /// Hikaye beğenileri
  Map<String, int> get topStoryLikedAccounts =>
      _data?.topStoryLikedAccounts ?? {};

  /// Yakın arkadaşlar
  List<String> get closeFriends => _data?.closeFriends ?? [];

  /// Kayıtlı gönderiler listesi
  List<InstagramSavedItem> get savedItems => _data?.savedItems ?? [];

  /// Reels Gönderilenler
  Map<String, int> get topReelsSent => _data?.topReelsSent ?? {};

  /// Reels Alınanlar
  Map<String, int> get topReelsReceived => _data?.topReelsReceived ?? {};

  /// Takip edilenler
  List<InstagramUser> get following => _data?.following ?? [];

  /// Mesaj Gönderilenler
  Map<String, int> get msgSentMap => _data?.msgSentMap ?? {};

  /// Mesaj Alınanlar
  Map<String, int> get msgReceivedMap => _data?.msgReceivedMap ?? {};

  /// Bekleyen İstekler
  List<String> get pendingRequests => _data?.pendingRequests ?? [];
  List<String> get receivedRequests => _data?.receivedRequests ?? [];
  String? get fullName => _data?.fullName;
}
