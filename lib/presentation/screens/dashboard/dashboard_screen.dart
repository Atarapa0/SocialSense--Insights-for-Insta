import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialsense/presentation/screens/welcome/welcome_screen.dart';
import 'package:socialsense/core/constants/app_colors.dart';
import 'package:socialsense/core/localization/app_localizations.dart';
import 'package:socialsense/core/providers/instagram_data_provider.dart';
import 'package:socialsense/presentation/providers/app_settings_provider.dart';
import 'package:socialsense/core/utils/instagram_launcher.dart';
import 'package:socialsense/presentation/screens/upload/upload_screen.dart';
import 'package:socialsense/presentation/screens/analyze/analyze_drop_screen.dart';
import 'package:socialsense/presentation/screens/analyze/ghost_followers_screen.dart';
import 'package:socialsense/presentation/screens/analyze/follower_list_screen.dart';
import 'package:socialsense/presentation/screens/analyze/stats_list_screen.dart';
import 'package:socialsense/presentation/screens/reports/top_fans_list_screen.dart';
import 'package:socialsense/presentation/widgets/dashboard/priority_card.dart';
import 'package:socialsense/presentation/widgets/dashboard/activity_hours_card.dart';
import 'package:socialsense/presentation/widgets/dashboard/stats_row.dart';
import 'package:socialsense/presentation/providers/alerts_provider.dart';
import 'package:socialsense/presentation/widgets/dashboard/top_fans_card.dart';
import 'package:socialsense/presentation/widgets/dashboard/active_hour_card.dart';
import 'package:socialsense/presentation/widgets/reports/follower_details_card.dart';
import 'package:socialsense/presentation/widgets/reports/account_analysis_card.dart';
import 'package:socialsense/presentation/widgets/reports/direct_messages_card.dart';
import 'package:socialsense/presentation/widgets/ads/banner_ad_widget.dart';

import 'package:socialsense/presentation/widgets/reports/activity_timeline_card.dart';
import 'package:socialsense/presentation/widgets/reports/time_distribution_card.dart';
import 'package:socialsense/presentation/widgets/reports/reels_share_card.dart';
import 'package:socialsense/presentation/widgets/reports/interests_distribution_card.dart';
import 'package:socialsense/presentation/widgets/reports/story_likes_card.dart';
import 'package:socialsense/presentation/widgets/reports/close_friends_card.dart';
import 'package:socialsense/presentation/screens/settings/contact_screen.dart';
import 'package:socialsense/presentation/screens/settings/faq_screen.dart';
import 'package:socialsense/presentation/screens/settings/privacy_policy_screen.dart';
import 'package:socialsense/presentation/screens/settings/terms_of_use_screen.dart';
import 'package:socialsense/presentation/widgets/reports/follow_requests_card.dart';
import 'package:socialsense/presentation/widgets/reports/saved_content_detail_card.dart';
import 'package:socialsense/presentation/widgets/alerts/alert_card.dart';
import 'package:socialsense/presentation/widgets/settings/settings_tile.dart';

