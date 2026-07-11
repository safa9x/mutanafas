import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';


import '../screens/journal/journal_screen.dart';
import 'worship/worship_screen.dart';
import 'tools/tools_screen.dart';
import 'statistics/statistics_screen.dart';
import 'package:mutanafas/providers/theme_provider.dart';
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // ================= THEME =================
    final isDark =
        ref.watch(themeProvider) == ThemeMode.dark;

    final backgroundColor =
        isDark
            ? const Color(0xFF111827)
            : const Color(0xFFF8F6F2);

    final cardColor =
        isDark
            ? const Color(0xFF1F2937)
            : Colors.white;

    final textPrimary =
        isDark
            ? Colors.white
            : const Color(0xFF1E1E1E);

    // 💚 النص يبقى واضح بالدارك مود
    final textSecondary =
        isDark
            ? Colors.white
            : const Color(0xFF6B7280);

    const primaryColor = Color(0xFF3A7D6B);
    const secondaryColor = Color(0xFF6BA292);
    const accentColor = Color(0xFFD4A373);

    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor: backgroundColor,

        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                const SizedBox(height: 12),

                // ================= HEADER =================
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          'مُتنفّس',

                          style: GoogleFonts.cairo(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          _getGreeting(),

                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [

                        // ================= DARK MODE =================
                        Container(
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius:
                                BorderRadius.circular(16),

                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.black.withOpacity(
                                  0.05,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),

                          child: IconButton(
                            onPressed: () {
                              ref
                                  .read(themeProvider.notifier)
                                  .toggleTheme();
                            },

                            icon: Icon(
                              isDark
                                  ? Icons.light_mode_rounded
                                  : Icons.dark_mode_rounded,

                              color: primaryColor,
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // ================= LOGO =================
                        const Icon(
                          Icons.spa_rounded,
                          color: primaryColor,
                          size: 34,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // ================= HERO =================
                AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 400),

                  width: double.infinity,
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(30),

                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,

                      colors: [
                        primaryColor,
                        secondaryColor,
                      ],
                    ),

                    boxShadow: [
                      BoxShadow(
                        color:
                            primaryColor.withOpacity(0.25),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      const Icon(
                        Icons.favorite_border_rounded,
                        color: Colors.white,
                        size: 24,
                      ),

                      const SizedBox(height: 18),

                      Text(
                        'مساحتك الهادئة تبدأ هنا',

                        style: GoogleFonts.cairo(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'اكتب مشاعرك، تابع عاداتك، وابدأ يومك بسكينة ',

                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: Colors.white,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ================= TITLE =================
                Text(
                  'محتوى التطبيق',

                  style: GoogleFonts.cairo(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),

                const SizedBox(height: 18),

            // ================= GRID =================
                Expanded(
                  child: GridView(
                    physics: const BouncingScrollPhysics(),

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.85,
                    ),

                    children: [

                      _buildCard(
                        context,
                        title: 'العبادات',
                        subtitle: 'الأذكار اليومية',
                        icon: Icons.auto_stories_rounded,
                        color: primaryColor,
                        page: const WorshipScreen(),
                        cardColor: cardColor,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),

                      _buildCard(
                        context,
                        title: 'الكتابة',
                        subtitle: 'تفريغ المشاعر',
                        icon: Icons.edit_note_rounded,
                        color: accentColor,
                        page: const JournalScreen(),
                        cardColor: cardColor,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),

                      _buildCard(
                        context,
                        title: 'التنفس',
                        subtitle: 'Breathing & Calm',
                        icon: Icons.air_rounded,
                        color: Colors.blue,
                        page: const ToolsScreen(),
                        cardColor: cardColor,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),

                      _buildCard(
                        context,
                        title: 'الإحصائيات',
                        subtitle: 'تقدمك اليومي',
                        icon: Icons.bar_chart_rounded,
                        color: const Color(0xFF7C6AFA),
                        page: const StatisticsScreen(),
                        cardColor: cardColor,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= CARD =================
  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget page,
    required Color cardColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(22),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },

        child: Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),

                child: Icon(icon, color: color, size: 26),
              ),

              const SizedBox(height: 10),

              Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: textSecondary,
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: Text(
                  _getDescription(title),
                  style: GoogleFonts.cairo(
                    fontSize: 10,
                    height: 1.5,
                    color: textSecondary,
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomRight,

                child: Text(
                  'ابدأ →',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= DESCRIPTION =================
  String _getDescription(String title) {
    switch (title) {

      case 'العبادات':
        return 'تابع أذكارك اليومية وحافظ على ارتباطك الروحي.';

      case 'الكتابة':
        return 'اكتب يومك ومشاعرك بحرية وهدوء.';

      case 'التنفس':
        return 'تمارين تنفس تساعدك على الاسترخاء وتقليل التوتر.';

      case 'الإحصائيات':
        return 'شاهد تطورك اليومي بطريقة بسيطة وواضحة.';

      default:
        return '';
    }
  }
  // ================= GREETING =================
  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'صباح هادئ ومريح';
    }

    if (hour < 17) {
      return 'مساء مليء بالسكينة';
    }

    return 'ليلة هادئة لقلبك';
  }
}