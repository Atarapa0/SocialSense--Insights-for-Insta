import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';
import 'package:socialsense/core/localization/app_localizations.dart';
import 'package:socialsense/presentation/screens/upload/upload_screen.dart';
import 'package:socialsense/presentation/widgets/tutorial/tutorial_step_indicator.dart';
import 'package:socialsense/presentation/widgets/tutorial/tutorial_step_card.dart';

/// Tutorial verisi
class TutorialStep {
  final String titleKey;
  final String descriptionKey;
  final String? highlightKey;
  final String? imagePath; // Sonra doldurulacak

  const TutorialStep({
    required this.titleKey,
    required this.descriptionKey,
    this.highlightKey,
    this.imagePath,
  });
}

/// Tutorial Ekranı
/// 4 adımlı Instagram veri indirme rehberi
class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // 4 Tutorial adımı
  static const List<TutorialStep> _steps = [
    // Adım 1: Instagram Ayarlarını Aç
    TutorialStep(
      titleKey: 'tutorial_step1_title',
      descriptionKey: 'tutorial_step1_desc',
      highlightKey: 'tutorial_step1_highlight',
    ),
    // Adım 2: JSON Formatını Seç
    TutorialStep(
      titleKey: 'tutorial_step2_title',
      descriptionKey: 'tutorial_step2_desc',
      highlightKey: 'tutorial_step2_highlight',
    ),
    // Adım 3: Veri Aralığını Seç
    TutorialStep(
      titleKey: 'tutorial_step3_title',
      descriptionKey: 'tutorial_step3_desc',
      highlightKey: 'tutorial_step3_highlight',
    ),
    // Adım 4: İndirme Bağlantısını Bekle
    TutorialStep(
      titleKey: 'tutorial_step4_title',
      descriptionKey: 'tutorial_step4_desc',
      highlightKey: 'tutorial_step4_highlight',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: _buildAppBar(context, l10n, isDark),
      body: Column(
        children: [
          // Step göstergesi (noktalı)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: TutorialStepIndicator(
              totalSteps: _steps.length,
              currentStep: _currentStep,
            ),
          ),

          // PageView içeriği
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _steps.length,
              onPageChanged: (index) {
                setState(() => _currentStep = index);
              },
              itemBuilder: (context, index) {
                return TutorialStepCard(
                  step: _steps[index],
                  stepNumber: index + 1,
                  totalSteps: _steps.length,
                );
              },
            ),
          ),

          // Alt buton
          _buildBottomButton(context, l10n, isDark),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return AppBar(
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
        l10n.get('tutorial').toUpperCase(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
      centerTitle: true,
      actions: [
        // Skip butonu
        TextButton(
          onPressed: () => _navigateToUpload(context),
          child: Text(
            l10n.get('skip'),
            style: TextStyle(
              color: AppColors.darkPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final isLastStep = _currentStep == _steps.length - 1;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkPrimary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              if (isLastStep) {
                _navigateToUpload(context);
              } else {
                _nextStep();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLastStep ? l10n.get('get_started') : l10n.get('next_step'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToUpload(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const UploadScreen()),
    );
  }
}
