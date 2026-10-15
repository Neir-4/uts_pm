import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_uas/main.dart';

void main() {
  testWidgets('App smoke test & theme toggle verification', (WidgetTester tester) async {
    // Build app dan render frame pertama
    await tester.pumpWidget(const MyApp());

    // Verifikasi bahwa judul Quiz Umum tampil
    expect(find.text('Quiz Umum'), findsOneWidget);

    // Verifikasi status awal tema terang
    expect(find.text('Mode Terang Aktif'), findsOneWidget);
    expect(find.text('Beralih ke Mode Gelap'), findsOneWidget);

    // Tap tombol toggle tema
    await tester.tap(find.text('Beralih ke Mode Gelap'));
    await tester.pumpAndSettle();

    // Verifikasi tema berhasil beralih ke mode gelap
    expect(find.text('Mode Gelap Aktif'), findsOneWidget);
    expect(find.text('Beralih ke Mode Terang'), findsOneWidget);

    // Tap tombol ikon appbar untuk beralih kembali ke mode terang
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    // Verifikasi kembali ke mode terang
    expect(find.text('Mode Terang Aktif'), findsOneWidget);
  });
}
