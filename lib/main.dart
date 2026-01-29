import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:socialsense/core/localization/app_localizations.dart';
import 'package:socialsense/core/theme/app_theme.dart';
import 'package:socialsense/core/providers/instagram_data_provider.dart';
import 'package:socialsense/presentation/providers/app_settings_provider.dart';
import 'package:socialsense/presentation/providers/alerts_provider.dart';
import 'package:socialsense/presentation/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
class SocialSenseApp extends StatelessWidget {
  const SocialSenseApp({super.key});

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
