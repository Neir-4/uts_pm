import 'package:flutter/material.dart';

/// Widget untuk menampilkan header progres pengerjaan kuis.

class ProgressHeader extends StatelessWidget {
  final int currentQuestionIndex;

  final int totalQuestions;

  final double? progress;

  final int? answeredCount;

  const ProgressHeader({
    super.key,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    this.progress,
    this.answeredCount,
  });

  int get currentQuestionNumber => currentQuestionIndex + 1;

  double get effectiveProgress {
    if (progress != null) {
      return progress!.clamp(0.0, 1.0);
    }
    if (totalQuestions <= 0) return 0.0;
    final answered = answeredCount ?? 0;
    return (answered / totalQuestions).clamp(0.0, 1.0);
  }

  /// Format teks persentase progres bilangan bulat (misal: "30%").
  String get progressPercentageText =>
      '${(effectiveProgress * 100).round()}%';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: colorScheme.outline,
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Baris Atas: Indikator Nomor Soal & Persentase Progres
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Badge Nomor Soal
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      'Soal $currentQuestionNumber',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    'dari $totalQuestions',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // Persentase Kemajuan
              Text(
                progressPercentageText,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10.0),

          // Linear Progress Bar Visual
          ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: LinearProgressIndicator(
              value: effectiveProgress,
              minHeight: 7.0,
              backgroundColor: colorScheme.outline.withValues(alpha: 0.35),
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),

          // Baris Bawah: Status Jumlah Terjawab (opsional)
          if (answeredCount != null) ...[
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 13.0,
                  color: colorScheme.secondary,
                ),
                const SizedBox(width: 4.0),
                Text(
                  '$answeredCount/$totalQuestions Terjawab',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11.5,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
