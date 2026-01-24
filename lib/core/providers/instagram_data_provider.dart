import 'dart:io';
import 'package:flutter/foundation.dart';
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
      _data = await InstagramDataParser.parseZipFile(zipFile);
      _lastUpdateDate = DateTime.now();

      // Başarılı yükleme tarihini kaydet
      await _saveLastUpdateDate();

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

  /// Web için bytes'tan veri yükle
  Future<bool> loadFromBytes(Uint8List bytes) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _data = await InstagramDataParser.parseZipBytes(bytes);
      _lastUpdateDate = DateTime.now();

      await _saveLastUpdateDate();

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
    await prefs.remove('cached_data');

    notifyListeners();
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

  /// En çok beğenilen hesaplar
  Map<String, int> get topLikedAccounts => _data?.topLikedAccounts ?? {};

  /// En çok yorum yapılan hesaplar
  Map<String, int> get topCommentedAccounts =>
      _data?.topCommentedAccounts ?? {};

  /// En çok kaydedilen hesaplar
  Map<String, int> get topSavedAccounts => _data?.topSavedAccounts ?? {};
}
