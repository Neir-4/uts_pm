import 'package:flutter/material.dart';

/// Widget untuk menampilkan kartu pertanyaan kuis.

class QuestionCard extends StatelessWidget {
  final String questionText;

  final int? questionNumber;

  final String? category;

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
