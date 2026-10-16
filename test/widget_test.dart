import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_uas/main.dart';

void main() {
  testWidgets('App smoke test & theme toggle verification on HomeScreen',
      (WidgetTester tester) async {
    // Build app dan render frame pertama
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verifikasi bahwa judul Quiz Umum tampil pada AppBar
    expect(find.text('Quiz Umum'), findsOneWidget);
    expect(find.text('Quiz Pengetahuan Umum'), findsOneWidget);
    expect(find.text('Mulai Kuis'), findsOneWidget);

    // Verifikasi tooltip awal tombol tema (Mode Terang -> tooltip: Ganti ke Mode Gelap)
    expect(find.byTooltip('Ganti ke Mode Gelap'), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);

    // Tap tombol toggle tema di AppBar
    await tester.tap(find.byTooltip('Ganti ke Mode Gelap'));
    await tester.pumpAndSettle();

    // Verifikasi ikon dan tooltip berubah ke mode terang
    expect(find.byTooltip('Ganti ke Mode Terang'), findsOneWidget);
    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);

    // Tap kembali untuk beralih ke mode terang
    await tester.tap(find.byTooltip('Ganti ke Mode Terang'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Ganti ke Mode Gelap'), findsOneWidget);
  });
}
