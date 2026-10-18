import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_uas/theme/app_theme.dart';
import 'package:project_uas/widgets/answer_option_tile.dart';
import 'package:project_uas/widgets/progress_header.dart';
import 'package:project_uas/widgets/question_card.dart';

void main() {
  Widget buildTestableWidget(Widget child, {bool isDark = false}) {
    return MaterialApp(
      theme: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }

  group('ProgressHeader Widget Tests', () {
    testWidgets('renders question number and total count accurately', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const ProgressHeader(
            currentQuestionIndex: 2, // Soal ke-3
            totalQuestions: 10,
            answeredCount: 3,
          ),
        ),
      );

      expect(find.text('Soal 3'), findsOneWidget);
      expect(find.text('dari 10'), findsOneWidget);
      expect(find.text('30%'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('displays answered count and calculates percentage from answered questions', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const ProgressHeader(
            currentQuestionIndex: 4, // Sedang mengerjakan soal 5
            totalQuestions: 10,
            answeredCount: 3, // 3 soal terjawab -> 30%, bukan 50%
          ),
        ),
      );

      expect(find.text('3/10 Terjawab'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
      expect(find.text('30%'), findsOneWidget);
      expect(find.text('50%'), findsNothing);
    });

    testWidgets('shows 0% when no questions answered regardless of current question index', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const ProgressHeader(
            currentQuestionIndex: 7, // Sedang mengerjakan soal 8
            totalQuestions: 10,
            answeredCount: 0,
          ),
        ),
      );

      expect(find.text('Soal 8'), findsOneWidget);
      expect(find.text('0%'), findsOneWidget);
      expect(find.text('80%'), findsNothing);
    });

    testWidgets('uses explicit progress value when provided and clamps safely', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const ProgressHeader(
            currentQuestionIndex: 0,
            totalQuestions: 10,
            progress: 0.85,
          ),
        ),
      );

      expect(find.text('85%'), findsOneWidget);
      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, 0.85);
    });

    testWidgets('handles edge case of 0 total questions safely', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const ProgressHeader(
            currentQuestionIndex: 0,
            totalQuestions: 0,
          ),
        ),
      );

      expect(find.text('Soal 1'), findsOneWidget);
      expect(find.text('dari 0'), findsOneWidget);
      expect(find.text('0%'), findsOneWidget);
    });
  });

  group('QuestionCard Widget Tests', () {
    testWidgets('renders question text and header badge', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const QuestionCard(
            questionText: 'Apa nama ibu kota negara Indonesia?',
            questionNumber: 1,
          ),
        ),
      );

      expect(find.text('Apa nama ibu kota negara Indonesia?'), findsOneWidget);
      expect(find.text('Pertanyaan #1'), findsOneWidget);
      expect(find.byIcon(Icons.help_outline_rounded), findsOneWidget);
    });

    testWidgets('renders category badge when provided', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const QuestionCard(
            questionText: 'Berapakah hasil dari 12 x 12?',
            questionNumber: 5,
            category: 'Matematika',
            icon: Icons.calculate_outlined,
          ),
        ),
      );

      expect(find.text('Matematika'), findsOneWidget);
      expect(find.byIcon(Icons.calculate_outlined), findsOneWidget);
    });
  });

  group('AnswerOptionTile Widget Tests', () {
    testWidgets('renders letter badge and option text', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const AnswerOptionTile(
            optionIndex: 0,
            optionText: 'Jakarta',
            isSelected: false,
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.text('Jakarta'), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_unchecked_rounded), findsOneWidget);
    });

    testWidgets('converts indices to letters A, B, C, D automatically', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          Column(
            children: const [
              AnswerOptionTile(optionIndex: 0, optionText: 'Opsi 1', isSelected: false),
              AnswerOptionTile(optionIndex: 1, optionText: 'Opsi 2', isSelected: false),
              AnswerOptionTile(optionIndex: 2, optionText: 'Opsi 3', isSelected: false),
              AnswerOptionTile(optionIndex: 3, optionText: 'Opsi 4', isSelected: false),
            ],
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
    });

    testWidgets('renders highlighted state when isSelected is true', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const AnswerOptionTile(
            optionIndex: 1,
            optionText: 'Nusantara',
            isSelected: true,
          ),
        ),
      );

      expect(find.text('B'), findsOneWidget);
      expect(find.text('Nusantara'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_unchecked_rounded), findsNothing);
    });

    testWidgets('triggers onTap callback when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        buildTestableWidget(
          AnswerOptionTile(
            optionIndex: 2,
            optionText: 'Bandung',
            isSelected: false,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('Bandung'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('does not trigger onTap callback when disabled', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        buildTestableWidget(
          AnswerOptionTile(
            optionIndex: 3,
            optionText: 'Surabaya',
            isSelected: false,
            isEnabled: false,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('Surabaya'));
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });
  });
}
