import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialsense/core/constants/ad_ids.dart';

class AdService {
  static final AdService _instance = AdService._internal();

  factory AdService() {
    return _instance;
  }

  AdService._internal();

  InterstitialAd? _interstitialAd;
  AppOpenAd? _appOpenAd;
  bool _isInterstitialLoading = false;
  bool _isAppOpenLoading = false;
  bool _isShowingAd = false;

  bool get isAppOpenAdAvailable => _appOpenAd != null;

  // Ad Unit IDs (AdIds dosyasından alınıyor)
  final String _androidInterstitialId = AdIds.interstitialAndroid;
  final String _iosInterstitialId = AdIds.interstitialIOS;
  final String _androidAppOpenId = AdIds.appOpenAndroid;
  final String _iosAppOpenId = AdIds.appOpenIOS;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    _loadInterstitialAd();
  }

  // ==========================================
  // INTERSTITIAL AD (Zip yükleme sırasında)
  // ==========================================
  void _loadInterstitialAd() {
    if (_isInterstitialLoading || _interstitialAd != null) return;

    _isInterstitialLoading = true;
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? _androidInterstitialId
          : _iosInterstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('InterstitialAd yüklendi');
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                  _interstitialAd = null;
                  _loadInterstitialAd(); // Sonraki için yeniden yükle
                },
                onAdFailedToShowFullScreenContent: (ad, error) {
                  ad.dispose();
                  _interstitialAd = null;
                  _loadInterstitialAd();
                },
              );
        },
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd yüklenemedi: $error');
          _isInterstitialLoading = false;
          _interstitialAd = null;
          // Hata durumunda yeniden denemek için beklenebilir, şimdilik geçiyoruz
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onAdClosed}) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          _loadInterstitialAd();
          if (onAdClosed != null) onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          _loadInterstitialAd();
          if (onAdClosed != null) onAdClosed();
        },
      );
      _interstitialAd!.show();
    } else {
      debugPrint('Reklam hazır değil, işlem devam ediyor.');
      _loadInterstitialAd();
      if (onAdClosed != null) onAdClosed();
    }
  }

  // ==========================================
  // APP OPEN AD (Uygulama açılışında)
  // ==========================================
  void loadAppOpenAd() {
    if (_isAppOpenLoading || _appOpenAd != null) return;

    _isAppOpenLoading = true;
    final adUnitId = Platform.isAndroid ? _androidAppOpenId : _iosAppOpenId;
    debugPrint('AppOpenAd Yükleniyor ID: $adUnitId');

    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AppOpenAd yüklendi');
          _appOpenAd = ad;
          _isAppOpenLoading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd yüklenemedi: $error');
          _isAppOpenLoading = false;
          _appOpenAd = null;
        },
      ),
    );
  }

  Future<void> showAppOpenAdIfAvailable() async {
    // Sadece ZIP yüklenmişse reklam göster
    final prefs = await SharedPreferences.getInstance();
    final hasUploadedZip = prefs.getBool('has_uploaded_zip') ?? false;

    if (!hasUploadedZip) {
      debugPrint('Daha önce ZIP yüklenmemiş, açılış reklamı gösterilmiyor.');
      return;
    }

    if (_appOpenAd == null) {
      debugPrint('App Open Ad hazır değil, yükleniyor.');
      loadAppOpenAd();
      return;
    }

    if (_isShowingAd) {
      debugPrint('Zaten bir reklam gösteriliyor.');
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd(); // Sonraki açılış için
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
    );

    _appOpenAd!.show();
  }
}
