import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../models/worship_detail_item.dart';

class WorshipDetailScreen extends StatefulWidget {
  final String title;
  final List<WorshipDetailItem> items;

  const WorshipDetailScreen({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  State<WorshipDetailScreen> createState() =>
      _WorshipDetailScreenState();
}

class _WorshipDetailScreenState extends State<WorshipDetailScreen> {
  late List<int> counters;

  @override
  void initState() {
    super.initState();
    counters = widget.items.map((e) => e.repeat).toList();
  }

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  Color _introColor(bool isDark) =>
      AppColors.background(isDark);

  void _decrement(int index) {
    if (counters[index] > 0) {
      setState(() => counters[index]--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark(context);

    final background = AppColors.background(isDark);
    final card = AppColors.card(isDark);
    final textPrimary = AppColors.textPrimary(isDark);
    final textSecondary = AppColors.textSecondary(isDark);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,

        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.primary,
          title: Text(
            widget.title,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            final item = widget.items[index];
            final isIntroCard = index == 0;

            return _buildItemCard(
              item,
              index,
              isIntroCard,
              isDark,
              card,
              textPrimary,
              textSecondary,
            );
          },
        ),
      ),
    );
  }

  // ================= ITEM CARD =================
  Widget _buildItemCard(
    WorshipDetailItem item,
    int index,
    bool isIntroCard,
    bool isDark,
    Color card,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: isIntroCard
            ? _introColor(isDark)
            : card,

        borderRadius: BorderRadius.circular(24),

        border: isIntroCard
            ? Border.all(
                color: isDark
                    ? AppColors.blue.withOpacity(0.4)
                    : const Color(0xFFE0C9A6),
                width: 1.2,
              )
            : null,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              isDark ? 0.2 : 0.05,
            ),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ================= TEXT =================
          Text(
            item.text,
            textAlign: TextAlign.justify,
            style: GoogleFonts.cairo(
              fontSize: isIntroCard ? 16 : 17,
              height: 2,
              color: textPrimary,
              fontWeight:
                  isIntroCard ? FontWeight.w700 : FontWeight.w500,
            ),
          ),

          // ================= COUNTER =================
          if (item.repeat > 1) ...[
            const SizedBox(height: 22),

            Center(
              child: GestureDetector(
                onTap: () => _decrement(index),

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 68,
                  height: 68,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: counters[index] == 0
                        ? AppColors.success
                        : AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),

                  child: Center(
                    child: counters[index] == 0
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 30,
                          )
                        : Text(
                            "${counters[index]}",
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}