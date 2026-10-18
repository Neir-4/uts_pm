import 'package:flutter/material.dart';
import 'package:project_uas/theme/app_theme.dart';

/// Widget tombol utama yang dapat digunakan kembali (reusable) di seluruh aplikasi.

class PrimaryButton extends StatelessWidget {
  final String text;

  final VoidCallback? onPressed;

  final IconData? icon;


  final bool isLoading;

  final bool isOutlined;

  final double? width;

  final double height;

  final Color? backgroundColor;

  final Color? foregroundColor;

  final BorderRadius? borderRadius;

  final EdgeInsetsGeometry? padding;

  final TextStyle? textStyle;

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
