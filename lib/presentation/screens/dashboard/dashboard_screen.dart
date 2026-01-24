import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialsense/core/constants/app_colors.dart';
import 'package:socialsense/core/localization/app_localizations.dart';
import 'package:socialsense/core/providers/instagram_data_provider.dart';
import 'package:socialsense/presentation/screens/upload/upload_screen.dart';
import 'package:socialsense/presentation/screens/analyze/analyze_drop_screen.dart';
import 'package:socialsense/presentation/widgets/dashboard/priority_card.dart';
import 'package:socialsense/presentation/widgets/dashboard/activity_hours_card.dart';
import 'package:socialsense/presentation/widgets/dashboard/stats_row.dart';
import 'package:socialsense/presentation/widgets/dashboard/top_fans_card.dart';
import 'package:socialsense/presentation/widgets/dashboard/active_hour_card.dart';
import 'package:socialsense/presentation/widgets/reports/follower_details_card.dart';
import 'package:socialsense/presentation/widgets/reports/account_analysis_card.dart';
import 'package:socialsense/presentation/widgets/reports/sharing_analysis_card.dart';
import 'package:socialsense/presentation/widgets/reports/direct_messages_card.dart';
import 'package:socialsense/presentation/widgets/reports/activity_timeline_card.dart';
import 'package:socialsense/presentation/widgets/reports/interests_detail_card.dart';
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

  // Helper fonksiyon: veri yoksa "---" göster
  String _formatNumber(int? value) {
    if (value == null || value == 0) return '---';
    return value.toString();
  }

  String _formatPercent(double? value) {
    if (value == null || value == 0.0) return '---';
    return '${value.toStringAsFixed(1)}%';
  }

  // ============ REPORTS İÇİN GEÇİCİ PLACEHOLDER VERİLER ============
  // (ZIP'den okunamayan veriler için placeholder, sonra güncellenir)

  List<AccountAnalysis> get _mostLikedAccounts {
    final provider = Provider.of<InstagramDataProvider>(context, listen: false);
    final topLiked = provider.topLikedAccounts;
    if (topLiked.isEmpty) return [];
    return topLiked.entries
        .take(5)
        .map((e) => AccountAnalysis(username: '@${e.key}', count: e.value))
        .toList();
  }

  List<AccountAnalysis> get _mostCommentedAccounts {
    final provider = Provider.of<InstagramDataProvider>(context, listen: false);
    final topCommented = provider.topCommentedAccounts;
    if (topCommented.isEmpty) return [];
    return topCommented.entries
        .take(5)
        .map((e) => AccountAnalysis(username: '@${e.key}', count: e.value))
        .toList();
  }

  // Placeholder veriler (ZIP'de olmayan veriler)
  // Provider'dan alınan veriler
  DateTime? get _lastUpdateDate {
    final provider = Provider.of<InstagramDataProvider>(context, listen: false);
    return provider.lastUpdateDate;
  }

  int get _mutualFollowersCount {
    final provider = Provider.of<InstagramDataProvider>(context, listen: false);
    return provider.mutualFollowers.length;
  }

  List<String> get _mutualFollowers {
    final provider = Provider.of<InstagramDataProvider>(context, listen: false);
    return provider.mutualFollowers.take(3).map((u) => '@$u').toList();
  }

  int get _notFollowingYouCount {
    final provider = Provider.of<InstagramDataProvider>(context, listen: false);
    return provider.notFollowingBack.length;
  }

  List<String> get _notFollowingYou {
    final provider = Provider.of<InstagramDataProvider>(context, listen: false);
    return provider.notFollowingBack.take(3).map((u) => '@$u').toList();
  }

  int get _youDontFollowCount {
    final provider = Provider.of<InstagramDataProvider>(context, listen: false);
    return provider.youDontFollow.length;
  }

  List<String> get _youDontFollow {
    final provider = Provider.of<InstagramDataProvider>(context, listen: false);
    return provider.youDontFollow.take(3).map((u) => '@$u').toList();
  }

  // Placeholder veriler (ZIP'de olmayan veya henüz parse edilmeyen veriler)
  final List<SharingAnalysis> _receivedFromAccounts = [];
  final List<SharingAnalysis> _sentToAccounts = [];
  final int _totalChats = 0;
  final int _totalMessages = 0;
  final int _sentMessages = 0;
  final int _receivedMessages = 0;
  final List<MessageAnalysis> _mostMessaged = [];
  final List<MessageAnalysis> _mostMessagedBy = [];
  final List<ActivityDataPoint> _likeActivityData = [];
  final List<InterestCategory> _interestCategories = [];
  final List<SavedContentAccount> _savedContentAccounts = [];

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

  /// Ana sayfa içeriği (ESKİ TASARIM KORUNDU)
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ghost Followers (küçük versiyon)
              Expanded(
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
                      const Spacer(),
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
    final updateText = _lastUpdateDate != null
        ? '${l10n.get('last_update')}: ${_formatDate(_lastUpdateDate!)}'
        : '${l10n.get('last_update')}: ---';

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

  /// Raporlar içeriği (YENİ İÇERİKLER EKLENDİ)
  Widget _buildReportsContent(AppLocalizations l10n, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Başlık
          Row(
            children: [
              Icon(Icons.bar_chart, color: AppColors.darkPrimary, size: 24),
              const SizedBox(width: 10),
              Text(
                'Detaylı Raporlar',
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

          // Takipçi Detayları
          FollowerDetailsCard(
            mutualFollowersCount: _mutualFollowersCount,
            mutualFollowers: _mutualFollowers,
            notFollowingYouCount: _notFollowingYouCount,
            notFollowingYou: _notFollowingYou,
            youDontFollowCount: _youDontFollowCount,
            youDontFollow: _youDontFollow,
          ),

          const SizedBox(height: 24),

          // Hesap Analizleri
          AccountAnalysisCard(
            mostLikedCount: _mostLikedAccounts.length,
            mostLikedAccounts: _mostLikedAccounts,
            mostCommentedCount: _mostCommentedAccounts.length,
            mostCommentedAccounts: _mostCommentedAccounts,
          ),

          const SizedBox(height: 24),

          // Paylaşım Analizleri
          SharingAnalysisCard(
            receivedFromAccounts: _receivedFromAccounts,
            sentToAccounts: _sentToAccounts,
          ),

          const SizedBox(height: 24),

          // Direkt Mesajlar
          DirectMessagesCard(
            totalChats: _totalChats,
            totalMessages: _totalMessages,
            sentMessages: _sentMessages,
            receivedMessages: _receivedMessages,
            mostMessaged: _mostMessaged,
            mostMessagedBy: _mostMessagedBy,
          ),

          const SizedBox(height: 24),

          // Aktivite Zaman Çizelgesi Başlığı
          Text(
            'Aktivite Zaman Çizelgesi',
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
            title: 'Beğeni Aktivitesi',
            subtitle: 'Son 90 gün',
            dataPoints: _likeActivityData,
            lineColor: const Color(0xFFFF6B9D),
            hasData: true,
          ),

          const SizedBox(height: 16),

          // Yorum Aktivitesi Grafiği
          ActivityTimelineCard(
            title: 'Yorum Aktivitesi',
            subtitle: 'Son 90 gün',
            dataPoints: const [],
            lineColor: const Color(0xFF4ECDC4),
            hasData: false,
          ),

          const SizedBox(height: 24),

          // İlgi Alanları (Detaylı)
          InterestsDetailCard(
            totalInterests: 47,
            categories: _interestCategories,
          ),

          const SizedBox(height: 24),

          // Kayıtlı İçerikler (Detaylı)
          SavedContentDetailCard(
            totalSavedContent: 60,
            accounts: _savedContentAccounts,
            storyLikesCount: 60,
            storyLikesAccounts: _savedContentAccounts.take(5).toList(),
          ),

          const SizedBox(height: 100), // Bottom nav için boşluk
        ],
      ),
    );
  }

  /// Uyarılar listesi
  List<AlertItem> _alerts = [];

  @override
  void initState() {
    super.initState();
    _initializeAlerts();
  }

  void _initializeAlerts() {
    _alerts = [
      AlertItem(
        id: '1',
        type: AlertType.followerDrop,
        title: 'Takipçi Düşüşü',
        description: 'Son 7 günde 23 takipçi kaybettiniz',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        data: {'count': 23},
      ),
      AlertItem(
        id: '2',
        type: AlertType.ghostFollower,
        title: 'Hayalet Takipçi Uyarısı',
        description: 'Hayalet takipçi oranınız %32 oldu',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        data: {'rate': 32},
      ),
      AlertItem(
        id: '3',
        type: AlertType.engagementDrop,
        title: 'Etkileşim Düşüşü',
        description: 'Etkileşim oranınız %1.8\'e düştü',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        data: {'rate': 1.8},
      ),
      AlertItem(
        id: '4',
        type: AlertType.activeHourChanged,
        title: 'Aktif Saat Değişti',
        description: 'Takipçileriniz artık 21:00\'da daha aktif',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        data: {'hour': 21},
      ),
      AlertItem(
        id: '5',
        type: AlertType.tip,
        title: 'İpucu',
        description:
            'Akşam saatlerinde paylaşım yaparak etkileşimi artırabilirsiniz',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
      ),
    ];
  }

  /// Uyarılar ekranı
  Widget _buildAlertsContent(AppLocalizations l10n, bool isDark) {
    if (_alerts.isEmpty) {
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

    final unreadCount = _alerts.where((a) => !a.isRead).length;

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
              if (_alerts.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _alerts.clear();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.get('clear_all')),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: isDark
                            ? AppColors.darkCard
                            : AppColors.lightTextPrimary,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.clear_all,
                    size: 18,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  label: Text(
                    l10n.get('clear_all'),
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Uyarılar listesi
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _alerts.length,
            itemBuilder: (context, index) {
              final alert = _alerts[index];
              return AlertCard(
                alert: alert,
                onTap: () {
                  setState(() {
                    _alerts[index] = alert.copyWith(isRead: true);
                  });
                },
                onDismiss: () {
                  setState(() {
                    _alerts.removeAt(index);
                  });
                },
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
                      // TODO: Tema değiştirme işlevi
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tema değiştirme yakında eklenecek'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    activeColor: AppColors.darkPrimary,
                  ),
                ),

                // Dil seçimi
                SettingsTile(
                  icon: Icons.language,
                  title: l10n.get('language'),
                  subtitle: l10n.locale == 'tr'
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

          // ==================== HAKKINDA ====================
          SettingsSectionHeader(title: l10n.get('about')),
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
                // Uygulama versiyonu
                SettingsTile(
                  icon: Icons.info_outline,
                  title: l10n.get('version'),
                  subtitle: '1.0.0',
                  iconColor: const Color(0xFF9B59B6),
                  onTap: null,
                  trailing: Text(
                    'v1.0.0',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextHint
                          : AppColors.lightTextHint,
                    ),
                  ),
                ),

                // Gizlilik politikası
                SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: l10n.get('privacy_policy'),
                  iconColor: const Color(0xFF1ABC9C),
                  onTap: () {
                    // TODO: Gizlilik politikası sayfasını aç
                  },
                ),

                // Kullanım koşulları
                SettingsTile(
                  icon: Icons.description_outlined,
                  title: l10n.get('terms_of_use'),
                  iconColor: const Color(0xFF34495E),
                  showDivider: false,
                  onTap: () {
                    // TODO: Kullanım koşulları sayfasını aç
                  },
                ),
              ],
            ),
          ),

          // ==================== YARDIM ====================
          SettingsSectionHeader(title: l10n.get('help')),
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
                // SSS
                SettingsTile(
                  icon: Icons.help_outline,
                  title: l10n.get('faq'),
                  iconColor: const Color(0xFF3498DB),
                  onTap: () {
                    // TODO: SSS sayfasını aç
                  },
                ),

                // İletişim
                SettingsTile(
                  icon: Icons.mail_outline,
                  title: l10n.get('contact'),
                  iconColor: const Color(0xFFE67E22),
                  showDivider: false,
                  onTap: () {
                    // TODO: İletişim sayfasını aç
                  },
                ),
              ],
            ),
          ),

          // ==================== UYGULAMA İŞLEMLERİ ====================
          const SizedBox(height: 16),
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
                // Uygulamayı değerlendir
                SettingsTile(
                  icon: Icons.star_outline,
                  title: l10n.get('rate_app'),
                  iconColor: const Color(0xFFF1C40F),
                  onTap: () {
                    // TODO: App Store/Play Store'a yönlendir
                  },
                ),

                // Uygulamayı paylaş
                SettingsTile(
                  icon: Icons.share_outlined,
                  title: l10n.get('share_app'),
                  iconColor: const Color(0xFF2ECC71),
                  showDivider: false,
                  onTap: () {
                    // TODO: Paylaşım sheet'i aç
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
      builder: (context) => AlertDialog(
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
              trailing: l10n.locale == 'tr'
                  ? Icon(Icons.check_circle, color: AppColors.darkPrimary)
                  : null,
              onTap: () {
                Navigator.pop(context);
                // TODO: Dil değiştirme
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
              trailing: l10n.locale == 'en'
                  ? Icon(Icons.check_circle, color: AppColors.darkPrimary)
                  : null,
              onTap: () {
                Navigator.pop(context);
                // TODO: Dil değiştirme
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
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.get('data_deleted')),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                ),
              );
              // Welcome ekranına yönlendir
              Navigator.pushReplacementNamed(context, '/');
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
