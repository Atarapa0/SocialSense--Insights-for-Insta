import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';
import 'package:socialsense/core/localization/app_localizations.dart';
import 'package:socialsense/presentation/screens/upload/upload_screen.dart';
import 'package:socialsense/presentation/screens/analyze/analyze_drop_screen.dart';
import 'package:socialsense/presentation/widgets/dashboard/priority_card.dart';
import 'package:socialsense/presentation/widgets/dashboard/activity_hours_card.dart';
import 'package:socialsense/presentation/widgets/dashboard/stats_row.dart';
import 'package:socialsense/presentation/widgets/dashboard/top_fans_card.dart';
import 'package:socialsense/presentation/widgets/dashboard/active_hour_card.dart';

/// Dashboard Ana Ekranı
/// Instagram istatistiklerinin gösterildiği ana sayfa
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentNavIndex = 0;

  // Simüle edilmiş güncelleme tarihi
  final DateTime _lastUpdateDate = DateTime(2026, 1, 20, 14, 30);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(child: _buildBody(context, l10n, isDark)),
      bottomNavigationBar: _buildBottomNav(context, l10n, isDark),
      floatingActionButton: _buildFAB(context, l10n, isDark),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n, bool isDark) {
    switch (_currentNavIndex) {
      case 0:
        return _buildHomeContent(context, l10n, isDark);
      case 1:
        return _buildReportsContent(l10n, isDark);
      case 2:
        return _buildAlertsContent(l10n, isDark);
      case 3:
        return _buildSettingsContent(l10n, isDark);
      default:
        return _buildHomeContent(context, l10n, isDark);
    }
  }

  /// Ana sayfa içeriği
  Widget _buildHomeContent(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Header (Selamlama + Profil + Güncelleme tarihi)
          _buildHeader(l10n, isDark),

          const SizedBox(height: 24),

          // Priority Card (Unfollowers) - tıklanabilir
          GestureDetector(
            onTap: () => _navigateToAnalyzeDrop(context),
            child: const PriorityCard(
              unfollowersCount: 47,
              message:
                  'You lost 47 followers this week.\nUsually this happens on Tuesdays.',
            ),
          ),

          const SizedBox(height: 16),

          // Ghost Followers ve Active Hour yan yana
          Row(
            children: [
              // Ghost Followers (küçük versiyon)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.get('ghost_followers'),
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          Icon(
                            Icons.visibility_off,
                            size: 14,
                            color: isDark
                                ? AppColors.darkTextHint
                                : AppColors.lightTextHint,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 70,
                                height: 70,
                                child: CircularProgressIndicator(
                                  value: 0.28,
                                  strokeWidth: 6,
                                  backgroundColor: isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                                  valueColor: const AlwaysStoppedAnimation(
                                    AppColors.darkPrimary,
                                  ),
                                ),
                              ),
                              Text(
                                '28%',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Ghost\nFollowers',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.2,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Active Hour
              const Expanded(
                child: ActiveHourCard(
                  activeHour: '9 PM',
                  changePercentage: 5,
                  hourlyData: [0.2, 0.3, 0.4, 0.6, 0.8, 1.0],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Top 3 Fans
          TopFansCard(
            fans: const [
              TopFan(username: 'sarah_j', likes: 54, comments: 12, rank: 1),
              TopFan(username: 'mike_designs', likes: 42, comments: 8, rank: 2),
              TopFan(username: 'emma_art', likes: 38, comments: 5, rank: 3),
            ],
            onViewAll: () {
              // TODO: Tüm takipçileri göster
            },
          ),

          const SizedBox(height: 16),

          // Activity Hours Card (haftalık)
          const ActivityHoursCard(
            peakTime: '8 PM',
            activityData: [0.3, 0.5, 0.8, 0.6, 0.9, 0.4, 0.7],
          ),

          const SizedBox(height: 16),

          // Stats Row (Engagement + Reach)
          const StatsRow(
            engagementRate: 4.8,
            engagementChange: 0.5,
            totalReach: 12500,
            reachChange: 1200,
          ),

          const SizedBox(height: 100), // Bottom nav için boşluk
        ],
      ),
    );
  }

  /// Header (Selamlama + Profil + Güncelleme tarihi)
  Widget _buildHeader(AppLocalizations l10n, bool isDark) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = l10n.get('good_morning');
    } else if (hour < 18) {
      greeting = l10n.get('good_afternoon');
    } else {
      greeting = l10n.get('good_evening');
    }

    // Güncelleme tarihi formatı
    final updateText =
        '${l10n.get('last_update')}: ${_formatDate(_lastUpdateDate)}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Sol: Selamlama ve güncelleme tarihi
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting,',
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Alex Carter',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            // Güncelleme tarihi
            Row(
              children: [
                Icon(
                  Icons.update,
                  size: 12,
                  color: isDark
                      ? AppColors.darkTextHint
                      : AppColors.lightTextHint,
                ),
                const SizedBox(width: 4),
                Text(
                  updateText,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextHint
                        : AppColors.lightTextHint,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Sağ: Bildirim + Profil
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.darkAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: AppColors.primaryGradient,
              ),
              child: const Center(
                child: Icon(Icons.person, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Raporlar placeholder
  Widget _buildReportsContent(AppLocalizations l10n, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 64,
            color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.get('reports'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon...',
            style: TextStyle(
              color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
            ),
          ),
        ],
      ),
    );
  }

  /// Uyarılar placeholder
  Widget _buildAlertsContent(AppLocalizations l10n, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_active,
            size: 64,
            color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.get('alerts'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon...',
            style: TextStyle(
              color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
            ),
          ),
        ],
      ),
    );
  }

  /// Ayarlar placeholder
  Widget _buildSettingsContent(AppLocalizations l10n, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.settings,
            size: 64,
            color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.get('settings'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon...',
            style: TextStyle(
              color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
            ),
          ),
        ],
      ),
    );
  }

  /// Bottom Navigation Bar
  Widget _buildBottomNav(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: l10n.get('home'),
                index: 0,
                isDark: isDark,
              ),
              _buildNavItem(
                icon: Icons.bar_chart_outlined,
                activeIcon: Icons.bar_chart,
                label: l10n.get('reports'),
                index: 1,
                isDark: isDark,
              ),
              const SizedBox(width: 60),
              _buildNavItem(
                icon: Icons.notifications_outlined,
                activeIcon: Icons.notifications,
                label: l10n.get('alerts'),
                index: 2,
                isDark: isDark,
              ),
              _buildNavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: l10n.get('settings'),
                index: 3,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required bool isDark,
  }) {
    final isActive = _currentNavIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentNavIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            color: isActive
                ? AppColors.darkPrimary
                : isDark
                ? AppColors.darkTextHint
                : AppColors.lightTextHint,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive
                  ? AppColors.darkPrimary
                  : isDark
                  ? AppColors.darkTextHint
                  : AppColors.lightTextHint,
            ),
          ),
        ],
      ),
    );
  }

  /// Floating Action Button - Güncelleme dialog'u ile
  Widget _buildFAB(BuildContext context, AppLocalizations l10n, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.darkPrimary.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => _showUpdateDialog(context, l10n, isDark),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  /// Güncelleme dialog'u
  void _showUpdateDialog(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.darkPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.update,
                color: AppColors.darkPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.get('update_data_title'),
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          l10n.get('update_data_message'),
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        actions: [
          // Hayır butonu
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.get('no'),
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
          // Evet butonu
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToUpload(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.get('yes'),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToUpload(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UploadScreen()),
    );
  }

  void _navigateToAnalyzeDrop(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnalyzeDropScreen(
          unfollowersCount: 47,
          unfollowers: [
            Unfollower(
              username: 'john_doe',
              unfollowedAt: DateTime.now().subtract(const Duration(days: 1)),
              daysSinceUnfollow: 1,
            ),
            Unfollower(
              username: 'jane_smith',
              unfollowedAt: DateTime.now().subtract(const Duration(days: 2)),
              daysSinceUnfollow: 2,
            ),
            Unfollower(
              username: 'photo_lover',
              unfollowedAt: DateTime.now().subtract(const Duration(days: 2)),
              daysSinceUnfollow: 2,
            ),
            Unfollower(
              username: 'travel_addict',
              unfollowedAt: DateTime.now().subtract(const Duration(days: 3)),
              daysSinceUnfollow: 3,
            ),
            Unfollower(
              username: 'foodie_gram',
              unfollowedAt: DateTime.now().subtract(const Duration(days: 4)),
              daysSinceUnfollow: 4,
            ),
          ],
        ),
      ),
    );
  }
}