/// Dashboard Ana Ekranı
/// Instagram istatistiklerinin gösterildiği ana sayfa
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentNavIndex = 0;

  // Provider'dan son güncelleme tarihini al
  DateTime? get _lastUpdateDate {
    final provider = Provider.of<InstagramDataProvider>(context, listen: false);
    return provider.lastUpdateDate;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Uyarı sayısını hesapla
    // NOT: _getAlerts metodu performans için optimize edilebilir (Provider'a taşınabilir)
    final alerts = _getAlerts(l10n);
    final unreadAlertsCount = alerts.where((a) => !a.isRead).length;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(child: _buildBody(context, l10n, isDark)),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 20,
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
                  0,
                  Icons.dashboard_outlined,
                  Icons.dashboard,
                  l10n.get('home'),
                  isDark,
                ),
                _buildNavItem(
                  1,
                  Icons.bar_chart_outlined,
                  Icons.bar_chart,
                  l10n.get('reports'),
                  isDark,
                ),
                Stack(
                  children: [
                    _buildNavItem(
                      2,
                      Icons.notifications_none_outlined,
                      Icons.notifications,
                      l10n.get('alerts'),
                      isDark,
                    ),
                    if (unreadAlertsCount > 0)
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$unreadAlertsCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                _buildNavItem(
                  3,
                  Icons.settings_outlined,
                  Icons.settings,
                  l10n.get('settings'),
                  isDark,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _currentNavIndex == 0
          ? _buildFAB(context, l10n, isDark)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
    bool isDark,
  ) {
    final isSelected = _currentNavIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentNavIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                    : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
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

  /// Home içeriği (Ana Dashboard)
  Widget _buildHomeContent(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    // Provider'dan verileri al
    final dataProvider = Provider.of<InstagramDataProvider>(context);
    final hasData = dataProvider.hasData;

    // Gerçek veriler
    final unfollowersCount = dataProvider.notFollowingBack.length;
    final ghostPercentage = dataProvider.ghostFollowerPercentage;
    final activeHour = dataProvider.mostActiveHour;
    final engagementRate = dataProvider.engagementRate;
    final followersCount = dataProvider.followersCount;

    // Top fans hesapla
    final topLiked = dataProvider.topLikedAccounts;
    final topCommented = dataProvider.topCommentedAccounts;

    // Top 3 fans listesi oluştur
    final topFansMap = <String, Map<String, int>>{};
    for (final entry in topLiked.entries.take(10)) {
      topFansMap[entry.key] = {'likes': entry.value, 'comments': 0};
    }
    for (final entry in topCommented.entries.take(10)) {
      if (topFansMap.containsKey(entry.key)) {
        topFansMap[entry.key]!['comments'] = entry.value;
      } else {
        topFansMap[entry.key] = {'likes': 0, 'comments': entry.value};
      }
    }
    // Toplam etkileşime göre sırala
    final sortedFans = topFansMap.entries.toList()
      ..sort((a, b) {
        final aTotal = a.value['likes']! + a.value['comments']!;
        final bTotal = b.value['likes']! + b.value['comments']!;
        return bTotal.compareTo(aTotal);
      });

    // Tüm Top Fans Listesi
    final allTopFans = sortedFans.asMap().entries.map((entry) {
      final fan = entry.value;
      return TopFan(
        username: fan.key,
        likes: fan.value['likes']!,
        comments: fan.value['comments']!,
        rank: entry.key + 1,
      );
    }).toList();

    // Sadece ilk 3 tanesi
    final topFans = allTopFans.take(3).toList();

    // Saatlik aktivite verisi
    final hourlyActivity = dataProvider.hourlyActivity;
    final maxActivity = hourlyActivity.values.fold(1, (a, b) => a > b ? a : b);
    final activityData = List.generate(7, (i) {
      // Son 7 gün için aktivite
      final hour = (DateTime.now().hour - 6 + i) % 24;
      final value = hourlyActivity[hour] ?? 0;
      return maxActivity > 0 ? value / maxActivity : 0.0;
    });

    // Active hour formatla
    String formatHour(int hour) {
      if (hour == 0) return '12 AM';
      if (hour < 12) return '$hour AM';
      if (hour == 12) return '12 PM';
      return '${hour - 12} PM';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Header (Selamlama + Profil + Güncelleme tarihi)
          _buildHeader(l10n, isDark),

          const SizedBox(height: 24),

          // Veri yoksa uyarı göster
          if (!hasData)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.get('no_data_available'),
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),

          // Priority Card - tıklanabilir
          GestureDetector(
            onTap: () => _navigateToAnalyzeDrop(context),
            child: PriorityCard(
              unfollowersCount: unfollowersCount,
              message: unfollowersCount > 0
                  ? 'Takip ettiğin $unfollowersCount kişi seni geri takip etmiyor.'
                  : 'Herkes seni geri takip ediyor!',
            ),
          ),

          const SizedBox(height: 16),

          // Ghost Followers ve Active Hour yan yana
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ghost Followers (küçük versiyon)
              Expanded(
                child: GestureDetector(
                  onTap: () => _navigateToGhostFollowers(context),
                  child: Container(
                    height: 200, // Sabit yükseklik
                    padding: const EdgeInsets.all(14),
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
                            Flexible(
                              child: Text(
                                l10n.get('ghost_followers'),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
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
                        const Spacer(),
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
                                    value: ghostPercentage / 100,
                                    strokeWidth: 8,
                                    backgroundColor: isDark
                                        ? AppColors.darkBackground
                                        : AppColors.lightBackground,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          AppColors.darkAccent,
                                        ),
                                    strokeCap: StrokeCap.round,
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${ghostPercentage.toStringAsFixed(0)}%',
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
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: Text(
                            l10n.get('ghost_followers_desc'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
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
              ),

              const SizedBox(width: 12),

              // Active Hour
              Expanded(
                child: ActiveHourCard(
                  activeHour: hasData ? formatHour(activeHour) : '---',
                  changePercentage: 0,
                  hourlyData: activityData.isEmpty
                      ? [0.2, 0.3, 0.4, 0.6, 0.8, 1.0]
                      : activityData,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Top 3 Fans
          TopFansCard(
            fans: topFans.isEmpty
                ? [
                    const TopFan(
                      username: '---',
                      likes: 0,
                      comments: 0,
                      rank: 1,
                    ),
                    const TopFan(
                      username: '---',
                      likes: 0,
                      comments: 0,
                      rank: 2,
                    ),
                    const TopFan(
                      username: '---',
                      likes: 0,
                      comments: 0,
                      rank: 3,
                    ),
                  ]
                : topFans,
            onViewAll: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TopFansListScreen(fans: allTopFans),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          const SizedBox(height: 16),

          // Activity Hours Card (haftalık)
          ActivityHoursCard(
            peakTime: hasData ? formatHour(activeHour) : '---',
            activityData: activityData.isEmpty
                ? const [0.3, 0.5, 0.8, 0.6, 0.9, 0.4, 0.7]
                : activityData,
          ),

          const SizedBox(height: 16),

          // İstatistikler (6'lı Grid)
          StatsRow(
            mutualCount: hasData ? dataProvider.mutualFollowers.length : 0,
            notFollowingBackCount: hasData
                ? dataProvider.notFollowingBack.length
                : 0,
            interestsCount: hasData ? dataProvider.interests.length : 0,
            savedCount: hasData ? dataProvider.savedItems.length : 0,
            onTap: () {
              setState(() => _currentNavIndex = 1);
            },
          ),

          const SizedBox(height: 16),

          // REKLAM - Banner (En Alt)
          const BannerAdWidget(),

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
    final updateText = _lastUpdateDate != null
        ? '${l10n.get('last_update')}: ${_formatDate(_lastUpdateDate!)}'
        : '${l10n.get('last_update')}: ---';

    // Kullanıcı adını Provider'dan al
    final dataProvider = Provider.of<InstagramDataProvider>(
      context,
      listen: false,
    );
    final username = dataProvider.username;

    return InkWell(
      onTap: () {
        if (username != null) {
          InstagramLauncher.openProfile(username);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
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
                if (username != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    username,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
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
                // Profil Avatar

                // Profil Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkBackground
                            : AppColors.lightBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          (username != null && username.isNotEmpty)
                              ? username[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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

  /// Raporlar içeriği (YENİ İÇERİKLER EKLENDİ)
  Widget _buildReportsContent(AppLocalizations l10n, bool isDark) {
    // Provider'dan verileri al
    final dataProvider = Provider.of<InstagramDataProvider>(context);
    final hasData = dataProvider.hasData;

    // Gerçek veriler
    final mutualCount = dataProvider.mutualFollowers.length;
    final mutualList = dataProvider.mutualFollowers
        .take(3)
        .map((u) => '@$u')
        .toList();
    final notFollowingCount = dataProvider.notFollowingBack.length;
    final notFollowingList = dataProvider.notFollowingBack
        .take(3)
        .map((u) => '@$u')
        .toList();
    final youDontFollowCount = dataProvider.youDontFollow.length;
    final youDontFollowList = dataProvider.youDontFollow
        .take(3)
        .map((u) => '@$u')
        .toList();

    // En çok beğenilen ve yorum yapılan hesaplar
    final topLiked = dataProvider.topLikedAccounts;
    final topCommented = dataProvider.topCommentedAccounts;

    final mostLikedList = topLiked.entries
        .take(5)
        .map((e) => AccountAnalysis(username: '@${e.key}', count: e.value))
        .toList();

    final mostCommentedList = topCommented.entries
        .take(5)
        .map((e) => AccountAnalysis(username: '@${e.key}', count: e.value))
        .toList();

    // Kayıtlı içerik hesapları
    final savedAccounts = dataProvider.topSavedAccounts;
    final savedAccountsList = savedAccounts.entries
        .take(10)
        .map((e) => SavedContentAccount(username: '@${e.key}'))
        .toList();

    // Debug log - Reports verileri
    debugPrint('📊 REPORTS VERİLERİ:');
    debugPrint('  - Mutual: $mutualCount, list: $mutualList');
    debugPrint(
      '  - Not Following: $notFollowingCount, list: $notFollowingList',
    );
    debugPrint(
      '  - You Dont Follow: $youDontFollowCount, list: $youDontFollowList',
    );
    debugPrint('  - Top Liked: ${topLiked.length}');
    debugPrint('  - Top Commented: ${topCommented.length}');

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Başlık
          Row(
            children: [
              const Icon(
                Icons.bar_chart,
                color: AppColors.darkPrimary,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                l10n.get('reports'),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Veri yoksa uyarı göster
          if (!hasData)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.get('no_data_available'),
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),

          // Takipçi Detayları
          FollowerDetailsCard(
            mutualFollowersCount: mutualCount,
            mutualFollowers: mutualList.isEmpty ? ['---'] : mutualList,
            notFollowingYouCount: notFollowingCount,
            notFollowingYou: notFollowingList.isEmpty
                ? ['---']
                : notFollowingList,
            youDontFollowCount: youDontFollowCount,
            youDontFollow: youDontFollowList.isEmpty
                ? ['---']
                : youDontFollowList,
            onMutualTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FollowerListScreen(
                  title: 'Karşılıklı Takipler',
                  followers: dataProvider.mutualFollowers,
                ),
              ),
            ),
            onNotFollowingYouTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FollowerListScreen(
                  title: 'Seni Takip Etmeyenler',
                  followers: dataProvider.notFollowingBack,
                ),
              ),
            ),
            onYouDontFollowTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FollowerListScreen(
                  title: 'Takip Etmediklerin',
                  followers: dataProvider.youDontFollow,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          const SizedBox(height: 16),

          // Hesap Analizleri
          AccountAnalysisCard(
            mostLikedCount: mostLikedList.length,
            mostLikedAccounts: mostLikedList.isEmpty
                ? [const AccountAnalysis(username: '---', count: 0)]
                : mostLikedList,
            mostCommentedCount: mostCommentedList.length,
            mostCommentedAccounts: mostCommentedList.isEmpty
                ? [const AccountAnalysis(username: '---', count: 0)]
                : mostCommentedList,
            onMostLikedTap: () {
              if (mostLikedList.isEmpty) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FollowerListScreen(
                    title: 'En Çok Beğenenler',
                    followers: mostLikedList.map((e) => e.username).toList(),
                  ),
                ),
              );
            },
            onMostCommentedTap: () {
              if (mostCommentedList.isEmpty) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FollowerListScreen(
                    title: 'En Çok Yorum Yapanlar',
                    followers: mostCommentedList
                        .map((e) => e.username)
                        .toList(),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Direkt Mesajlar
          DirectMessagesCard(
            totalChats: dataProvider.totalConversationCount,
            totalMessages: dataProvider.totalMessageCount,
            sentMessagesMap: dataProvider.msgSentMap,
            receivedMessagesMap: dataProvider.msgReceivedMap,
            onSentTap: () {
              if (dataProvider.msgSentMap.isEmpty) return;
              final sorted = dataProvider.msgSentMap.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StatsListScreen(
                    title: l10n.get('most_messaged_sent'),
                    items: sorted,
                  ),
                ),
              );
            },
            onReceivedTap: () {
              if (dataProvider.msgReceivedMap.isEmpty) return;
              final sorted = dataProvider.msgReceivedMap.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StatsListScreen(
                    title: l10n.get('most_messaged_received'),
                    items: sorted,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Reels Etkileşimleri
          if (hasData)
            ReelsShareCard(
              sentReels: dataProvider.topReelsSent,
              receivedReels: dataProvider.topReelsReceived,
              onSentTap: () {
                if (dataProvider.topReelsSent.isEmpty) return;
                final sorted = dataProvider.topReelsSent.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StatsListScreen(
                      title: l10n.get('most_reels_sent'),
                      items: sorted,
                    ),
                  ),
                );
              },
              onReceivedTap: () {
                if (dataProvider.topReelsReceived.isEmpty) return;
                final sorted = dataProvider.topReelsReceived.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StatsListScreen(
                      title: l10n.get('most_reels_received'),
                      items: sorted,
                    ),
                  ),
                );
              },
            ),

          const SizedBox(height: 24),

          const SizedBox(height: 16),

          // REKLAM - Banner
          const BannerAdWidget(),

          const SizedBox(height: 16),

          // Zaman Dağılımı
          if (hasData)
            TimeDistributionCard(
              timeData: dataProvider.timeDistribution,
              weekData: dataProvider.weekDistribution,
            ),

          const SizedBox(height: 24),

          // İlgi Alanları (Kategorili)
          if (hasData)
            InterestsDistributionCard(
              interests: dataProvider.categorizedInterests,
            ),

          const SizedBox(height: 24),

          // REKLAM - Banner
          const BannerAdWidget(),

          const SizedBox(height: 16),

          // Hikaye Beğenileri
          if (hasData)
            StoryLikesCard(storyLikes: dataProvider.topStoryLikedAccounts),

          const SizedBox(height: 24),

          // Yakın Arkadaşlar
          if (hasData)
            CloseFriendsCard(closeFriends: dataProvider.closeFriends),

          const SizedBox(height: 24),

          const SizedBox(height: 16),

          // Takip İstekleri
          if (hasData)
            FollowRequestsCard(
              sentRequests: dataProvider.pendingRequests,
              receivedRequests: dataProvider.receivedRequests,
            ),

          const SizedBox(height: 24),

          // Kayıtlı İçerikler (Detaylı)
          SavedContentDetailCard(
            totalSavedContent: savedAccountsList.length,
            accounts: savedAccountsList.isEmpty
                ? [const SavedContentAccount(username: '---')]
                : savedAccountsList,
            storyLikesCount: 0,
            storyLikesAccounts: const [],
          ),

          const SizedBox(height: 24),

          // Aktivite Zaman Çizelgesi Başlığı
          Text(
            l10n.get('activity_timeline'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          // Beğeni Aktivitesi Grafiği
          ActivityTimelineCard(
            title: l10n.get('like_activity'),
            subtitle: l10n.get('all_time'),
            dataPoints: dataProvider.monthlyLikeActivity.isEmpty
                ? const [ActivityDataPoint(label: '---', value: 0)]
                : dataProvider.monthlyLikeActivity
                      .map(
                        (e) => ActivityDataPoint(
                          label: e['label'] as String,
                          value: (e['value'] as int).toDouble(),
                        ),
                      )
                      .toList(),
            lineColor: const Color(0xFFFF6B9D),
            hasData: hasData && dataProvider.totalLikesCount > 0,
          ),

          const SizedBox(height: 16),

          // Yorumlar henüz parse edilmiyor, bu kartı kaldırabiliriz veya boş bırakabiliriz
          if (dataProvider.totalCommentsCount > 0)
            ActivityTimelineCard(
              title: l10n.get('comment_activity'),
              subtitle: l10n.get('all_time'),
              dataPoints: const [ActivityDataPoint(label: '---', value: 0)],
              lineColor: const Color(0xFF4ECDC4),
              hasData: hasData && dataProvider.totalCommentsCount > 0,
            ),

          const SizedBox(height: 16),

          // REKLAM - Banner (En Alt)
          const BannerAdWidget(),

          const SizedBox(height: 100), // Bottom nav için boşluk
        ],
      ),
    );
  }

  /// Uyarılar listesi (Dinamik Metot)
  List<AlertItem> _getAlerts(AppLocalizations l10n) {
    try {
      final provider = Provider.of<InstagramDataProvider>(context);
      final alertsProvider = Provider.of<AlertsProvider>(context);

      if (!provider.hasData) return [];

      final alerts = <AlertItem>[];

      if (provider.notFollowingBack.isNotEmpty) {
        alerts.add(
          AlertItem(
            id: 'nf',
            type: AlertType.followerDrop,
            title: l10n.get('unfollowers'),
            description: l10n
                .get('unfollowers_desc')
                .replaceFirst('%count', '${provider.notFollowingBack.length}'),
            timestamp: DateTime.now(),
            data: {'count': provider.notFollowingBack.length},
            isRead: alertsProvider.readAlertIds.contains('nf'),
          ),
        );
      }

      if (provider.ghostFollowersList.isNotEmpty) {
        alerts.add(
          AlertItem(
            id: 'gf',
            type: AlertType.ghostFollower,
            title: l10n.get('ghost_followers'),
            description:
                '${provider.ghostFollowersList.length} ${l10n.get('ghost_follower_desc')}',
            timestamp: DateTime.now(),
            isRead: alertsProvider.readAlertIds.contains('gf'),
          ),
        );
      }

      if (provider.pendingRequests.isNotEmpty) {
        alerts.add(
          AlertItem(
            id: 'pr',
            type: AlertType.activeHourChanged,
            title: l10n.get('pending_follow_requests_title'),
            description:
                '${provider.pendingRequests.length} ${l10n.get('pending_follow_requests_desc')}',
            timestamp: DateTime.now(),
            isRead: alertsProvider.readAlertIds.contains('pr'),
          ),
        );
      }
      return alerts;
    } catch (_) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
  }

  /// Uyarılar ekranı
  Widget _buildAlertsContent(AppLocalizations l10n, bool isDark) {
    // AlertsProvider'ı dinliyoruz ki badge ve liste güncellensin
    final alerts = _getAlerts(l10n);
    final alertsProvider = Provider.of<AlertsProvider>(context);

    if (alerts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 40,
                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.get('no_alerts'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.get('no_alerts_desc'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    final unreadCount = alerts.where((a) => !a.isRead).length;
    final provider = Provider.of<InstagramDataProvider>(context, listen: false);

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.get('alerts'),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  if (unreadCount > 0)
                    Text(
                      '$unreadCount okunmamış',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                ],
              ),
              // Clear All butonu kaldırıldı.
            ],
          ),
        ),

        // Uyarılar listesi
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return AlertCard(
                alert: alert,
                onTap: () {
                  // Okundu olarak işaretle
                  alertsProvider.markAsRead(alert.id);

                  // İlgili sayfaya yönlendir
                  if (alert.id == 'nf') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FollowerListScreen(
                          title: l10n.get('not_following_back'),
                          followers: provider.notFollowingBack,
                        ),
                      ),
                    );
                  } else if (alert.id == 'gf') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GhostFollowersScreen(
                          ghostCount: provider.ghostFollowersCount,
                          ghostFollowers: provider.ghostFollowersList,
                        ),
                      ),
                    );
                  } else if (alert.id == 'pr') {
                    // Bekleyen İstekler -> Raporlar sayfasına yönlendir
                    setState(() {
                      _currentNavIndex = 1; // Raporlar sekmesi
                    });
                  }
                },
                onDismiss: () {}, // Dismiss işlevi şimdilik pasif
              );
            },
          ),
        ),
      ],
    );
  }

  /// Ayarlar ekranı
  Widget _buildSettingsContent(AppLocalizations l10n, bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(
              l10n.get('settings'),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),

          // ==================== GÖRÜNÜM ====================
          SettingsSectionHeader(title: l10n.get('appearance')),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Tema seçimi
                SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: l10n.get('theme'),
                  subtitle: isDark
                      ? l10n.get('dark_mode')
                      : l10n.get('light_mode'),
                  iconColor: const Color(0xFF5B5CFF),
                  trailing: Switch(
                    value: isDark,
                    onChanged: (value) {
                      // Tema değiştir
                      final settingsProvider = Provider.of<AppSettingsProvider>(
                        context,
                        listen: false,
                      );
                      settingsProvider.toggleTheme();
                    },
                    activeColor: AppColors.darkPrimary,
                  ),
                ),

                // Dil seçimi
                SettingsTile(
                  icon: Icons.language,
                  title: l10n.get('language'),
                  subtitle: l10n.locale.languageCode == 'tr'
                      ? l10n.get('turkish')
                      : l10n.get('english'),
                  iconColor: const Color(0xFF2ECC71),
                  showDivider: false,
                  onTap: () => _showLanguageDialog(l10n, isDark),
                ),
              ],
            ),
          ),

          // ==================== VERİ YÖNETİMİ ====================
          SettingsSectionHeader(title: l10n.get('data_management')),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Veriyi yeniden yükle
                SettingsTile(
                  icon: Icons.refresh,
                  title: l10n.get('reload_data'),
                  iconColor: const Color(0xFF3498DB),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UploadScreen(),
                      ),
                    );
                  },
                ),

                // Önbelleği temizle
                SettingsTile(
                  icon: Icons.cleaning_services_outlined,
                  title: l10n.get('clear_cache'),
                  iconColor: const Color(0xFFF39C12),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.get('cache_cleared')),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),

                // Verileri sil
                SettingsTile(
                  icon: Icons.delete_outline,
                  title: l10n.get('delete_data'),
                  iconColor: const Color(0xFFE74C3C),
                  showDivider: false,
                  onTap: () => _showDeleteConfirmDialog(l10n, isDark),
                ),
              ],
            ),
          ),

          // ==================== YARDIM ====================
          SettingsSectionHeader(
            title: l10n.get('help_and_support') == 'help_and_support'
                ? 'Help & Support'
                : l10n.get('help_and_support'),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                SettingsTile(
                  icon: Icons.help_outline,
                  title: l10n.get('faq') == 'faq' ? 'FAQ' : l10n.get('faq'),
                  iconColor: const Color(0xFF9B59B6),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FAQScreen()),
                    );
                  },
                ),
                SettingsTile(
                  icon: Icons.mail_outline,
                  title: l10n.get('contact') == 'contact'
                      ? 'Contact'
                      : l10n.get('contact'),
                  iconColor: const Color(0xFFE67E22),
                  showDivider: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ContactScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          // ==================== YASAL ====================
          SettingsSectionHeader(
            title: l10n.get('legal') == 'legal' ? 'Legal' : l10n.get('legal'),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: l10n.get('privacy_policy') == 'privacy_policy'
                      ? 'Privacy Policy'
                      : l10n.get('privacy_policy'),
                  iconColor: const Color(0xFF27AE60),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PrivacyPolicyScreen(),
                      ),
                    );
                  },
                ),
                SettingsTile(
                  icon: Icons.description_outlined,
                  title: l10n.get('terms_of_use') == 'terms_of_use'
                      ? 'Terms of Use'
                      : l10n.get('terms_of_use'),
                  iconColor: const Color(0xFF7F8C8D),
                  showDivider: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TermsOfUseScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 100), // Bottom nav için boşluk
        ],
      ),
    );
  }

  /// Dil seçim dialog'u
  void _showLanguageDialog(AppLocalizations l10n, bool isDark) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.get('language'),
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇹🇷', style: TextStyle(fontSize: 24)),
              title: Text(
                l10n.get('turkish'),
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              trailing: l10n.locale.languageCode == 'tr'
                  ? Icon(Icons.check_circle, color: AppColors.darkPrimary)
                  : null,
              onTap: () {
                Navigator.pop(dialogContext);
                // Dil değiştir - Türkçe
                final settingsProvider = Provider.of<AppSettingsProvider>(
                  context,
                  listen: false,
                );
                settingsProvider.setLanguage(AppLanguage.turkish);
              },
            ),
            ListTile(
              leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
              title: Text(
                l10n.get('english'),
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              trailing: l10n.locale.languageCode == 'en'
                  ? Icon(Icons.check_circle, color: AppColors.darkPrimary)
                  : null,
              onTap: () {
                Navigator.pop(dialogContext);
                // Dil değiştir - İngilizce
                final settingsProvider = Provider.of<AppSettingsProvider>(
                  context,
                  listen: false,
                );
                settingsProvider.setLanguage(AppLanguage.english);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Silme onay dialog'u
  void _showDeleteConfirmDialog(AppLocalizations l10n, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            const SizedBox(width: 8),
            Text(
              l10n.get('delete_data'),
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          l10n.get('confirm_delete'),
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        actions: [
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
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              // Verileri temizle
              await context.read<InstagramDataProvider>().clearData();

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.get('data_deleted')),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                ),
              );

              // Welcome ekranına yönlendir ve geçmişi sil
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.get('yes')),
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
    // Provider verilerini al
    final dataProvider = Provider.of<InstagramDataProvider>(
      context,
      listen: false,
    );
    final notFollowingBack = dataProvider.notFollowingBack;

    // Unfollower listesini oluştur (Not Following Back listesi)
    final unfollowers = notFollowingBack.map((username) {
      return Unfollower(
        username: username,
        unfollowedAt: DateTime.now(), // Tam tarih ZIP'te yok
        daysSinceUnfollow: 0,
      );
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnalyzeDropScreen(
          unfollowersCount: notFollowingBack.length,
          unfollowers: unfollowers,
        ),
      ),
    );
  }

  void _navigateToGhostFollowers(BuildContext context) {
    // Provider verilerini al
    final dataProvider = Provider.of<InstagramDataProvider>(
      context,
      listen: false,
    );
    final ghostFollowers = dataProvider.ghostFollowersList;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GhostFollowersScreen(
          ghostCount: ghostFollowers.length,
          ghostFollowers: ghostFollowers,
        ),
      ),
    );
  }
}
