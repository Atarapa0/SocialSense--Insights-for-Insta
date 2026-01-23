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
          _buildImageSection(isDark),

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
  //    - assets/images/tutorial/step1_settings.png  (Instagram ayarları)
  //    - assets/images/tutorial/step2_json.png      (JSON seçimi)
  //    - assets/images/tutorial/step3_daterange.png (Tarih aralığı)
  //    - assets/images/tutorial/step4_download.png  (İndirme)
  //
  // 3. ADIM: pubspec.yaml'a ekle
  //    flutter:
  //      assets:
  //        - assets/images/tutorial/
  //
  // 4. ADIM: Aşağıdaki _buildImageSection metodundaki placeholder'ı
  //    Image.asset() ile değiştir. Örnek:
  //
  //    Image.asset(
  //      _getStepImagePath(),
  //      fit: BoxFit.contain,
  //    )
  //
  // ============================================================

  /// Adıma göre resim yolu döndür
  /// TODO: Resimler eklendikten sonra bu metodu kullan
  String _getStepImagePath() {
    switch (stepNumber) {
      case 1:
        return 'assets/images/tutorial/step1_settings.png';
      case 2:
        return 'assets/images/tutorial/step2_json.png';
      case 3:
        return 'assets/images/tutorial/step3_daterange.png';
      case 4:
        return 'assets/images/tutorial/step4_download.png';
      default:
        return 'assets/images/tutorial/step1_settings.png';
    }
  }

  /// Resim alanı
  /// TODO: Resimler hazır olduğunda placeholder'ı kaldır ve Image.asset kullan
  Widget _buildImageSection(bool isDark) {
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
            // ============================================================
            // TODO: Resimler hazır olduğunda bu placeholder'ı şununla değiştir:
            //
            // Image.asset(
            //   _getStepImagePath(),
            //   fit: BoxFit.contain,
            //   width: double.infinity,
            //   height: double.infinity,
            // ),
            // ============================================================
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getStepIcon(),
                    size: 64,
                    color: isDark
                        ? AppColors.darkTextHint
                        : AppColors.lightTextHint,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Step $stepNumber Image',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextHint
                          : AppColors.lightTextHint,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getStepImagePath(),
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextHint.withValues(alpha: 0.5)
                          : AppColors.lightTextHint.withValues(alpha: 0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            // Highlight badge (bazı adımlar için)
            if (stepNumber <= 2) _buildHighlightBadge(isDark),
          ],
        ),
      ),
    );
  }

  /// Adıma göre ikon döndür
  IconData _getStepIcon() {
    switch (stepNumber) {
      case 1:
        return Icons.settings;
      case 2:
        return Icons.code;
      case 3:
        return Icons.date_range;
      case 4:
        return Icons.download;
      default:
        return Icons.help_outline;
    }
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
                color: stepNumber == 1
                    ? Colors.amber.shade100
                    : AppColors.darkPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                stepNumber == 1 ? Icons.sync : Icons.check_circle,
                size: 16,
                color: stepNumber == 1
                    ? Colors.amber.shade700
                    : AppColors.darkPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stepNumber == 1 ? 'IMPORTANT' : '',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: stepNumber == 1
                        ? Colors.amber.shade700
                        : AppColors.darkPrimary,
                  ),
                ),
                Text(
                  stepNumber == 1 ? 'Select JSON' : 'Select JSON Format',
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
