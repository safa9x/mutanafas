import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/journal_model.dart';
import '../../providers/journal_provider.dart';
import '../../core/theme/app_colors.dart';

class EditJournalScreen extends ConsumerStatefulWidget {
  final Journal journal;

  const EditJournalScreen({
    super.key,
    required this.journal,
  });

  @override
  ConsumerState<EditJournalScreen> createState() => _EditJournalScreenState();
}

class _EditJournalScreenState extends ConsumerState<EditJournalScreen> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.journal.content);
  }

  Future<void> update() async {
    await ref.read(journalProvider.notifier).updateJournal(
          Journal(
            id: widget.journal.id,
            content: controller.text,
            createdAt: widget.journal.createdAt,
          ),
        );

    if (mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              "تم التعديل",
              style: GoogleFonts.cairo(),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? AppColors.darkBackground : AppColors.primary;

    final pageBg =
        isDark ? AppColors.darkBackground : const Color(0xFFF6FBF8);

    final cardColor = isDark ? const Color(0xFF222222) : Colors.white;

    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,

        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            "تعديل التدوينة",
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: update,
              icon: const Icon(Icons.check, color: Colors.white),
            ),
          ],
        ),

        body: Container(
          decoration: BoxDecoration(
            color: pageBg,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    height: 2,
                    color: textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: "عدّل تدوينتك بهدوء ",
                    hintStyle: GoogleFonts.cairo(
                      color: textSecondary,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}