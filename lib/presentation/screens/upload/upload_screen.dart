import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialsense/core/constants/app_colors.dart';
import 'package:socialsense/core/localization/app_localizations.dart';
import 'package:socialsense/core/providers/instagram_data_provider.dart';
import 'package:socialsense/core/services/ad_service.dart';
import 'package:socialsense/presentation/screens/dashboard/dashboard_screen.dart';

/// ZIP Yükleme Ekranı
/// Kullanıcının Instagram verisini yüklediği sayfa
class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedFileName;

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Upload alanı (dashed circle)
              _buildUploadArea(context, l10n, isDark),

              const SizedBox(height: 32),

              // Hata mesajı
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),

              // Seçilen dosya adı
              if (_selectedFileName != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color:
                        (isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary)
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.folder_zip,
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedFileName!,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Güvenlik badge
              _buildSecurityBadge(l10n, isDark),

              const SizedBox(height: 16),

              // Güvenlik açıklaması
              Text(
                l10n.get('local_processing_title'),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                l10n.get('local_processing_desc'),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // Desteklenen formatlar
              Text(
                l10n.get('supported_formats'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextHint
                      : AppColors.lightTextHint,
                ),
              ),

              const SizedBox(height: 16),

              // Dosya seç butonu
              _buildSelectFileButton(context, l10n),

              const SizedBox(height: 32),
            ],
          ),
        ),
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
        l10n.get('upload_your_data'),
        style: TextStyle(
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildUploadArea(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: _isLoading ? null : _selectFile,
      child: SizedBox(
        width: 200,
        height: 200,
        child: CustomPaint(
          painter: _DashedCirclePainter(
            color: isDark
                ? AppColors.darkPrimary.withValues(alpha: 0.5)
                : AppColors.lightPrimary.withValues(alpha: 0.5),
          ),
          child: Center(
            child: _isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.get('processing'),
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary,
                              isDark
                                  ? AppColors.darkPrimaryLight
                                  : AppColors.lightPrimaryLight,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.folder_zip_outlined,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.get('upload_zip_now'),
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityBadge(AppLocalizations l10n, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_user, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Text(
            l10n.get('fully_private'),
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectFileButton(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _selectFile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            else
              const Icon(Icons.upload_file, size: 22, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              _isLoading ? l10n.get('processing') : l10n.get('select_file'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFile() async {
    final l10n = AppLocalizations.of(context);

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Dosya seçici aç
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
        withData: kIsWeb, // Web için bytes gerekiyor
      );

      if (result == null || result.files.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final file = result.files.first;

      setState(() {
        _selectedFileName = file.name;
      });

      // Provider'ı al
      if (!mounted) return;
      final dataProvider = Provider.of<InstagramDataProvider>(
        context,
        listen: false,
      );

      bool success = false;

      if (kIsWeb) {
        // Web: Bytes kullan
        if (file.bytes != null) {
          success = await dataProvider.loadFromBytes(file.bytes!);
        } else {
          throw Exception('Dosya içeriği okunamadı');
        }
      } else {
        // Mobil/Desktop: Dosya yolu kullan
        if (file.path != null) {
          success = await dataProvider.loadFromZipFile(File(file.path!));
        } else {
          throw Exception('Dosya yolu bulunamadı');
        }
      }

      if (success) {
        // ZIP başarıyla yüklendiği için flag'i kaydet (açılışta reklam göstermek için)
        if (!kIsWeb) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('has_uploaded_zip', true);
        }

        if (mounted) {
          setState(() {
            _isLoading =
                false; // Loading'i kapat ki kullanıcı reklamın arkasında kaldığını düşünmesin
          });

          // Interstitial Reklamı göster, kapattığında Dashboard'a git
          AdService().showInterstitialAd(
            onAdClosed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            },
          );
        }
      } else {
        // Hata (Provider'dan gelen hata mesajını kullan veya varsayılan)
        setState(() {
          _errorMessage = dataProvider.error ?? l10n.get('error_invalid_file');
          _isLoading = false;
        });
      }
    } catch (e) {
      String errorMessage;

      if (e.toString().contains('HTML_FORMAT_ERROR')) {
        errorMessage = l10n.get('error_html_format');
      } else if (e.toString().contains('INVALID_ZIP_ERROR')) {
        errorMessage = l10n.get('error_invalid_zip');
      } else {
        errorMessage = '${l10n.get('error_generic')}\n\n${e.toString()}';
      }

      setState(() {
        _errorMessage = errorMessage;
        _isLoading = false;
      });
    }
  }
}

/// Dashed circle painter
class _DashedCirclePainter extends CustomPainter {
  final Color color;

  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 15;

    const dashWidth = 8.0;
    const dashSpace = 6.0;
    final circumference = 2 * 3.14159 * radius;
    final dashCount = (circumference / (dashWidth + dashSpace)).floor();

    for (var i = 0; i < dashCount; i++) {
      final startAngle = (i * (dashWidth + dashSpace)) / radius;
      final sweepAngle = dashWidth / radius;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
