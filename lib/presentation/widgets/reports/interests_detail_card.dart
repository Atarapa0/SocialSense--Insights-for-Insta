import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';

/// İlgi Alanları Model
class InterestCategory {
  final String name;
  final int count;
  final List<String> subcategories;

  const InterestCategory({
    required this.name,
    required this.count,
    required this.subcategories,
  });
}

/// İlgi Alanları Detay Kartı (Raporlar için)
class InterestsDetailCard extends StatefulWidget {
  final int totalInterests;
  final List<InterestCategory> categories;

  const InterestsDetailCard({
    super.key,
    required this.totalInterests,
    required this.categories,
  });

  @override
  State<InterestsDetailCard> createState() => _InterestsDetailCardState();
}

class _InterestsDetailCardState extends State<InterestsDetailCard> {
  final Set<String> _expandedCategories = {};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Row(
            children: [
              Icon(Icons.interests, color: const Color(0xFFFF9800), size: 22),
              const SizedBox(width: 10),
              Text(
                'İlgi Alanların',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '(${widget.totalInterests})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF9800),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Kategoriler Grid
          _buildCategoriesGrid(isDark),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid(bool isDark) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: widget.categories.map((category) {
        final isExpanded = _expandedCategories.contains(category.name);

        return _buildCategoryCard(category, isExpanded, isDark);
      }).toList(),
    );
  }

  Widget _buildCategoryCard(
    InterestCategory category,
    bool isExpanded,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.5)
            : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder.withValues(alpha: 0.5)
              : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kategori başlığı
          GestureDetector(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedCategories.remove(category.name);
                } else {
                  _expandedCategories.add(category.name);
                }
              });
            },
            child: Row(
              children: [
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '(${category.count})',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const Spacer(),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20,
                  color: isDark
                      ? AppColors.darkTextHint
                      : AppColors.lightTextHint,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Alt kategoriler
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children:
                (isExpanded
                        ? category.subcategories
                        : category.subcategories.take(5).toList())
                    .map((subcategory) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard
                              : AppColors.lightCard,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                        ),
                        child: Text(
                          subcategory,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      );
                    })
                    .toList(),
          ),

          // Daha fazla göster
          if (!isExpanded && category.subcategories.length > 5) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _expandedCategories.add(category.name);
                });
              },
              child: Text(
                '+ ${category.subcategories.length - 5} daha',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.darkPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
