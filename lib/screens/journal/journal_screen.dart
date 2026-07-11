import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/journal_provider.dart';
import '../../models/journal_model.dart';
import 'add_journal_screen.dart';
import 'edit_journal_screen.dart';
import '../../core/theme/app_colors.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final journalsAsync = ref.watch(journalProvider);

    final pageBackground =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;

    final cardColor = isDark ? AppColors.darkCard : Colors.white;

    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: pageBackground,

        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            'مُتنفّسي',
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ), 
          ),
        ),

        body: Container(
          decoration: BoxDecoration(
            color: pageBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: journalsAsync.when(
            data: (journals) {
              if (journals.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        size: 90,
                        color: AppColors.primary.withOpacity(.4),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'ابدئي أول تدوينة 🤍',
                        style: GoogleFonts.cairo(
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: journals.length,
                itemBuilder: (context, index) {
                  final journal = journals[index];

                  final animation = Tween<Offset>(
                    begin: const Offset(0, .2),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Interval(
                        (index * .1).clamp(0, 1),
                        1,
                        curve: Curves.easeOut,
                      ),
                    ),
                  );

                  return FadeTransition(
                    opacity: _controller,
                    child: SlideTransition(
                      position: animation,
                      child: _card(
                        context,
                        ref,
                        journal,
                        cardColor,
                        textPrimary,
                        textSecondary,
                        isDark,
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (e, _) => Center(
              child: Text(e.toString()),
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddJournalScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context,
    WidgetRef ref,
    Journal journal,
    Color cardColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "تدوينة",
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            journal.content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cairo(
              fontSize: 15,
              height: 1.8,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 15),
          const Divider(
            thickness: 1.2,
            color: Color(0xFFCDEEE1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                journal.createdAt,
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  color: textSecondary,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    color: AppColors.primary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EditJournalScreen(journal: journal),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Text(
                              "تأكيد الحذف",
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            content: Text(
                              "هل أنت متأكدة من حذف هذه التدوينة؟",
                              style: GoogleFonts.cairo(
                                color: textSecondary,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text("إلغاء"),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text("حذف"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        await ref
                            .read(journalProvider.notifier)
                            .deleteJournal(journal.id!);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "تم الحذف ",
                                style: GoogleFonts.cairo(),
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}