import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_uas/providers/quiz_provider.dart';
import 'package:project_uas/providers/theme_provider.dart';
import 'package:project_uas/screens/quiz_screen.dart';
import 'package:project_uas/widgets/primary_button.dart';
import 'package:project_uas/widgets/score_card.dart';

/// Layar hasil akhir kuis (ResultScreen).

class ResultScreen extends StatelessWidget {
  final VoidCallback? onRestart;

  final VoidCallback? onHome;

  const ResultScreen({
    super.key,
    this.onRestart,
    this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = themeProvider.isDarkMode;

    final displayName =
        quizProvider.userName.trim().isEmpty ? 'Peserta' : quizProvider.userName.trim();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (onHome != null) {
          onHome!();
        } else {
          quizProvider.resetQuiz();
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hasil Kuis'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              tooltip: isDark ? 'Beralih ke Mode Terang' : 'Beralih ke Mode Gelap',
              icon: Icon(
                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              ),
              onPressed: () => themeProvider.toggleTheme(),
            ),
            const SizedBox(width: 8.0),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Ilustrasi Hasil Kuis
                    Center(
                      child: Image.asset(
                        quizProvider.resultImagePath,
                        height: 120.0,
                        width: 120.0,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.emoji_events_rounded,
                          size: 80.0,
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18.0),

                    // Judul Penyelesaian
                    Text(
                      'Kuis Selesai!',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 6.0),

                    // Pesan Evaluasi Motivasional
                    Text(
                      quizProvider.resultMessage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24.0),

                    // Komponen ScoreCard
                    ScoreCard(
                      score: quizProvider.score,
                      totalQuestions: quizProvider.totalQuestions,
                      percentage: quizProvider.scorePercentage,
                      percentageFormatted: quizProvider.scorePercentageFormatted,
                      correctCount: quizProvider.correctAnswersCount,
                      wrongCount: quizProvider.wrongAnswersCount,
                      unansweredCount: quizProvider.unansweredCount,
                      userName: displayName,
                    ),

                    const SizedBox(height: 28.0),

                    // Tombol Aksi: Ulangi Kuis (Filled)
                    PrimaryButton(
                      text: 'Ulangi Kuis',
                      icon: Icons.replay_rounded,
                      onPressed: () {
                        if (onRestart != null) {
                          onRestart!();
                        } else {
                          quizProvider.restartQuiz();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const QuizScreen(),
                            ),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 12.0),

                    // Tombol Aksi: Kembali ke Beranda (Outlined)
                    PrimaryButton.outlined(
                      text: 'Kembali ke Beranda',
                      icon: Icons.home_rounded,
                      onPressed: () {
                        if (onHome != null) {
                          onHome!();
                        } else {
                          quizProvider.resetQuiz();
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
