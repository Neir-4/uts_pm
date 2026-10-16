import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_uas/providers/quiz_provider.dart';
import 'package:project_uas/widgets/primary_button.dart';

/// Layar hasil kuis (ResultScreen).
///
/// Menampilkan ringkasan skor dan evaluasi hasil pengerjaan kuis.
/// Komponen lengkap (ScoreCard, dsb.) akan diimplementasikan pada Tahap 8.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Kuis'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events_rounded,
                  size: 72.0,
                  color: colorScheme.secondary,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Kuis Selesai!',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Peserta: ${quizProvider.userName.isEmpty ? 'Peserta' : quizProvider.userName}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: colorScheme.outline),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Skor: ${quizProvider.score} / ${quizProvider.totalQuestions}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Persentase: ${quizProvider.scorePercentageFormatted}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                PrimaryButton(
                  text: 'Ulangi Kuis',
                  icon: Icons.replay_rounded,
                  onPressed: () {
                    quizProvider.restartQuiz();
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 12.0),
                PrimaryButton.outlined(
                  text: 'Kembali ke Beranda',
                  icon: Icons.home_rounded,
                  onPressed: () {
                    quizProvider.resetQuiz();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
