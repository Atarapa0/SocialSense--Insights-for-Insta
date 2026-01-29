import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';
import 'package:socialsense/core/localization/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    // Privacy Policy Content
    const content = '''
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
''';

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.get('privacy_policy') == 'privacy_policy'
              ? 'Privacy Policy'
              : l10n.get('privacy_policy'), // Fallback if key missing
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last Updated: January 2026',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
