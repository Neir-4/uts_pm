import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_uas/providers/quiz_provider.dart';
import 'package:project_uas/providers/theme_provider.dart';
import 'package:project_uas/screens/result_screen.dart';
import 'package:project_uas/widgets/answer_option_tile.dart';
import 'package:project_uas/widgets/primary_button.dart';
import 'package:project_uas/widgets/progress_header.dart';
import 'package:project_uas/widgets/question_card.dart';

/// Layar pengerjaan kuis interaktif (QuizScreen).

class QuizScreen extends StatelessWidget {
  final VoidCallback? onQuizFinished;

  const QuizScreen({
    super.key,
    this.onQuizFinished,
  });

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          icon: Icon(
            Icons.warning_amber_rounded,
            color: colorScheme.error,
            size: 36.0,
          ),
          title: Text(
            'Keluar dari Kuis?',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Progres jawaban Anda saat ini akan dibatalkan jika Anda kembali ke menu utama.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Lanjutkan Kuis'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  /// Menangani penyelesaian kuis (submit).
  Future<void> _handleFinishQuiz(
    BuildContext context,
    QuizProvider quizProvider,
  ) async {
    // Jika masih ada soal yang belum dijawab, tampilkan konfirmasi peringatan
    if (!quizProvider.isAllAnswered) {
      final shouldSubmit = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          final theme = Theme.of(dialogContext);
          final colorScheme = theme.colorScheme;

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            icon: Icon(
              Icons.help_outline_rounded,
              color: colorScheme.primary,
              size: 36.0,
            ),
            title: Text(
              'Selesaikan Kuis Sekarang?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Terdapat ${quizProvider.unansweredCount} dari ${quizProvider.totalQuestions} soal yang belum dijawab. Apakah Anda yakin ingin mengumpulkan?',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Periksa Kembali'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Ya, Selesaikan'),
              ),
            ],
          );
        },
      );

      if (shouldSubmit != true) {
        return;
      }
    }

    // Tandai kuis telah selesai
    quizProvider.completeQuiz();

    // Panggil callback jika ada, atau pindah ke ResultScreen
    if (onQuizFinished != null) {
      onQuizFinished!();
    } else {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const ResultScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Proteksi jika data pertanyaan kosong
    if (quizProvider.totalQuestions == 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('Kuis')),
        body: const Center(
          child: Text('Tidak ada pertanyaan yang tersedia.'),
        ),
      );
    }

    final currentQuestion = quizProvider.currentQuestion;
    final selectedAnswerIndex = quizProvider.currentSelectedAnswer;
    final isLastQuestion = quizProvider.isLastQuestion;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showExitConfirmationDialog(context);
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kuis Pengetahuan Umum'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Kembali',
            onPressed: () async {
              final shouldPop = await _showExitConfirmationDialog(context);
              if (shouldPop && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                themeProvider.isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
              tooltip: themeProvider.isDarkMode
                  ? 'Beralih ke Mode Terang'
                  : 'Beralih ke Mode Gelap',
              onPressed: () => themeProvider.toggleTheme(),
            ),
          ],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final minContentHeight =
                  (constraints.maxHeight - 32.0).clamp(0.0, double.infinity);

              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: minContentHeight,
                      maxWidth: 540.0,
                    ),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bagian Atas: ProgressHeader & Pertanyaan & Opsi Jawaban
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Progress Header
                          ProgressHeader(
                            currentQuestionIndex:
                                quizProvider.currentQuestionIndex,
                            totalQuestions: quizProvider.totalQuestions,
                            progress: quizProvider.progress,
                            answeredCount: quizProvider.answeredQuestionsCount,
                          ),

                          const SizedBox(height: 16.0),

                          // Question Card
                          QuestionCard(
                            questionText: currentQuestion.text,
                            questionNumber: quizProvider.currentQuestionNumber,
                          ),

                          const SizedBox(height: 16.0),

                          // Empat Opsi Jawaban (A, B, C, D)
                          ...List.generate(
                            currentQuestion.options.length,
                            (index) {
                              final optionText = currentQuestion.options[index];
                              final isSelected = selectedAnswerIndex == index;

                              return AnswerOptionTile(
                                optionIndex: index,
                                optionText: optionText,
                                isSelected: isSelected,
                                onTap: () => quizProvider.selectAnswer(index),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24.0),

                      // Bagian Bawah: Navigasi Tombol (Sebelumnya, Selanjutnya / Selesai)
                      Row(
                        children: [
                          // Tombol "Sebelumnya" (Outlined)
                          Expanded(
                            child: PrimaryButton.outlined(
                              text: 'Sebelumnya',
                              icon: Icons.arrow_back_rounded,
                              onPressed: quizProvider.canGoPrevious
                                  ? () => quizProvider.previousQuestion()
                                  : null,
                            ),
                          ),

                          const SizedBox(width: 12.0),

                          // Tombol "Selanjutnya" atau "Selesai" (Filled)
                          Expanded(
                            child: isLastQuestion
                                ? PrimaryButton(
                                    text: 'Selesai',
                                    icon: Icons.check_circle_rounded,
                                    backgroundColor: colorScheme.secondary,
                                    onPressed: () => _handleFinishQuiz(
                                      context,
                                      quizProvider,
                                    ),
                                  )
                                : PrimaryButton(
                                    text: 'Selanjutnya',
                                    icon: Icons.arrow_forward_rounded,
                                    onPressed: quizProvider.canGoNext
                                      ? () => quizProvider.nextQuestion()
                                      : null,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
            },
          ),
        ),
      ),
    );
  }
}
