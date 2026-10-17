import 'package:flutter/material.dart';

/// Widget reusable untuk menampilkan ringkasan skor akhir kuis.
///
/// Menyajikan:
/// 1. Nama peserta (opsional).
/// 2. Skor dalam format X / Y dan persentase (misal: "8 / 10" dan "Nilai: 80%").
/// 3. Rincian jumlah jawaban (benar, salah, dan terlewat/belum dijawab).
/// 4. Pesan evaluasi kuis (opsional).
class ScoreCard extends StatelessWidget {
  /// Jumlah jawaban benar atau skor yang diperoleh peserta.
  final int score;

  /// Jumlah total pertanyaan kuis.
  final int totalQuestions;

  /// Persentase nilai skor (0..100). Jika null, dihitung otomatis dari [score] dan [totalQuestions].
  final double? percentage;

  /// Teks persentase terformat (misal "80%"). Jika null, dihitung otomatis.
  final String? percentageFormatted;

  /// Jumlah jawaban benar. Default bernilai sama dengan [score].
  final int? correctCount;

  /// Jumlah jawaban salah. Default dihitung dari [totalQuestions] - [score].
  final int? wrongCount;

  /// Jumlah soal yang belum dijawab / terlewat.
  final int? unansweredCount;

  /// Nama peserta kuis (opsional).
  final String? userName;

  /// Pesan evaluasi kuis (opsional).
  final String? evaluationMessage;

  const ScoreCard({
    super.key,
    required this.score,
    required this.totalQuestions,
    this.percentage,
    this.percentageFormatted,
    this.correctCount,
    this.wrongCount,
    this.unansweredCount,
    this.userName,
    this.evaluationMessage,
  });

  /// Menghitung persentase nilai secara aman.
  double get _computedPercentage {
    if (percentage != null) return percentage!;
    if (totalQuestions <= 0) return 0.0;
    return (score / totalQuestions) * 100;
  }

  /// Menghasilkan format string persentase.
  String get _computedPercentageFormatted {
    if (percentageFormatted != null) return percentageFormatted!;
    return '${_computedPercentage.round()}%';
  }

  /// Menghasilkan jumlah jawaban benar yang aman.
  int get _computedCorrectCount => correctCount ?? score;

  /// Menghasilkan jumlah jawaban salah yang aman.
  int get _computedWrongCount {
    if (wrongCount != null) return wrongCount!;
    final calculated = totalQuestions - score;
    return calculated < 0 ? 0 : calculated;
  }

  /// Menghasilkan jumlah soal yang belum dijawab.
  int get _computedUnansweredCount => unansweredCount ?? 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: colorScheme.outline,
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header Peserta (jika userName disediakan dan tidak kosong)
          if (userName != null && userName!.trim().isNotEmpty) ...[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 18.0,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nama Peserta',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        userName!.trim(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14.0),
            Divider(color: colorScheme.outline, height: 1.0),
            const SizedBox(height: 16.0),
          ],

          // 2. Banner Skor Utama
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 18.0,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.18),
                width: 1.0,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'SKOR AKHIR',
                  style: theme.textTheme.labelMedium?.copyWith(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$score',
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.primary,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      ' / $totalQuestions',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    'Nilai: $_computedPercentageFormatted',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16.0),

          // 3. Rincian Statistik (Benar, Salah, Terlewat)
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  label: 'Benar',
                  value: '$_computedCorrectCount',
                  icon: Icons.check_circle_rounded,
                  color: colorScheme.secondary,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _buildStatItem(
                  context,
                  label: 'Salah',
                  value: '$_computedWrongCount',
                  icon: Icons.cancel_rounded,
                  color: colorScheme.error,
                ),
              ),
              if (_computedUnansweredCount > 0) ...[
                const SizedBox(width: 8.0),
                Expanded(
                  child: _buildStatItem(
                    context,
                    label: 'Terlewat',
                    value: '$_computedUnansweredCount',
                    icon: Icons.help_outline_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),

          // 4. Pesan Evaluasi (jika diberikan)
          if (evaluationMessage != null && evaluationMessage!.trim().isNotEmpty) ...[
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: colorScheme.outline,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 18.0,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      evaluationMessage!.trim(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: colorScheme.outline, width: 1.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20.0, color: color),
          const SizedBox(height: 4.0),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              fontSize: 11.0,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
