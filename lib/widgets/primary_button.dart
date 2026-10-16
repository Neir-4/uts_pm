import 'package:flutter/material.dart';
import 'package:project_uas/theme/app_theme.dart';

/// Widget tombol utama yang dapat digunakan kembali (reusable) di seluruh aplikasi.
///
/// Mendukung mode terisi (filled) maupun bergaris tepi (outlined), status loading,
/// ikon opsional, dan penyesuaian warna serta ukuran yang responsif mengikuti tema.
class PrimaryButton extends StatelessWidget {
  /// Teks label pada tombol.
  final String text;

  /// Aksi callback saat tombol ditekan. Jika bernilai null, tombol akan berada dalam kondisi nonaktif (disabled).
  final VoidCallback? onPressed;

  /// Ikon opsional yang ditampilkan di sisi kiri label teks.
  final IconData? icon;

  /// Menandakan apakah tombol sedang dalam status memproses (loading).
  /// Saat aktif, tombol menampilkan CircularProgressIndicator dan dinonaktifkan sementara.
  final bool isLoading;

  /// Menandakan apakah tombol menggunakan gaya Outlined (bergaris tepi transparan).
  final bool isOutlined;

  /// Lebar tombol. Nilai default adalah `double.infinity` agar mengisi lebar kontainer induk.
  final double? width;

  /// Tinggi tombol. Nilai default adalah 50.0 px (memenuhi standar minimum target sentuh 48 px).
  final double height;

  /// Warna latar belakang kustom (opsional, bawaan menggunakan `colorScheme.primary`).
  final Color? backgroundColor;

  /// Warna teks dan ikon kustom (opsional, bawaan menggunakan `colorScheme.onPrimary`).
  final Color? foregroundColor;

  /// Radius sudut tombol. Nilai default adalah 10.0 px sesuai desain minimalis.
  final BorderRadius? borderRadius;

  /// Padding internal tombol.
  final EdgeInsetsGeometry? padding;

  /// Gaya teks kustom untuk label tombol (opsional).
  final TextStyle? textStyle;

  /// Konstruktor standar untuk tombol terisi (Filled Button).
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.width = double.infinity,
    this.height = 50.0,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
  });

  /// Konstruktor sekunder untuk tombol Outlined (bergaris tepi).
  const PrimaryButton.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 50.0,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
  }) : isOutlined = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isEnabled = onPressed != null && !isLoading;

    final effectiveRadius = borderRadius ?? BorderRadius.circular(10);
    final effectivePadding = padding ?? const EdgeInsets.symmetric(horizontal: 16);

    // Menentukan warna teks & ikon default berdasarkan varian dan status
    final Color defaultTextColor = isOutlined
        ? (foregroundColor ?? (isDark ? colorScheme.onSurface : colorScheme.primary))
        : (foregroundColor ?? colorScheme.onPrimary);

    final resolvedTextStyle = (textStyle ??
            const TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ))
        .copyWith(color: defaultTextColor);

    // Konten tombol: Spinner saat loading, atau kombinasi ikon dan teks dengan proteksi overflow
    final Widget buttonContent = isLoading
        ? Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation<Color>(defaultTextColor),
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: defaultTextColor,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  text,
                  style: resolvedTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    final buttonWidget = isOutlined
        ? OutlinedButton(
            onPressed: isEnabled ? onPressed : null,
            style: OutlinedButton.styleFrom(
              elevation: 0,
              backgroundColor: backgroundColor ?? Colors.transparent,
              foregroundColor: defaultTextColor,
              padding: effectivePadding,
              shape: RoundedRectangleBorder(
                borderRadius: effectiveRadius,
              ),
              side: BorderSide(
                color: isEnabled
                    ? (foregroundColor ?? (isDark ? colorScheme.outline : colorScheme.primary))
                    : colorScheme.outline.withValues(alpha: 0.4),
                width: 1.2,
              ),
            ),
            child: buttonContent,
          )
        : ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: backgroundColor ?? colorScheme.primary,
              foregroundColor: defaultTextColor,
              disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.12),
              disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
              padding: effectivePadding,
              shape: RoundedRectangleBorder(
                borderRadius: effectiveRadius,
              ),
            ),
            child: buttonContent,
          );

    return SizedBox(
      width: width,
      height: height,
      child: buttonWidget,
    );
  }
}
