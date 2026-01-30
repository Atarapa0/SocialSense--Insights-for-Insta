import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialsense/core/providers/instagram_data_provider.dart';
import 'package:socialsense/core/services/ad_service.dart';
import 'package:socialsense/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:socialsense/presentation/screens/welcome/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkData();
  }

  Future<void> _checkData() async {
    // 1 saniye bekle (logo görünsün/provider init olsun)
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    final provider = context.read<InstagramDataProvider>();
    final hasData = await provider.loadFromDisk();

    // Cold Start Reklam Kontrolü
    // Eğer veri varsa (veya zip yüklenmişse) reklamı göstermeye çalış
    if (hasData) {
      // Reklam servisinin reklamı yüklemesi için kısa bir süre tanı
      // Gerçek bir "wait for load" mantığı daha sağlam olurdu ama
      // şimdilik basit bir retry mekanizması ekleyelim.
      bool adShown = false;
      for (int i = 0; i < 3; i++) {
        if (AdService().isAppOpenAdAvailable) {
          AdService().showAppOpenAdIfAvailable();
          adShown = true;
          break;
        }
        await Future.delayed(const Duration(milliseconds: 500));
      }

      if (!adShown) {
        // Reklam gösterilemediyse yine de dene (belki o sırada yüklenmiştir)
        AdService().showAppOpenAdIfAvailable();
      }
    }

    if (!mounted) return;

    if (hasData) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/logo/socialsense_logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
