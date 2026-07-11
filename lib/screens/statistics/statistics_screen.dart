import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/worship_provider.dart';
import '../../providers/journal_provider.dart';
import '../../providers/statistics_provider.dart';
import '../../services/statistics_service.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();

  final StatisticsService _stats = StatisticsService();

  bool _played = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _player.dispose();
    super.dispose();
  }

  void _playSuccess() {
    if (_played) return;

    _played = true;

    _player.play(
      AssetSource('sounds/success.mp3'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? AppColors.darkBackground : AppColors.primary;

    final pageBg =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;

    final card = isDark ? AppColors.darkCard : Colors.white;

    final textPrimary = isDark ? AppColors.darkTextPrimary : Colors.black;

    final textSecondary = isDark ? AppColors.darkTextSecondary : Colors.grey;

    final worshipsAsync = ref.watch(worshipProvider);

    final journalsAsync = ref.watch(journalProvider);

    final breathingCount = ref.watch(breathingCountProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: bg,
          title: Text(
            'لوحة الإنجازات',
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: pageBg,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 10),

              // ================= HEADER =================

              Column(
                children: [
                  const Icon(
                    Icons.insights_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'إنجازاتك اليوم',
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'استمر، كل خطوة تقربك للأفضل ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ================= WORSHIP STATS =================
 
              worshipsAsync.when(
                data: (worships) {
                  final completed = _stats.completed(worships);

                  final total = _stats.total(worships);

                  final percent = _stats.progress(worships);

                  final isComplete = percent >= 1.0;

                  if (isComplete) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _playSuccess();
                    });
                  }

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      children: [
                        // ================= STAR =================

                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, _) {
                            final pulse = _controller.value;

                            final scale = 0.96 + (pulse * 0.07);

                            final rotate = pulse * 0.12;

                            return Transform.rotate(
                              angle: rotate,
                              child: Transform.scale(
                                scale: scale,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: isComplete
                                            ? Colors.amber.withOpacity(0.35)
                                            : Colors.amber.withOpacity(0.12),
                                        blurRadius: isComplete ? 30 : 14,
                                        spreadRadius: isComplete ? 6 : 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.star_rounded,
                                    size: 92,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 14),

                        Text(
                          '${(percent * 100).toStringAsFixed(0)}%',
                          style: GoogleFonts.cairo(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'نسبة الإنجاز',
                          style: GoogleFonts.cairo(
                            color: textSecondary,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _miniCard(
                                icon: Icons.check_circle,
                                title: 'المكتملة',
                                value: '$completed',
                                cardColor: card,
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _miniCard(
                                icon: Icons.list,
                                title: 'الإجمالي',
                                value: '$total',
                                cardColor: card,
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (e, _) => Text('خطأ: $e'),
              ),

              const SizedBox(height: 20),

              // ================= JOURNALS =================

              journalsAsync.when(
                data: (journals) {
                  return Center(
                    child: SizedBox(
                      width: 180,
                      child: _miniCard(
                        icon: Icons.book_rounded,
                        title: 'التدوينات',
                        value: '${journals.length}',
                        cardColor: card,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                    ),
                  );
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),

              const SizedBox(height: 16),

              // ================= BREATHING =================

              Center(
                child: SizedBox(
                  width: 180,
                  child: _miniCard(
                    icon: Icons.air,
                    title: 'جلسات التنفس',
                    value: '$breathingCount',
                    cardColor: card,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ================= MINI CARD =================

  Widget _miniCard({
    required IconData icon,
    required String title,
    required String value,
    required Color cardColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(    
        children: [
          Icon(
            icon,
            color: AppColors.primary,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
