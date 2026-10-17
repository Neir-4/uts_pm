import 'package:flutter/material.dart';

/// Widget reusable untuk menampilkan kartu pertanyaan kuis.
///
/// Menyajikan nomor pertanyaan, kategori (opsional), serta teks pertanyaan
/// dengan tipografi yang jelas, mudah dibaca, dan proteksi tata letak responsif.
class QuestionCard extends StatelessWidget {
  /// Teks soal pertanyaan kuis.
  final String questionText;

  /// Nomor urut pertanyaan (opsional, 1-indexed).
  final int? questionNumber;

  /// Kategori atau topik soal (opsional).
  final String? category;

  /// Ikon opsional untuk header kartu pertanyaan.
  final IconData? icon;

  const QuestionCard({
    super.key,
    required this.questionText,
    this.questionNumber,
    this.category,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: colorScheme.outline,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Kartu: Ikon/Badge Nomor Soal & Kategori
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  icon ?? Icons.help_outline_rounded,
                  size: 18.0,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10.0),
              if (questionNumber != null)
                Text(
                  'Pertanyaan #$questionNumber',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13.0,
                  ),
                ),
              if (category != null) ...[
                const SizedBox(width: 8.0),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      category!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 14.0),

          // Teks Pertanyaan
          Text(
            questionText,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 16.5,
              fontWeight: FontWeight.w600,
              height: 1.45,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
