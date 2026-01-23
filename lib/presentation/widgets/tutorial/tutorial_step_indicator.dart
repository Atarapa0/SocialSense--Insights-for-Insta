import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';

/// Tutorial adım göstergesi (noktalı progress bar)
/// Görseldeki gibi aktif adım uzun çizgi, diğerleri nokta
class TutorialStepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const TutorialStepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        final isPassed = index < currentStep;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: isActive ? 32 : 8,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.darkPrimary
                : isPassed
                ? AppColors.darkPrimary.withValues(alpha: 0.5)
                : isDark
                ? AppColors.darkBorder
                : AppColors.lightBorder,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
