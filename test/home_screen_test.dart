import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:project_uas/providers/quiz_provider.dart';
import 'package:project_uas/providers/theme_provider.dart';
import 'package:project_uas/screens/home_screen.dart';
import 'package:project_uas/screens/quiz_screen.dart';
import 'package:project_uas/theme/app_theme.dart';
import 'package:project_uas/widgets/custom_text_field.dart';
import 'package:project_uas/widgets/primary_button.dart';

Widget createHomeScreenTestWrapper({
  ThemeProvider? themeProvider,
  QuizProvider? quizProvider,
  void Function(String)? onQuizStarted,
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
      builder: (context, tp, _) {
        return MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: tp.themeMode,
          home: HomeScreen(onQuizStarted: onQuizStarted),
        );
      },
    ),
  );
}

void main() {
  group('HomeScreen UI & Component Rendering', () {
    testWidgets('renders all essential elements properly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreenTestWrapper());
      await tester.pumpAndSettle();

      // Memeriksa AppBar dan judul aplikasi
      expect(find.text('Quiz Umum'), findsOneWidget);

      // Memeriksa tombol aksi toggle tema di AppBar
      expect(find.byType(IconButton), findsWidgets);
      expect(find.byTooltip('Ganti ke Mode Gelap'), findsOneWidget);

      // Memeriksa judul dan deskripsi di body
      expect(find.text('Quiz Pengetahuan Umum'), findsOneWidget);
      expect(
        find.text(
          'Uji ketangkasan wawasanmu dengan 10 pertanyaan pilihan ganda seputar sains, sejarah, dan kebudayaan.',
        ),
        findsOneWidget,
      );

      // Memeriksa info badges fitur kuis
      expect(find.text('10 Soal'), findsOneWidget);
      expect(find.text('4 Pilihan'), findsOneWidget);
      expect(find.text('Skor Akurat'), findsOneWidget);

      // Memeriksa Card formulir data peserta
      expect(find.text('Data Peserta'), findsOneWidget);
      expect(
        find.text('Masukkan nama Anda sebelum memulai pengerjaan kuis.'),
        findsOneWidget,
      );

      // Memeriksa CustomTextField dan PrimaryButton
      expect(find.byType(CustomTextField), findsOneWidget);
      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('Mulai Kuis'), findsOneWidget);

      // Memeriksa teks footer
      expect(find.text('Praktikum Pemrograman Mobile • UAS'), findsOneWidget);
    });

    testWidgets('populates initial text field value from existing QuizProvider username',
        (WidgetTester tester) async {
      final quizProvider = QuizProvider();
      quizProvider.setUserName('Siti Rahma');

      await tester.pumpWidget(
        createHomeScreenTestWrapper(quizProvider: quizProvider),
      );
      await tester.pumpAndSettle();

      expect(find.text('Siti Rahma'), findsOneWidget);
    });
  });

  group('HomeScreen Theme Toggle Interaction', () {
    testWidgets('toggles theme between Light and Dark mode',
        (WidgetTester tester) async {
      final themeProvider = ThemeProvider();

      await tester.pumpWidget(
        createHomeScreenTestWrapper(themeProvider: themeProvider),
      );
      await tester.pumpAndSettle();

      expect(themeProvider.isDarkMode, isFalse);
      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);

      // Tap toggle tema
      await tester.tap(find.byTooltip('Ganti ke Mode Gelap'));
      await tester.pumpAndSettle();

      expect(themeProvider.isDarkMode, isTrue);
      expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);

      // Tap kembali toggle tema
      await tester.tap(find.byTooltip('Ganti ke Mode Terang'));
      await tester.pumpAndSettle();

      expect(themeProvider.isDarkMode, isFalse);
      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
    });
  });

  group('HomeScreen Input Validation & Quiz Start', () {
    testWidgets('shows validation error when name is empty',
        (WidgetTester tester) async {
      bool quizStarted = false;
      final quizProvider = QuizProvider();

      await tester.pumpWidget(
        createHomeScreenTestWrapper(
          quizProvider: quizProvider,
          onQuizStarted: (_) => quizStarted = true,
        ),
      );
      await tester.pumpAndSettle();

      // Klik tombol Mulai Kuis tanpa mengisi nama
      final startButton = find.text('Mulai Kuis');
      await tester.ensureVisible(startButton);
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Verifikasi pesan error muncul
      expect(find.text('Nama peserta tidak boleh kosong'), findsOneWidget);
      expect(quizStarted, isFalse);
      expect(quizProvider.userName, isEmpty);
    });

    testWidgets('shows validation error when name contains only spaces',
        (WidgetTester tester) async {
      bool quizStarted = false;
      final quizProvider = QuizProvider();

      await tester.pumpWidget(
        createHomeScreenTestWrapper(
          quizProvider: quizProvider,
          onQuizStarted: (_) => quizStarted = true,
        ),
      );
      await tester.pumpAndSettle();

      // Masukkan spasi kosong
      await tester.enterText(find.byType(TextFormField), '     ');
      final startButton = find.text('Mulai Kuis');
      await tester.ensureVisible(startButton);
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Verifikasi pesan error muncul
      expect(find.text('Nama peserta tidak boleh kosong'), findsOneWidget);
      expect(quizStarted, isFalse);
      expect(quizProvider.userName, isEmpty);
    });

    testWidgets('shows validation error when name is only 1 character',
        (WidgetTester tester) async {
      bool quizStarted = false;

      await tester.pumpWidget(
        createHomeScreenTestWrapper(
          onQuizStarted: (_) => quizStarted = true,
        ),
      );
      await tester.pumpAndSettle();

      // Masukkan 1 karakter
      await tester.enterText(find.byType(TextFormField), 'A');
      final startButton = find.text('Mulai Kuis');
      await tester.ensureVisible(startButton);
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Verifikasi pesan error batas minimum karakter
      expect(find.text('Nama minimal terdiri dari 2 karakter'), findsOneWidget);
      expect(quizStarted, isFalse);
    });

    testWidgets('successfully validates, updates QuizProvider, and navigates with valid name',
        (WidgetTester tester) async {
      final quizProvider = QuizProvider();

      await tester.pumpWidget(
        createHomeScreenTestWrapper(quizProvider: quizProvider),
      );
      await tester.pumpAndSettle();

      // Masukkan nama yang valid dengan spasi di awal/akhir untuk menguji trimming
      await tester.enterText(
        find.byType(TextFormField),
        '  Andi Pratama  ',
      );
      await tester.pumpAndSettle();

      // Tekan tombol Mulai Kuis
      final startButton = find.text('Mulai Kuis');
      await tester.ensureVisible(startButton);
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Verifikasi tidak ada pesan error
      expect(find.text('Nama peserta tidak boleh kosong'), findsNothing);
      expect(find.text('Nama minimal terdiri dari 2 karakter'), findsNothing);

      // Verifikasi QuizProvider menyimpan nama yang telah di-trim
      expect(quizProvider.userName, equals('Andi Pratama'));

      // Verifikasi navigasi ke QuizScreen berhasil
      expect(find.byType(QuizScreen), findsOneWidget);
      expect(find.text('Halo, Andi Pratama!'), findsOneWidget);
      expect(find.text('Kuis Pengetahuan Umum'), findsOneWidget);
    });

    testWidgets('submits form via keyboard onFieldSubmitted action',
        (WidgetTester tester) async {
      String? startedName;
      final quizProvider = QuizProvider();

      await tester.pumpWidget(
        createHomeScreenTestWrapper(
          quizProvider: quizProvider,
          onQuizStarted: (name) => startedName = name,
        ),
      );
      await tester.pumpAndSettle();

      // Masukkan nama dan submit via keyboard enter action
      await tester.enterText(find.byType(TextFormField), 'Dewi Lestari');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(startedName, equals('Dewi Lestari'));
      expect(quizProvider.userName, equals('Dewi Lestari'));
    });

    testWidgets('clear button in CustomTextField clears the input',
        (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreenTestWrapper());
      await tester.pumpAndSettle();

      // Awalnya tombol clear belum muncul
      expect(find.byTooltip('Hapus teks'), findsNothing);

      // Ketik teks
      await tester.enterText(find.byType(TextFormField), 'Ahmad');
      await tester.pumpAndSettle();

      // Tombol clear muncul
      expect(find.byTooltip('Hapus teks'), findsOneWidget);

      // Tap tombol clear
      await tester.tap(find.byTooltip('Hapus teks'));
      await tester.pumpAndSettle();

      // Teks menjadi kosong dan tombol clear menghilang
      expect(find.text('Ahmad'), findsNothing);
      expect(find.byTooltip('Hapus teks'), findsNothing);
    });
  });

  group('HomeScreen Responsiveness & Layout Constraints', () {
    testWidgets('renders cleanly on standard portrait screen without overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 2.5;

      await tester.pumpWidget(createHomeScreenTestWrapper());
      await tester.pumpAndSettle();

      expect(find.text('Quiz Umum'), findsOneWidget);
      expect(find.text('Mulai Kuis'), findsOneWidget);
      expect(tester.takeException(), isNull);

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('renders cleanly on landscape screen without overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 2.5;

      await tester.pumpWidget(createHomeScreenTestWrapper());
      await tester.pumpAndSettle();

      expect(find.text('Quiz Umum'), findsOneWidget);
      expect(find.text('Mulai Kuis'), findsOneWidget);
      expect(tester.takeException(), isNull);

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('renders cleanly on compact small screen without overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(640, 960);
      tester.view.devicePixelRatio = 2.0;

      await tester.pumpWidget(createHomeScreenTestWrapper());
      await tester.pumpAndSettle();

      expect(find.text('Quiz Umum'), findsOneWidget);
      expect(find.text('Mulai Kuis'), findsOneWidget);
      expect(tester.takeException(), isNull);

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}
