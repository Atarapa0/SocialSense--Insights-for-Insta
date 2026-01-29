import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';
import 'package:socialsense/core/localization/app_localizations.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    // SocialSense content
    final faqs = [
      {
        'question': 'Verilerim güvende mi?',
        'answer':
            'Evet, SocialSense verilerinizi sadece cihazınızda yerel olarak işler. Hiçbir veriniz sunucularımıza yüklenmez veya üçüncü taraflarla paylaşılmaz. Tüm analizler telefonunuzun içinde gerçekleşir.',
      },
      {
        'question': 'Verilerimi nasıl yüklerim?',
        'answer':
            'Instagram ayarlarından "Bilgilerini İndir" seçeneği ile verilerinizi JSON formatında indirin. Size gelen e-postadaki ZIP dosyasını SocialSense içindeki "Veri Yükle" alanından seçin.',
      },
      {
        'question': 'Hayalet Takipçi nedir?',
        'answer':
            'Sizi takip eden ancak gönderilerinizi beğenmeyen veya yorum yapmayan kullanıcılardır. Bu analiz, son gönderilerinizdeki etkileşimlere dayanarak listelenir.',
      },
      {
        'question': 'Analizler ne kadar doğru?',
        'answer':
            'Analizler doğrudan Instagram\'dan indirdiğiniz resmi veriler üzerinden yapılır, bu nedenle %100 doğrudur. Uygulama sadece bu verileri okuyarak size anlamlı grafikler sunar.',
      },
      {
        'question': 'Uygulama ücretli mi?',
        'answer':
            'SocialSense şu anda tamamen ücretsizdir ve tüm analizlere erişebilirsiniz.',
      },
    ];

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
          l10n.get('faq') == 'faq' ? 'FAQ' : l10n.get('faq'),
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
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
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  faq['question']!,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                iconColor: isDark
                    ? AppColors.darkPrimary
                    : AppColors.lightPrimary,
                collapsedIconColor: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      faq['answer']!,
                      style: TextStyle(
                        height: 1.5,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
