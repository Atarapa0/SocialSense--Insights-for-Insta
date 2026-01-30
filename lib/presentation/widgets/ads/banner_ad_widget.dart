import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:socialsense/core/constants/ad_ids.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  // Reklam birimi bir kere yüklensin diye flag
  bool _adLoadAttempted = false;

  final String _adUnitId = Platform.isAndroid
      ? AdIds.bannerAndroid
      : AdIds.bannerIOS;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Context artık erişilebilir, ekran genişliğini alıp reklamı yükle
    if (!_adLoadAttempted) {
      _adLoadAttempted = true;
      _loadAd();
    }
  }

  Future<void> _loadAd() async {
    // Ekran genişliğini al
    final size = MediaQuery.of(context).size;
    // Kenar boşluklarını düş (padding varsa) - genellikle tam genişlik istenir ama safe area vs olabilir
    // Şimdilik truncate ile tam genişlik alıyoruz.
    final int width = size.width.truncate();

    // Adaptive Banner boyutu al
    final AdSize? adSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);

    if (adSize == null) {
      debugPrint('Adaptive Banner boyutu alınamadı.');
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: adSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('BannerAd loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink(); // Yüklenmezse yer kaplamasın
    }

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
