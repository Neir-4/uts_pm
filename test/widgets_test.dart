import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_uas/theme/app_theme.dart';
import 'package:project_uas/widgets/custom_text_field.dart';
import 'package:project_uas/widgets/primary_button.dart';

void main() {
  group('PrimaryButton Widget Tests', () {
    testWidgets('renders text and responds to tap', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: PrimaryButton(
              text: 'Mulai Kuis',
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Mulai Kuis'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      await tester.tap(find.text('Mulai Kuis'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('disabled when onPressed is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: PrimaryButton(
              text: 'Tombol Nonaktif',
              onPressed: null,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows loading indicator and prevents tap when isLoading is true',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: PrimaryButton(
              text: 'Memproses...',
              isLoading: true,
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Label teks tidak ditampilkan saat loading, digantikan indikator progress
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Memproses...'), findsNothing);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);

      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('renders icon correctly alongside text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: PrimaryButton(
              text: 'Lanjutkan',
              icon: Icons.arrow_forward_rounded,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Lanjutkan'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
    });

    testWidgets('outlined variant renders OutlinedButton and triggers callback',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: PrimaryButton.outlined(
              text: 'Kembali',
              icon: Icons.arrow_back_rounded,
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Kembali'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);

      await tester.tap(find.text('Kembali'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });

  group('CustomTextField Widget Tests', () {
    testWidgets('renders label and hintText correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: CustomTextField(
              label: 'Nama Lengkap',
              hintText: 'Masukkan nama Anda...',
            ),
          ),
        ),
      );

      expect(find.text('Nama Lengkap'), findsOneWidget);
      expect(find.text('Masukkan nama Anda...'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('types text and triggers onChanged callback', (WidgetTester tester) async {
      String typedValue = '';
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Nama',
              onChanged: (val) {
                typedValue = val;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Budi Santoso');
      await tester.pump();

      expect(typedValue, equals('Budi Santoso'));
      expect(controller.text, equals('Budi Santoso'));
    });

    testWidgets('clear button appears when text is present and clears text on tap',
        (WidgetTester tester) async {
      final controller = TextEditingController(text: 'John Doe');
      String changedValue = 'initial';

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              showClearButton: true,
              onChanged: (val) {
                changedValue = val;
              },
            ),
          ),
        ),
      );

      // Tombol clear harus muncul karena ada teks
      expect(find.byIcon(Icons.clear_rounded), findsOneWidget);

      // Tap tombol clear
      await tester.tap(find.byIcon(Icons.clear_rounded));
      await tester.pump();

      // Controller kosong dan onChanged terpanggil dengan string kosong
      expect(controller.text, isEmpty);
      expect(changedValue, isEmpty);
      // Tombol clear menghilang saat teks kosong
      expect(find.byIcon(Icons.clear_rounded), findsNothing);
    });

    testWidgets('renders prefix and custom suffix icons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: CustomTextField(
              prefixIcon: Icon(Icons.person_outline),
              suffixIcon: Icon(Icons.check_circle_outline),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('displays validation error message properly in a Form',
        (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CustomTextField(
                label: 'Nama Peserta',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      // Validasi form saat masih kosong
      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Nama tidak boleh kosong'), findsOneWidget);
    });

    testWidgets('displays explicit errorText when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: CustomTextField(
              errorText: 'Terjadi kesalahan format',
            ),
          ),
        ),
      );

      expect(find.text('Terjadi kesalahan format'), findsOneWidget);
    });
  });
}
