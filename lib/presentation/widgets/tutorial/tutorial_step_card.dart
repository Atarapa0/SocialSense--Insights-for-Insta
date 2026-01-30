import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';
import 'package:socialsense/core/localization/app_localizations.dart';
import 'package:socialsense/presentation/screens/tutorial/tutorial_screen.dart';

/// Tutorial adım kartı
/// Resim, başlık, açıklama ve highlight içerir
class TutorialStepCard extends StatelessWidget {
  final TutorialStep step;
  final int stepNumber;
  final int totalSteps;

  const TutorialStepCard({
    super.key,
    required this.step,
    required this.stepNumber,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // Resim alanı (placeholder - sonra doldurulacak)
          _buildImageSection(isDark, l10n.locale.languageCode),

          const SizedBox(height: 32),

          // Başlık
          Text(
            l10n.get(step.titleKey),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Açıklama
          Text(
            l10n.get(step.descriptionKey),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          // Highlight (varsa)
          if (step.highlightKey != null) ...[
            const SizedBox(height: 8),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: l10n.get(step.highlightKey!),
                    style: TextStyle(
                      color: AppColors.darkPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ============================================================
  // TODO: RESİM EKLEME TALİMATLARI
  // ============================================================
  //
  // 1. ADIM: Assets klasörü oluştur
  //    Proje kök dizininde: assets/images/tutorial/ klasörü oluştur
  //
  // 2. ADIM: Resimleri ekle
  //    - assets/images/tutorial/step1_settings_tr.png
  //    - assets/images/tutorial/step1_settings_en.png
  //    vb.
  //
  // 3. ADIM: pubspec.yaml'a ekle
  //    flutter:
  //      assets:
  //        - assets/images/tutorial/
  //
  // 4. ADIM: Aşağıdaki _buildImageSection metodundaki placeholder'ı
  //    Image.asset() ile değiştir.
  //
  // ============================================================

  /// Adıma göre resim yolu döndür
  String _getStepImagePath(String languageCode) {
    // Dil koduna göre suffix ekle (örn: _tr veya _en)
    final suffix = languageCode == 'tr' ? '_tr' : '_en';

    switch (stepNumber) {
      case 1:
        return 'assets/tutorial/step1_settings$suffix.png';
      case 2:
        return 'assets/tutorial/step2_json$suffix.png';
      case 3:
        return 'assets/tutorial/step3_daterange$suffix.png';
      case 4:
        return 'assets/tutorial/step4_download$suffix.png';
      default:
        return 'assets/tutorial/step1_settings$suffix.png';
    }
  }

  /// Resim alanı
  /// TODO: Resimler hazır olduğunda placeholder'ı kaldır ve Image.asset kullan
  Widget _buildImageSection(bool isDark, String languageCode) {
    return Container(
      width: double.infinity,
      height: 320,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Image.asset(
              _getStepImagePath(languageCode),
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.grey, size: 40),
                      SizedBox(height: 8),
                      Text(
                        'Image not found\n${_getStepImagePath(languageCode)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Highlight badge (sadece adım 3 için)
            if (stepNumber == 3) _buildHighlightBadge(isDark),
          ],
        ),
      ),
    );
  }

  /// Highlight badge (IMPORTANT, Select JSON gibi)
  Widget _buildHighlightBadge(bool isDark) {
    return Positioned(
      right: 16,
      bottom: 80,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? Colors.white : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.priority_high,
                size: 16,
                color: Colors.amber.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'IMPORTANT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber.shade700,
                  ),
                ),
                Text(
                  'Select JSON Format',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
