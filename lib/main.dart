import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:socialsense/core/localization/app_localizations.dart';
import 'package:socialsense/core/theme/app_theme.dart';
import 'package:socialsense/core/providers/instagram_data_provider.dart';
import 'package:socialsense/presentation/providers/app_settings_provider.dart';
import 'package:socialsense/presentation/providers/alerts_provider.dart';
import 'package:socialsense/presentation/screens/splash/splash_screen.dart';
import 'package:socialsense/core/services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Reklam servisini başlat
  final adService = AdService();
  await adService.initialize();
  // App Open reklamını önceden yükle
  adService.loadAppOpenAd();

  // Ayarları yükle
  final settingsProvider = AppSettingsProvider();
  await settingsProvider.loadSettings();

  // Instagram veri provider'ı
  final dataProvider = InstagramDataProvider();
  // Veriyi Splash Screen'de diskten yükleyeceğiz

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: dataProvider),
        ChangeNotifierProvider(create: (_) => AlertsProvider()),
      ],
      child: const SocialSenseApp(),
    ),
  );
}

/// Ana uygulama widget'ı
class SocialSenseApp extends StatefulWidget {
  const SocialSenseApp({super.key});

  @override
  State<SocialSenseApp> createState() => _SocialSenseAppState();
}

class _SocialSenseAppState extends State<SocialSenseApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Uygulama tekrar açıldığında (resume olduğunda) reklam göster
      AdService().showAppOpenAdIfAvailable();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: 'SocialSense',
          debugShowCheckedModeBanner: false,

          // Tema ayarları
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,

          // Dil ayarları
          locale: settings.locale,
          supportedLocales: const [
            Locale('tr'), // Türkçe
            Locale('en'), // İngilizce
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // Başlangıç ekranı (Splash Screen)
          home: const SplashScreen(),
        );
      },
    );
  }
}
