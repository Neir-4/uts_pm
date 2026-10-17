import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:project_uas/providers/quiz_provider.dart';
import 'package:project_uas/providers/theme_provider.dart';
import 'package:project_uas/screens/home_screen.dart';
import 'package:project_uas/screens/quiz_screen.dart';
import 'package:project_uas/screens/result_screen.dart';
import 'package:project_uas/theme/app_theme.dart';

void main() {
  /// Ukuran layar untuk pengujian responsivitas komprehensif
  final testScreenSizes = <String, Size>{
    'Compact Mobile Portrait (320x568)': const Size(320, 568),
    'Standard Mobile Portrait (390x844)': const Size(390, 844),
    'Large Mobile Portrait (412x915)': const Size(412, 915),
    'Compact Mobile Landscape (568x320)': const Size(568, 320),
    'Standard Mobile Landscape (844x390)': const Size(844, 390),
    'Tablet Portrait (768x1024)': const Size(768, 1024),
    'Tablet Landscape (1024x768)': const Size(1024, 768),
  };

  Widget buildTestApp({
    required Widget home,
    QuizProvider? quizProvider,
    ThemeProvider? themeProvider,
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
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: theme.themeMode,
            home: home,
          );
        },
      ),
    );
  }

  group('Tahap 9 - HomeScreen Multi-Device Responsiveness', () {
    for (final entry in testScreenSizes.entries) {
      testWidgets('HomeScreen renders without overflow on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(buildTestApp(home: const HomeScreen()));
        await tester.pumpAndSettle();

        expect(find.byType(HomeScreen), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(SafeArea), findsWidgets);
        expect(find.text('Quiz Pengetahuan Umum'), findsOneWidget);
        expect(find.text('Mulai Kuis'), findsOneWidget);

        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('HomeScreen interaction works seamlessly on compact landscape', (tester) async {
      tester.view.physicalSize = const Size(568, 320);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      bool quizStarted = false;
      await tester.pumpWidget(buildTestApp(
        home: HomeScreen(
          onQuizStarted: (_) => quizStarted = true,
        ),
      ));
      await tester.pumpAndSettle();

      final inputFinder = find.byType(TextField);
      await tester.ensureVisible(inputFinder);
      await tester.enterText(inputFinder, 'Siti Rahma');
      await tester.pumpAndSettle();

      final submitFinder = find.text('Mulai Kuis');
      await tester.ensureVisible(submitFinder);
      await tester.tap(submitFinder);
      await tester.pumpAndSettle();

      expect(quizStarted, isTrue);
      expect(tester.takeException(), isNull);
    });
  });

  group('Tahap 9 - QuizScreen Multi-Device Responsiveness', () {
    for (final entry in testScreenSizes.entries) {
      testWidgets('QuizScreen renders without overflow on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final quiz = QuizProvider();
        await tester.pumpWidget(buildTestApp(
          home: const QuizScreen(),
          quizProvider: quiz,
        ));
        await tester.pumpAndSettle();

        expect(find.byType(QuizScreen), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(SafeArea), findsWidgets);
        expect(find.text('Soal 1'), findsOneWidget);

        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('QuizScreen can scroll and answer questions on compact landscape', (tester) async {
      tester.view.physicalSize = const Size(568, 320);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final quiz = QuizProvider();
      await tester.pumpWidget(buildTestApp(
        home: const QuizScreen(),
        quizProvider: quiz,
      ));
      await tester.pumpAndSettle();

      // Pilih jawaban opsi 1
      final firstOptionText = quiz.currentQuestion.options[0];
      await tester.ensureVisible(find.text(firstOptionText));
      await tester.tap(find.text(firstOptionText));
      await tester.pumpAndSettle();

      expect(quiz.currentSelectedAnswer, equals(0));

      // Scroll ke tombol Selanjutnya
      final nextButtonFinder = find.text('Selanjutnya');
      await tester.ensureVisible(nextButtonFinder);
      await tester.tap(nextButtonFinder);
      await tester.pumpAndSettle();

      expect(quiz.currentQuestionIndex, equals(1));
      expect(find.text('Soal 2'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Tahap 9 - ResultScreen Multi-Device Responsiveness', () {
    for (final entry in testScreenSizes.entries) {
      testWidgets('ResultScreen renders without overflow on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final quiz = QuizProvider();
        quiz.setUserName('Ahmad Fauzi');
        for (var i = 0; i < 8; i++) {
          quiz.selectAnswerFor(i, quiz.questions[i].correctAnswerIndex);
        }
        quiz.completeQuiz();

        await tester.pumpWidget(buildTestApp(
          home: const ResultScreen(),
          quizProvider: quiz,
        ));
        await tester.pumpAndSettle();

        expect(find.byType(ResultScreen), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(SafeArea), findsWidgets);
        expect(find.text('Kuis Selesai!'), findsOneWidget);
        expect(find.text('Ahmad Fauzi'), findsOneWidget);

        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('ResultScreen buttons are scrollable and clickable on compact landscape', (tester) async {
      tester.view.physicalSize = const Size(568, 320);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      bool restarted = false;
      final quiz = QuizProvider();
      quiz.setUserName('Budi');
      quiz.completeQuiz();

      await tester.pumpWidget(buildTestApp(
        home: ResultScreen(
          onRestart: () => restarted = true,
        ),
        quizProvider: quiz,
      ));
      await tester.pumpAndSettle();

      final restartBtn = find.text('Ulangi Kuis');
      await tester.ensureVisible(restartBtn);
      await tester.tap(restartBtn);
      await tester.pumpAndSettle();

      expect(restarted, isTrue);
      expect(tester.takeException(), isNull);
    });
  });

  group('Tahap 9 - Theme Switching Responsiveness', () {
    testWidgets('theme switching maintains layout integrity on all screens in dark mode', (tester) async {
      tester.view.physicalSize = const Size(844, 390); // Landscape
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final themeProvider = ThemeProvider();
      themeProvider.setThemeMode(ThemeMode.dark);

      final quiz = QuizProvider();
      quiz.setUserName('Dewi');

      await tester.pumpWidget(buildTestApp(
        home: const HomeScreen(),
        themeProvider: themeProvider,
        quizProvider: quiz,
      ));
      await tester.pumpAndSettle();

      expect(themeProvider.isDarkMode, isTrue);
      expect(tester.takeException(), isNull);
    });
  });
}
