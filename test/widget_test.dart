import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:mutanafas/main.dart';
import 'package:mutanafas/screens/worship/worship_screen.dart';

void main() {
  testWidgets('فتح تطبيق مُتنفّس ويعرض شاشة العبادات', (WidgetTester tester) async {
    // تشغيل التطبيق
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    // التأكد أن شاشة العبادات ظهرت
    expect(find.byType(WorshipScreen), findsOneWidget);

    // التأكد أن القائمة تظهر (على الأقل عنصر واحد)
    expect(find.byType(GestureDetector), findsWidgets);
  });
}