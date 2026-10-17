import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_uas/theme/app_theme.dart';
import 'package:project_uas/widgets/score_card.dart';

void main() {
  Widget buildTestableWidget(Widget child, {bool isDark = false}) {
    return MaterialApp(
      theme: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: Scaffold(
        body: SingleChildScrollView(
          child: child,
        ),
      ),
    );
  }

  group('ScoreCard Widget Tests', () {
    testWidgets('renders score and percentage accurately', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const ScoreCard(
            score: 8,
            totalQuestions: 10,
          ),
        ),
      );

      // Memastikan label SKOR AKHIR tampil
      expect(find.text('SKOR AKHIR'), findsOneWidget);

      // Memastikan angka skor 8 dan / 10 tampil
      expect(find.text('8'), findsNWidgets(2));
      expect(find.text(' / 10'), findsOneWidget);

      // Memastikan persentase otomatis dihitung (80%)
      expect(find.text('Nilai: 80%'), findsOneWidget);
    });

    testWidgets('uses explicit percentage and percentageFormatted when provided',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const ScoreCard(
            score: 7,
            totalQuestions: 10,
            percentage: 70.0,
            percentageFormatted: '70%',
          ),
        ),
      );

      expect(find.text('7'), findsNWidgets(2));
      expect(find.text(' / 10'), findsOneWidget);
      expect(find.text('Nilai: 70%'), findsOneWidget);
    });

    testWidgets('renders correct and wrong breakdown stats properly',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const ScoreCard(
            score: 7,
            totalQuestions: 10,
            correctCount: 7,
            wrongCount: 3,
          ),
        ),
      );

      // Memastikan label stat
      expect(find.text('Benar'), findsOneWidget);
      expect(find.text('7'), findsNWidgets(2));
      expect(find.text('Salah'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      // Terlewat tidak muncul karena bernilai 0 / default
      expect(find.text('Terlewat'), findsNothing);
    });

    testWidgets('renders unanswered / terlewat count when > 0', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const ScoreCard(
            score: 5,
            totalQuestions: 10,
            correctCount: 5,
            wrongCount: 3,
            unansweredCount: 2,
          ),
        ),
      );

      expect(find.text('Benar'), findsOneWidget);
      expect(find.text('5'), findsNWidgets(2));
      expect(find.text('Salah'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('Terlewat'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('renders participant name when userName is provided',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const ScoreCard(
            score: 10,
            totalQuestions: 10,
            userName: 'Yehezkiel',
          ),
        ),
      );

      expect(find.text('Nama Peserta'), findsOneWidget);
      expect(find.text('Yehezkiel'), findsOneWidget);
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
    });

    testWidgets('hides participant name header when userName is null or empty',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const ScoreCard(
            score: 10,
            totalQuestions: 10,
            userName: '',
          ),
        ),
      );

      expect(find.text('Nama Peserta'), findsNothing);
      expect(find.byIcon(Icons.person_outline_rounded), findsNothing);
    });

    testWidgets('renders evaluationMessage when provided', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const ScoreCard(
            score: 10,
            totalQuestions: 10,
            evaluationMessage: 'Selamat! Jawaban Anda sempurna!',
          ),
        ),
      );

      expect(find.text('Selamat! Jawaban Anda sempurna!'), findsOneWidget);
      expect(find.byIcon(Icons.chat_bubble_outline_rounded), findsOneWidget);
    });

    testWidgets('handles edge case: 0 totalQuestions without division by zero',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const ScoreCard(
            score: 0,
            totalQuestions: 0,
          ),
        ),
      );

      expect(find.text('0'), findsNWidgets(3));
      expect(find.text(' / 0'), findsOneWidget);
      expect(find.text('Nilai: 0%'), findsOneWidget);
    });

    testWidgets('renders cleanly in dark mode theme', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const ScoreCard(
            score: 9,
            totalQuestions: 10,
            userName: 'Budi',
          ),
          isDark: true,
        ),
      );

      expect(find.text('SKOR AKHIR'), findsOneWidget);
      expect(find.text('9'), findsNWidgets(2));
      expect(find.text(' / 10'), findsOneWidget);
      expect(find.text('Nilai: 90%'), findsOneWidget);
      expect(find.text('Budi'), findsOneWidget);
    });
  });
}
