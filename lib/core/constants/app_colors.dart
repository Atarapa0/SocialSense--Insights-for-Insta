import 'package:flutter/material.dart';

/// Uygulama renk paleti
/// Açık ve koyu tema için ayrı renkler tanımlanmıştır
class AppColors {
  AppColors._();

  // ==========================================
  // KOYU TEMA (Dark Theme) - Görseldeki gibi
  // ==========================================

  static const darkBackground = Color(0xFF0D0D1A); // Ana arka plan
  static const darkSurface = Color(0xFF151525); // Kart arka planı
  static const darkCard = Color(0xFF1A1A2E); // Kart rengi
  static const darkCardGradientStart = Color(0xFF2D1F3D); // Mor gradient başı
  static const darkCardGradientEnd = Color(0xFF1A1A2E); // Gradient sonu

  // Koyu tema - Primary renk (Mor/Mavi)
  static const darkPrimary = Color(0xFF5B5CFF); // Ana mor/mavi
  static const darkPrimaryLight = Color(0xFF7B7CFF); // Açık mor
  static const darkPrimaryDark = Color(0xFF4B4CDF); // Koyu mor

  // Koyu tema - Accent renk (Kırmızı)
  static const darkAccent = Color(0xFFE53935); // Kırmızı aksan
  static const darkAccentLight = Color(0xFFFF6B6B); // Açık kırmızı
  static const darkAccentOrange = Color(0xFFFF6B35); // Turuncu

  // Koyu tema - Metin renkleri
  static const darkTextPrimary = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFFA0A0B0);
  static const darkTextHint = Color(0xFF6B6B80);

  // Koyu tema - Özel renkler
  static const darkSuccess = Color(0xFF4CAF50);
  static const darkWarning = Color(0xFFFFC107);
  static const darkError = Color(0xFFE53935);
  static const darkInfo = Color(0xFF5B5CFF);

  // Koyu tema - Border ve divider
  static const darkBorder = Color(0xFF2A2A40);
  static const darkDivider = Color(0xFF252535);

  // ==========================================
  // AÇIK TEMA (Light Theme) - Görseldeki gibi
  // ==========================================

  static const lightBackground = Color(0xFFFFFFFF); // Beyaz arka plan
  static const lightSurface = Color(0xFFF5F5F8); // Açık gri yüzey
  static const lightCard = Color(0xFFFFFFFF); // Beyaz kart
  static const lightCardShadow = Color(0x1A000000); // Kart gölgesi

  // Açık tema - Primary renk (Mavi)
  static const lightPrimary = Color(0xFF5B5CFF); // Ana mavi
  static const lightPrimaryLight = Color(0xFF7B7CFF);
  static const lightPrimaryDark = Color(0xFF4B4CDF);

  // Açık tema - Accent renk
  static const lightAccent = Color(0xFFE53935);
  static const lightAccentLight = Color(0xFFFF8A80);

  // Açık tema - Metin renkleri
  static const lightTextPrimary = Color(0xFF1A1A2E);
  static const lightTextSecondary = Color(0xFF6B6B80);
  static const lightTextHint = Color(0xFFA0A0B0);

  // Açık tema - Özel renkler
  static const lightSuccess = Color(0xFF4CAF50);
  static const lightWarning = Color(0xFFFFC107);
  static const lightError = Color(0xFFE53935);
  static const lightInfo = Color(0xFF5B5CFF);

  // Açık tema - Border ve divider
  static const lightBorder = Color(0xFFE0E0E8);
  static const lightDivider = Color(0xFFF0F0F5);

  // ==========================================
  // GRADIENT'LAR
  // ==========================================

  // Ana buton gradient (mor-mavi)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5B5CFF), Color(0xFF7B7CFF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Dashboard kart gradient (koyu tema)
  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF2D1F3D), Color(0xFF1A1A2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Priority kart gradient (kırmızı-mor)
  static const LinearGradient priorityCardGradient = LinearGradient(
    colors: [Color(0xFF3D1F2F), Color(0xFF2D1F3D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Progress ring gradient
  static const LinearGradient progressGradient = LinearGradient(
    colors: [Color(0xFF5B5CFF), Color(0xFF7B7CFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
