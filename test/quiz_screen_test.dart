import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:project_uas/data/dummy_questions.dart';
import 'package:project_uas/providers/quiz_provider.dart';
import 'package:project_uas/providers/theme_provider.dart';
import 'package:project_uas/screens/quiz_screen.dart';
import 'package:project_uas/theme/app_theme.dart';
import 'package:project_uas/widgets/answer_option_tile.dart';
import 'package:project_uas/widgets/primary_button.dart';
import 'package:project_uas/widgets/progress_header.dart';
import 'package:project_uas/widgets/question_card.dart';

void main() {
  Widget createQuizScreenApp({
    QuizProvider? quizProvider,
    ThemeProvider? themeProvider,
    VoidCallback? onQuizFinished,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => themeProvider ?? ThemeProvider(),
        ),
        ChangeNotifierProvider<QuizProvider>(
          create: (_) => quizProvider ?? QuizProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: theme.themeMode,
            home: QuizScreen(
              onQuizFinished: onQuizFinished,
            ),
          );
        },
      ),
    );
  }

  group('QuizScreen Rendering & Structure', () {
    testWidgets('renders all initial quiz elements correctly on question 1', (tester) async {
      final quiz = QuizProvider();
      quiz.setUserName('Budi');

      await tester.pumpWidget(createQuizScreenApp(quizProvider: quiz));
      await tester.pumpAndSettle();

      // Memastikan AppBar dan judul kuis tampil
      expect(find.text('Kuis Pengetahuan Umum'), findsOneWidget);

      // Memastikan ProgressHeader menampilkan Soal 1 dari 10
      expect(find.byType(ProgressHeader), findsOneWidget);
      expect(find.text('Soal 1'), findsOneWidget);
      expect(find.text('dari 10'), findsOneWidget);

      // Memastikan QuestionCard memuat pertanyaan pertama dummyQuestions
      expect(find.byType(QuestionCard), findsOneWidget);
      expect(find.text(dummyQuestions[0].text), findsOneWidget);

      // Memastikan 4 opsi jawaban tampil
      expect(find.byType(AnswerOptionTile), findsNWidgets(4));
      for (final option in dummyQuestions[0].options) {
        expect(find.text(option), findsOneWidget);
      }

      // Memastikan tombol Sebelumnya (disabled pada soal 1) dan Selanjutnya (enabled)
      expect(find.text('Sebelumnya'), findsOneWidget);
      expect(find.text('Selanjutnya'), findsOneWidget);
      expect(find.text('Selesai'), findsNothing);
    });

    testWidgets('tombol Sebelumnya disabled pada nomor 1', (tester) async {
      final quiz = QuizProvider();
      await tester.pumpWidget(createQuizScreenApp(quizProvider: quiz));
      await tester.pumpAndSettle();

      final previousBtnFinder = find.widgetWithText(PrimaryButton, 'Sebelumnya');
      expect(previousBtnFinder, findsOneWidget);

      final prevBtnWidget = tester.widget<PrimaryButton>(previousBtnFinder);
      expect(prevBtnWidget.onPressed, isNull);
    });
  });

  group('QuizScreen Answer Selection & Modification', () {
    testWidgets('selecting an answer updates state and visual highlight', (tester) async {
      final quiz = QuizProvider();
      await tester.pumpWidget(createQuizScreenApp(quizProvider: quiz));
      await tester.pumpAndSettle();

      expect(quiz.currentSelectedAnswer, isNull);

      // Tekan opsi pertama (indeks 0)
      final firstOptionText = dummyQuestions[0].options[0];
      await tester.tap(find.text(firstOptionText));
      await tester.pumpAndSettle();

      expect(quiz.currentSelectedAnswer, equals(0));
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

      // Mengubah jawaban ke opsi kedua (indeks 1) sebelum selesai
      final secondOptionText = dummyQuestions[0].options[1];
      await tester.tap(find.text(secondOptionText));
      await tester.pumpAndSettle();

      expect(quiz.currentSelectedAnswer, equals(1));
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });
  });

  group('QuizScreen Navigation', () {
    testWidgets('navigates next and previous properly', (tester) async {
      final quiz = QuizProvider();
      await tester.pumpWidget(createQuizScreenApp(quizProvider: quiz));
      await tester.pumpAndSettle();

      // Pilih jawaban di soal 1
      await tester.tap(find.text(dummyQuestions[0].options[2]));
      await tester.pumpAndSettle();

      // Tekan "Selanjutnya"
      await tester.ensureVisible(find.widgetWithText(PrimaryButton, 'Selanjutnya'));
      await tester.tap(find.widgetWithText(PrimaryButton, 'Selanjutnya'));
      await tester.pumpAndSettle();

      // Sekarang di soal 2
      expect(quiz.currentQuestionIndex, equals(1));
      expect(find.text('Soal 2'), findsOneWidget);
      expect(find.text(dummyQuestions[1].text), findsOneWidget);

      // Tombol Sebelumnya kini aktif
      final prevBtnWidget = tester.widget<PrimaryButton>(
        find.widgetWithText(PrimaryButton, 'Sebelumnya'),
      );
      expect(prevBtnWidget.onPressed, isNotNull);

      // Tekan "Sebelumnya" untuk kembali ke soal 1
      await tester.ensureVisible(find.widgetWithText(PrimaryButton, 'Sebelumnya'));
      await tester.tap(find.widgetWithText(PrimaryButton, 'Sebelumnya'));
      await tester.pumpAndSettle();

      // Kembali di soal 1 dan jawaban yang dipilih tetap terpelihara
      expect(quiz.currentQuestionIndex, equals(0));
      expect(quiz.currentSelectedAnswer, equals(2));
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('shows Selesai button on question 10', (tester) async {
      final quiz = QuizProvider();
      // Langsung menuju ke soal terakhir (indeks 9)
      quiz.goToQuestion(9);

      await tester.pumpWidget(createQuizScreenApp(quizProvider: quiz));
      await tester.pumpAndSettle();

      expect(find.text('Soal 10'), findsOneWidget);
      expect(find.text('Selanjutnya'), findsNothing);
      expect(find.widgetWithText(PrimaryButton, 'Selesai'), findsOneWidget);
    });
  });

  group('QuizScreen Submission Flow', () {
    testWidgets('shows warning dialog when submitting with unanswered questions', (tester) async {
      final quiz = QuizProvider();
      quiz.goToQuestion(9);

      await tester.pumpWidget(createQuizScreenApp(quizProvider: quiz));
      await tester.pumpAndSettle();

      // Tekan tombol Selesai saat belum semua soal terjawab
      await tester.ensureVisible(find.widgetWithText(PrimaryButton, 'Selesai'));
      await tester.tap(find.widgetWithText(PrimaryButton, 'Selesai'));
      await tester.pumpAndSettle();

      // Dialog konfirmasi muncul
      expect(find.text('Selesaikan Kuis Sekarang?'), findsOneWidget);
      expect(find.text('Periksa Kembali'), findsOneWidget);
      expect(find.text('Ya, Selesaikan'), findsOneWidget);

      // Tekan Periksa Kembali
      await tester.tap(find.text('Periksa Kembali'));
      await tester.pumpAndSettle();

      expect(find.text('Selesaikan Kuis Sekarang?'), findsNothing);
      expect(quiz.isCompleted, isFalse);
    });

    testWidgets('completes quiz when confirming submission in warning dialog', (tester) async {
      bool finishedCalled = false;
      final quiz = QuizProvider();
      quiz.goToQuestion(9);

      await tester.pumpWidget(createQuizScreenApp(
        quizProvider: quiz,
        onQuizFinished: () {
          finishedCalled = true;
        },
      ));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.widgetWithText(PrimaryButton, 'Selesai'));
      await tester.tap(find.widgetWithText(PrimaryButton, 'Selesai'));
      await tester.pumpAndSettle();

      // Konfirmasi Ya, Selesaikan
      await tester.tap(find.text('Ya, Selesaikan'));
      await tester.pumpAndSettle();

      expect(quiz.isCompleted, isTrue);
      expect(finishedCalled, isTrue);
    });

    testWidgets('directly completes quiz without warning when all answered', (tester) async {
      bool finishedCalled = false;
      final quiz = QuizProvider();
      // Jawab seluruh 10 soal
      for (var i = 0; i < 10; i++) {
        quiz.selectAnswerFor(i, 0);
      }
      quiz.goToQuestion(9);

      await tester.pumpWidget(createQuizScreenApp(
        quizProvider: quiz,
        onQuizFinished: () {
          finishedCalled = true;
        },
      ));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.widgetWithText(PrimaryButton, 'Selesai'));
      await tester.tap(find.widgetWithText(PrimaryButton, 'Selesai'));
      await tester.pumpAndSettle();

      // Tidak menampilkan dialog peringatan belum terjawab
      expect(find.text('Selesaikan Kuis Sekarang?'), findsNothing);
      expect(quiz.isCompleted, isTrue);
      expect(finishedCalled, isTrue);
    });
  });

  group('QuizScreen Back Navigation Confirmation', () {
    testWidgets('shows exit confirmation dialog on back press and can cancel', (tester) async {
      final quiz = QuizProvider();
      await tester.pumpWidget(createQuizScreenApp(quizProvider: quiz));
      await tester.pumpAndSettle();

      // Tekan tombol kembali di AppBar
      await tester.tap(find.byTooltip('Kembali'));
      await tester.pumpAndSettle();

      expect(find.text('Keluar dari Kuis?'), findsOneWidget);
      expect(find.text('Lanjutkan Kuis'), findsOneWidget);
      expect(find.text('Keluar'), findsOneWidget);

      // Tekan Lanjutkan Kuis
      await tester.tap(find.text('Lanjutkan Kuis'));
      await tester.pumpAndSettle();

      // Dialog tertutup dan masih berada di layar kuis
      expect(find.text('Keluar dari Kuis?'), findsNothing);
      expect(find.byType(QuizScreen), findsOneWidget);
    });
  });

  group('QuizScreen Theme & Responsiveness', () {
    testWidgets('toggles theme mode from AppBar action', (tester) async {
      final themeProvider = ThemeProvider();
      final quiz = QuizProvider();

      await tester.pumpWidget(createQuizScreenApp(
        quizProvider: quiz,
        themeProvider: themeProvider,
      ));
      await tester.pumpAndSettle();

      expect(themeProvider.isDarkMode, isFalse);

      // Tekan tombol toggle tema
      await tester.tap(find.byTooltip('Beralih ke Mode Gelap'));
      await tester.pumpAndSettle();

      expect(themeProvider.isDarkMode, isTrue);
      expect(find.byTooltip('Beralih ke Mode Terang'), findsOneWidget);
    });

    testWidgets('renders cleanly on landscape screen without overflow', (tester) async {
      tester.view.physicalSize = const Size(844, 390);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final quiz = QuizProvider();
      await tester.pumpWidget(createQuizScreenApp(quizProvider: quiz));
      await tester.pumpAndSettle();

      expect(find.byType(QuizScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders cleanly on small compact screen without overflow', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final quiz = QuizProvider();
      await tester.pumpWidget(createQuizScreenApp(quizProvider: quiz));
      await tester.pumpAndSettle();

      expect(find.byType(QuizScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
