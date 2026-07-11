import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/breathing_provider.dart';

class ToolsScreen extends ConsumerStatefulWidget {
  const ToolsScreen({super.key});

  @override
  ConsumerState<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends ConsumerState<ToolsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Timer? _timer;
  Timer? _breathTimer;
  Timer? _coachTimer;

  bool _isRunning = false;
  bool _isPaused = false;
  bool _isInhale = true;

  int _secondsLeft = 0;

  int _selectedLevel = 2;

  final String _selectedMood = "😌 هادئ";

  String _coachText = "خذ نفسًا عميقًا بهدوء";

  final moods = [
    "😣 متوتر",
    "😌 هادئ",
  ];

  final List<String> coachTexts = [
    "حرّر التوتر من كتفيك",
    "ركّز على النفس الداخل",
    "دع أفكارك تمر بهدوء",
    "أنت الآن في مساحة آمنة",
    "تنفّس ببطء وهدوء",
    "كل زفير يخرج التوتر",
  ];

  final Map<int, int> durations = {
    1: 60,
    2: 180,
    3: 300,
  };

  final Map<int, Map<String, dynamic>> sessions = {
    1: {
      "title": "تهدئة القلق",
      "subtitle": "جلسة سريعة لاستعادة هدوئك",
      "icon": Icons.self_improvement,
    },
    2: {
      "title": "زيادة التركيز",
      "subtitle": "تنفّس يساعدك على تصفية الذهن",
      "icon": Icons.psychology,
    },
    3: {
      "title": "النوم العميق",
      "subtitle": "استرخاء كامل للجسم والعقل",
      "icon": Icons.nightlight_round,
    },
  };

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    _timer?.cancel();
    _breathTimer?.cancel();
    _coachTimer?.cancel();

    super.dispose();
  }

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  // ================= START =================

  void _start() {
    _timer?.cancel();
    _breathTimer?.cancel();
    _coachTimer?.cancel();

    if (!_isPaused) {
      _secondsLeft = durations[_selectedLevel]!;
    }

    setState(() {
      _isRunning = true;
      _isPaused = false;
      _isInhale = true;
    });

    _controller.repeat(reverse: true);

    _breathTimer = Timer.periodic(
      const Duration(seconds: 4),
      (timer) {
        if (!_isRunning) {
          timer.cancel();
          return;
        }

        setState(() {
          _isInhale = !_isInhale;
        });
      },
    );

    _coachTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        if (!_isRunning) {
          timer.cancel();
          return;
        }

        setState(() {
          _coachText = coachTexts[Random().nextInt(coachTexts.length)];
        });
      },
    );

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        if (_secondsLeft <= 0) {
          timer.cancel();

          await _finishSession();
        } else {
          setState(() {
            _secondsLeft--;
          });
        }
      },
    );
  }

  // ================= FINISH =================

  Future<void> _finishSession() async {
    _stop();

    if (!mounted) return;

    String moodAfter = "😌 هادئ";

    await showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "كيف تشعر الآن؟",
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: moods.map((mood) {
                          final selected = moodAfter == mood;

                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                moodAfter = mood;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primary
                                    : Colors.grey.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(
                                  16,
                                ),
                              ),
                              child: Text(
                                mood,
                                style: GoogleFonts.cairo(
                                  color: selected ? Colors.white : null,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () async {
                          await ref.read(breathingProvider.notifier).addSession(
                                duration: durations[_selectedLevel]!,
                                moodBefore: _selectedMood,
                                moodAfter: moodAfter,
                                sessionType: sessions[_selectedLevel]!["title"],
                              );

                          if (mounted) {
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                content: const Text(
                                  "✨ أحسنت.. انتهت الجلسة بنجاح",
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "إنهاء",
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ================= PAUSE =================

  void _pause() {
    _timer?.cancel();
    _breathTimer?.cancel();
    _coachTimer?.cancel();

    _controller.stop();

    setState(() {
      _isPaused = true;
      _isRunning = false;
    });
  }

  // ================= RESUME =================

  void _resume() {
    _start();
  }

  // ================= STOP =================

  void _stop() {
    _timer?.cancel();
    _breathTimer?.cancel();
    _coachTimer?.cancel();

    _controller.stop();

    setState(() {
      _isRunning = false;
      _isPaused = false;
      _secondsLeft = 0;
      _isInhale = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isDark ? AppColors.darkBackground : const Color(0xffeef7f4);

    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Text(
          "تنفّس",
          style: GoogleFonts.cairo(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.12,
                  child: CustomPaint(
                    painter: BackgroundPainter(),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // ================= BREATHING =================

                  Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (_, __) {
                        return Column(
                          children: [
                            Transform.scale(
                              scale: (_isRunning || _isPaused)
                                  ? (0.88 + _controller.value * 0.25)
                                  : 1,
                              child: Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      AppColors.primary.withOpacity(0.35),
                                      AppColors.primary.withOpacity(0.06),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppColors.primary.withOpacity(0.25),
                                      blurRadius: 40,
                                      spreadRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  sessions[_selectedLevel]!["icon"],
                                  size: 70,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              _isRunning || _isPaused
                                  ? (_isInhale ? "شهيق" : "زفير")
                                  : sessions[_selectedLevel]!["title"],
                              style: GoogleFonts.cairo(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(
                                  milliseconds: 500,
                                ),
                                child: Text(
                                  _coachText,
                                  key: ValueKey(_coachText),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.cairo(
                                    fontSize: 15,
                                    color: textSecondary,
                                    height: 1.8,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (_isRunning || _isPaused)
                              Text(
                                "${_secondsLeft ~/ 60}:${(_secondsLeft % 60).toString().padLeft(2, '0')}",
                                style: GoogleFonts.cairo(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ================= SESSIONS =================

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        _sessionCard(1),
                        const SizedBox(height: 12),
                        _sessionCard(2),
                        const SizedBox(height: 12),
                        _sessionCard(3),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= BUTTONS =================

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: () {
                              if (!_isRunning && !_isPaused) {
                                _start();
                              } else if (_isRunning) {
                                _pause();
                              } else {
                                _resume();
                              }
                            },
                            child: Text(
                              _isRunning
                                  ? "إيقاف مؤقت"
                                  : (_isPaused ? "استكمال" : "ابدأ الجلسة"),
                              style: GoogleFonts.cairo(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: IconButton(
                            onPressed: _stop,
                            icon: const Icon(
                              Icons.stop_rounded,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SESSION CARD =================

  Widget _sessionCard(int level) {
    final data = sessions[level]!;

    final selected = _selectedLevel == level;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLevel = level;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withOpacity(0.2)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                data["icon"],
                color: selected ? Colors.white : AppColors.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data["title"],
                    style: GoogleFonts.cairo(
                      color: selected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data["subtitle"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: selected ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              level == 1
                  ? "1m"
                  : level == 2
                      ? "3m"
                      : "5m",
              style: GoogleFonts.cairo(
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= BACKGROUND =================

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary.withOpacity(0.12);

    for (double i = 0; i < size.width; i += 40) {
      for (double j = 0; j < size.height; j += 60) {
        canvas.drawCircle(
          Offset(i, j),
          2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
