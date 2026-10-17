import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:project_uas/data/dummy_questions.dart';
import 'package:project_uas/providers/quiz_provider.dart';
import 'package:project_uas/providers/theme_provider.dart';
import 'package:project_uas/screens/home_screen.dart';
import 'package:project_uas/screens/quiz_screen.dart';
import 'package:project_uas/screens/result_screen.dart';
import 'package:project_uas/theme/app_theme.dart';
import 'package:project_uas/widgets/primary_button.dart';
import 'package:project_uas/widgets/score_card.dart';

void main() {
  Widget createResultScreenApp({
    QuizProvider? quizProvider,
    ThemeProvider? themeProvider,
    VoidCallback? onRestart,
    VoidCallback? onHome,
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
            home: ResultScreen(
              onRestart: onRestart,
              onHome: onHome,
            ),
          );
        },
      ),
    );
  }

  group('ResultScreen UI & Component Rendering', () {
    testWidgets('renders all essential elements properly', (tester) async {
      final quiz = QuizProvider();
      quiz.setUserName('Andi');
      // Berikan 8 jawaban benar (soal 0..7 jawaban benar, 8..9 salah)
      for (var i = 0; i < 8; i++) {
        quiz.selectAnswerFor(i, dummyQuestions[i].correctAnswerIndex);
      }
      quiz.selectAnswerFor(
        8,
        (dummyQuestions[8].correctAnswerIndex + 1) % 4,
      );
      quiz.selectAnswerFor(
        9,
        (dummyQuestions[9].correctAnswerIndex + 1) % 4,
      );
      quiz.completeQuiz();

      await tester.pumpWidget(createResultScreenApp(quizProvider: quiz));
      await tester.pumpAndSettle();

      // Memastikan judul AppBar "Hasil Kuis"
      expect(find.text('Hasil Kuis'), findsOneWidget);

      // Memastikan toggle tema ada di AppBar
      expect(find.byType(IconButton), findsOneWidget);

      // Memastikan teks "Kuis Selesai!"
      expect(find.text('Kuis Selesai!'), findsOneWidget);

      // Memastikan pesan evaluasi skor 80%
      expect(
        find.text('Luar biasa! Pengetahuanmu sangat luas!'),
        findsOneWidget,
      );

      // Memastikan ScoreCard ter-render
      expect(find.byType(ScoreCard), findsOneWidget);
      expect(find.text('Andi'), findsOneWidget);
      expect(find.text('8'), findsNWidgets(2));
      expect(find.text(' / 10'), findsOneWidget);
      expect(find.text('Nilai: 80%'), findsOneWidget);
      expect(find.text('Benar'), findsOneWidget);
      expect(find.text('Salah'), findsOneWidget);

      // Memastikan kedua tombol aksi ada
      expect(find.widgetWithText(PrimaryButton, 'Ulangi Kuis'), findsOneWidget);
      expect(
        find.widgetWithText(PrimaryButton, 'Kembali ke Beranda'),
        findsOneWidget,
      );
    });

    testWidgets('displays default "Peserta" when userName is blank',
        (tester) async {
      final quiz = QuizProvider();
      quiz.setUserName('');

      await tester.pumpWidget(createResultScreenApp(quizProvider: quiz));
      await tester.pumpAndSettle();

      expect(find.text('Peserta'), findsOneWidget);
    });

    testWidgets('displays perfect score message (100%) correctly',
        (tester) async {
      final quiz = QuizProvider();
      for (var i = 0; i < 10; i++) {
        quiz.selectAnswerFor(i, dummyQuestions[i].correctAnswerIndex);
      }
      quiz.completeQuiz();

      await tester.pumpWidget(createResultScreenApp(quizProvider: quiz));
      await tester.pumpAndSettle();

      expect(find.text('Sempurna! Semua jawabanmu benar!'), findsOneWidget);
      expect(find.text('10'), findsNWidgets(2));
      expect(find.text(' / 10'), findsOneWidget);
      expect(find.text('Nilai: 100%'), findsOneWidget);
    });

    testWidgets('displays try again message for low score (<40%)',
        (tester) async {
      final quiz = QuizProvider();
      // Seluruh jawaban salah
      for (var i = 0; i < 10; i++) {
        quiz.selectAnswerFor(
          i,
          (dummyQuestions[i].correctAnswerIndex + 1) % 4,
        );
      }
      quiz.completeQuiz();

      await tester.pumpWidget(createResultScreenApp(quizProvider: quiz));
      await tester.pumpAndSettle();

      expect(
        find.text('Jangan menyerah! Coba lagi dan raih skor terbaikmu!'),
        findsOneWidget,
      );
      expect(find.text('0'), findsNWidgets(2));
      expect(find.text(' / 10'), findsOneWidget);
      expect(find.text('Nilai: 0%'), findsOneWidget);
    });
  });

  group('ResultScreen Interactions & Actions', () {
    testWidgets('toggles theme between Light and Dark mode from AppBar',
        (tester) async {
      final themeProvider = ThemeProvider();
      await tester.pumpWidget(
        createResultScreenApp(themeProvider: themeProvider),
      );
      await tester.pumpAndSettle();

      expect(themeProvider.isDarkMode, isFalse);

      // Tekan tombol toggle tema
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(themeProvider.isDarkMode, isTrue);

      // Tekan lagi untuk kembali ke light mode
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(themeProvider.isDarkMode, isFalse);
    });

    testWidgets('triggers onRestart callback and resets quiz state on Ulangi Kuis',
        (tester) async {
      bool restartCalled = false;
      final quiz = QuizProvider();
      quiz.setUserName('Dewi');
      quiz.selectAnswerFor(0, 1);
      quiz.completeQuiz();

      await tester.pumpWidget(
        createResultScreenApp(
          quizProvider: quiz,
          onRestart: () {
            quiz.restartQuiz();
            restartCalled = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      // Tekan tombol "Ulangi Kuis"
      final restartFinder = find.widgetWithText(PrimaryButton, 'Ulangi Kuis');
      await tester.ensureVisible(restartFinder);
      await tester.tap(restartFinder);
      await tester.pumpAndSettle();

      expect(restartCalled, isTrue);
      expect(quiz.currentQuestionIndex, 0);
      expect(quiz.selectedAnswers.isEmpty, isTrue);
      expect(quiz.isCompleted, isFalse);
      expect(quiz.userName, 'Dewi'); // Nama tetap tersimpan
    });

    testWidgets(
        'triggers onHome callback and resets all quiz state on Kembali ke Beranda',
        (tester) async {
      bool homeCalled = false;
      final quiz = QuizProvider();
      quiz.setUserName('Dewi');
      quiz.selectAnswerFor(0, 1);
      quiz.completeQuiz();

      await tester.pumpWidget(
        createResultScreenApp(
          quizProvider: quiz,
          onHome: () {
            quiz.resetQuiz();
            homeCalled = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      // Tekan tombol "Kembali ke Beranda"
      final homeFinder = find.widgetWithText(PrimaryButton, 'Kembali ke Beranda');
      await tester.ensureVisible(homeFinder);
      await tester.tap(homeFinder);
      await tester.pumpAndSettle();

      expect(homeCalled, isTrue);
      expect(quiz.userName, isEmpty);
      expect(quiz.currentQuestionIndex, 0);
      expect(quiz.selectedAnswers.isEmpty, isTrue);
      expect(quiz.isCompleted, isFalse);
    });
  });

  group('Full Flow: Home -> Quiz -> Result -> Restart / Home', () {
    testWidgets('complete navigation flow from start to result and restart',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final quiz = QuizProvider();
      final theme = ThemeProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: theme),
            ChangeNotifierProvider.value(value: quiz),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Di HomeScreen: Input nama peserta dan mulai kuis
      await tester.enterText(find.byType(TextFormField), 'Rian Pratama');
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.widgetWithText(PrimaryButton, 'Mulai Kuis'));
      await tester.tap(find.widgetWithText(PrimaryButton, 'Mulai Kuis'));
      await tester.pumpAndSettle();

      // 2. Sekarang berada di QuizScreen
      expect(find.byType(QuizScreen), findsOneWidget);
      expect(quiz.userName, 'Rian Pratama');

      // Jawab semua 10 soal
      for (var i = 0; i < 10; i++) {
        // Pilih opsi jawaban benar
        final correctIdx = dummyQuestions[i].correctAnswerIndex;
        final optionText = dummyQuestions[i].options[correctIdx];
        await tester.ensureVisible(find.text(optionText));
        await tester.tap(find.text(optionText));
        await tester.pumpAndSettle();

        if (i < 9) {
          final nextFinder = find.widgetWithText(PrimaryButton, 'Selanjutnya');
          await tester.ensureVisible(nextFinder);
          await tester.tap(nextFinder);
          await tester.pumpAndSettle();
        }
      }

      // Tekan tombol Selesai di nomor 10
      final selesaiFinder = find.widgetWithText(PrimaryButton, 'Selesai');
      await tester.ensureVisible(selesaiFinder);
      await tester.tap(selesaiFinder);
      await tester.pumpAndSettle();

      // 3. Sekarang berada di ResultScreen
      expect(find.byType(ResultScreen), findsOneWidget);
      expect(find.text('Kuis Selesai!'), findsOneWidget);
      expect(find.text('Rian Pratama'), findsOneWidget);
      expect(find.text('10'), findsNWidgets(2));
      expect(find.text(' / 10'), findsOneWidget);
      expect(find.text('Nilai: 100%'), findsOneWidget);

      // 4. Tekan "Ulangi Kuis"
      final restartFinder = find.widgetWithText(PrimaryButton, 'Ulangi Kuis');
      await tester.ensureVisible(restartFinder);
      await tester.tap(restartFinder);
      await tester.pumpAndSettle();

      // Kembali ke QuizScreen pada soal nomor 1 dengan nama tetap
      expect(find.byType(QuizScreen), findsOneWidget);
      expect(quiz.currentQuestionNumber, 1);
      expect(quiz.userName, 'Rian Pratama');
      expect(quiz.selectedAnswers.isEmpty, isTrue);
    });

    testWidgets('navigation from ResultScreen back to HomeScreen resets user name',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final quiz = QuizProvider();
      final theme = ThemeProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: theme),
            ChangeNotifierProvider.value(value: quiz),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Input nama dan mulai
      await tester.enterText(find.byType(TextFormField), 'Citra');
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.widgetWithText(PrimaryButton, 'Mulai Kuis'));
      await tester.tap(find.widgetWithText(PrimaryButton, 'Mulai Kuis'));
      await tester.pumpAndSettle();

      // Langsung navigasi ke soal terakhir
      quiz.goToQuestion(9);
      for (var i = 0; i < 10; i++) {
        quiz.selectAnswerFor(i, 0);
      }
      await tester.pumpAndSettle();

      // Selesai
      final selesaiFinder = find.widgetWithText(PrimaryButton, 'Selesai');
      await tester.ensureVisible(selesaiFinder);
      await tester.tap(selesaiFinder);
      await tester.pumpAndSettle();

      expect(find.byType(ResultScreen), findsOneWidget);

      // Tekan "Kembali ke Beranda"
      final homeFinder = find.widgetWithText(PrimaryButton, 'Kembali ke Beranda');
      await tester.ensureVisible(homeFinder);
      await tester.tap(homeFinder);
      await tester.pumpAndSettle();

      // Kembali ke HomeScreen dan nama direset
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(quiz.userName, isEmpty);
      expect(quiz.selectedAnswers.isEmpty, isTrue);
    });
  });

  group('ResultScreen Responsiveness', () {
    testWidgets('renders cleanly on landscape screen without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(800, 400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final quiz = QuizProvider();
      quiz.setUserName('Dimas');
      quiz.selectAnswerFor(0, 0);
      quiz.completeQuiz();

      await tester.pumpWidget(createResultScreenApp(quizProvider: quiz));
      await tester.pumpAndSettle();

      expect(find.byType(ResultScreen), findsOneWidget);
      expect(find.text('Hasil Kuis'), findsOneWidget);
      expect(find.text('Dimas'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders cleanly on small compact screen without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(320, 500);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final quiz = QuizProvider();
      quiz.setUserName('Siti');
      quiz.completeQuiz();

      await tester.pumpWidget(createResultScreenApp(quizProvider: quiz));
      await tester.pumpAndSettle();

      expect(find.byType(ResultScreen), findsOneWidget);
      expect(find.text('Hasil Kuis'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
