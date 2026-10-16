import 'package:flutter/material.dart';

/// Widget reusable untuk menampilkan satu opsi pilihan jawaban kuis (A, B, C, D).
///
/// Mendukung penyorotan visual aktif (highlight) ketika opsi dipilih,
/// efek ripple sentuhan responsif, badge huruf opsi, dan proteksi text wrapping
/// agar tidak terjadi visual overflow pada jawaban yang panjang.
class AnswerOptionTile extends StatelessWidget {
  /// Indeks urutan pilihan jawaban (0 untuk 'A', 1 untuk 'B', 2 untuk 'C', 3 untuk 'D').
  final int optionIndex;

  /// Teks pilihan jawaban.
  final String optionText;

  /// Status apakah opsi ini sedang dipilih oleh pengguna.
  final bool isSelected;

  /// Aksi callback saat opsi ditekan.
  final VoidCallback? onTap;

  /// Status apakah opsi dapat diinteraksi (aktif/nonaktif).
  final bool isEnabled;

  /// Label huruf kustom (opsional, jika tidak diset menggunakan huruf A-Z berdasarkan [optionIndex]).
  final String? customLabel;

  const AnswerOptionTile({
    super.key,
    required this.optionIndex,
    required this.optionText,
    required this.isSelected,
    this.onTap,
    this.isEnabled = true,
    this.customLabel,
  });

  /// Mendapatkan huruf pilihan jawaban ('A', 'B', 'C', 'D', dst).
  String get optionLetter {
    if (customLabel != null && customLabel!.isNotEmpty) {
      return customLabel!;
    }
    return String.fromCharCode(65 + optionIndex);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isInteractive = isEnabled && onTap != null;

    // Warna status pemilihan
    final Color borderColor = isSelected
        ? colorScheme.primary
        : colorScheme.outline;

    final double borderWidth = isSelected ? 1.8 : 1.0;

    final Color backgroundColor = isSelected
        ? colorScheme.primary.withValues(alpha: 0.08)
        : colorScheme.surface;

    final Color badgeBackgroundColor = isSelected
        ? colorScheme.primary
        : colorScheme.outline.withValues(alpha: 0.25);

    final Color badgeTextColor = isSelected
        ? colorScheme.onPrimary
        : colorScheme.onSurface;

    final Color textColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: isInteractive ? onTap : null,
          borderRadius: BorderRadius.circular(12.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            constraints: const BoxConstraints(minHeight: 52.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: borderColor,
                width: borderWidth,
              ),
            ),
            child: Row(
              children: [
                // Badge Huruf Pilihan (A, B, C, D)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 32.0,
                  height: 32.0,
                  decoration: BoxDecoration(
                    color: badgeBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    optionLetter,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: badgeTextColor,
                      fontSize: 14.0,
                    ),
                  ),
                ),

                const SizedBox(width: 12.0),

                // Teks Pilihan Jawaban (Wrap otomatis jika panjang)
                Expanded(
                  child: Text(
                    optionText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textColor,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14.5,
                      height: 1.35,
                    ),
                  ),
                ),

                const SizedBox(width: 8.0),

                // Indikator Radio/Centang di Sisi Kanan
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: isSelected
                      ? Icon(
                          Icons.check_circle_rounded,
                          key: const ValueKey('selected_icon'),
                          size: 22.0,
                          color: colorScheme.primary,
                        )
                      : Icon(
                          Icons.radio_button_unchecked_rounded,
                          key: const ValueKey('unselected_icon'),
                          size: 22.0,
                          color: colorScheme.outline,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
