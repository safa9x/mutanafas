import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/worship_provider.dart';
import '../../data/worship_content.dart';
import '../../models/worship_detail_item.dart';
import 'package:mutanafas/screens/worship/worship_detail_screen.dart';

class WorshipScreen extends ConsumerStatefulWidget {
  const WorshipScreen({super.key});

  @override
  ConsumerState<WorshipScreen> createState() => _WorshipScreenState();
}

class _WorshipScreenState extends ConsumerState<WorshipScreen> {

  final List<IconData> iconList = [
    Icons.wb_sunny_rounded,
    Icons.nightlight_round,
    Icons.menu_book_rounded,
    Icons.dark_mode_rounded,
    Icons.sunny,
  ];

  int tasbeehCount = 0;

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final worshipAsync = ref.watch(worshipProvider);
    final actions = ref.read(worshipActionsProvider);

    final backgroundColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;

    final cardColor =
        isDark ? AppColors.darkCard : AppColors.lightCard;

    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,

        appBar: AppBar(
          backgroundColor: AppColors.primary,
          centerTitle: true,
          title: Text(
            'العبادات اليومية',
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: worshipAsync.when(
          data: (worships) {
            return ListView(
              padding: const EdgeInsets.all(16),

              children: [

                _buildHeader(textPrimary, textSecondary),

                const SizedBox(height: 20),

                ...List.generate(worships.length, (index) {

                  final item = worships[index];

                  final icon =
                      iconList[item.iconCode % iconList.length];

                  final bgColor = [
                    AppColors.iconBg1,
                    AppColors.iconBg2,
                    AppColors.iconBg3,
                    AppColors.iconBg4,
                    AppColors.iconBg5,
                  ][index % 5];

                  return _buildWorshipItem(
                    context,
                    item,
                    icon,
                    bgColor,
                    cardColor,
                    textPrimary,
                    actions,
                  );
                }),

                const SizedBox(height: 20),

                _buildTasbeeh(cardColor, textPrimary),
              ],
            );
          },

          loading: () =>
              const Center(child: CircularProgressIndicator()),

          error: (e, _) =>
              Center(child: Text('خطأ: $e')),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        children: [

          const Icon(
            Icons.auto_stories_rounded,
            color: AppColors.primary,
            size: 30,
          ),

          const SizedBox(height: 10),

          Text(
            '«أحب الأعمال إلى الله أدومها وإن قل»',
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'استمر ولو قليل يوميًا',
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ================= ITEM =================
  Widget _buildWorshipItem(
    BuildContext context,
    item,
    IconData icon,
    Color bgColor,
    Color cardColor,
    Color textPrimary,
    WorshipActions actions,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),

      onTap: () {
        final List<WorshipDetailItem> content =
            worshipData[item.name] ?? [];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorshipDetailScreen(
              title: item.name,
              items: content,
            ),
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Row(
          children: [

            GestureDetector(
              onTap: () {
                if (item.id == null) return;
                actions.toggle(item.id!, !item.isCompleted);
              },

              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accent),
                  color: item.isCompleted
                      ? AppColors.accent
                      : Colors.transparent,
                ),
                child: item.isCompleted
                    ? const Icon(Icons.check,
                        size: 16, color: Colors.white)
                    : null,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  Text(
                    item.name,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: item.isCompleted
                          ? Colors.grey
                          : textPrimary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'عرض التفاصيل',
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: AppColors.primary, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  // ================= TASBEEH =================
  Widget _buildTasbeeh(Color cardColor, Color textPrimary) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        children: [

          Text(
            'المسبحة الإلكترونية',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            width: 110,
            height: 110,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.4),
              ),
            ),

            child: Text(
              '$tasbeehCount',
              style: GoogleFonts.cairo(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              GestureDetector(
                onTap: () => setState(() => tasbeehCount++),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: const Icon(Icons.add,
                      color: Colors.white),
                ),
              ),

              const SizedBox(width: 14),

              GestureDetector(
                onTap: () => setState(() => tasbeehCount = 0),
                child: Container(
                  width: 50,
                  height: 50, 
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.primary),
                  ),
                  child: const Icon(Icons.refresh,
                      color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}