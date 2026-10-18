import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_uas/theme/app_theme.dart';

/// Widget input teks kustom yang dapat digunakan kembali (reusable) di seluruh aplikasi.

class CustomTextField extends StatefulWidget {
  final String? label;

  final String? hintText;

  final String? helperText;

  final String? errorText;

  final TextEditingController? controller;

  final FormFieldValidator<String>? validator;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onFieldSubmitted;

  final VoidCallback? onEditingComplete;

  final FocusNode? focusNode;

  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;

  final TextCapitalization textCapitalization;

  final bool obscureText;

  final bool enabled;

  final bool readOnly;

  final bool autofocus;

  final int? maxLines;

  final int? minLines;

  final int? maxLength;

  final Widget? prefixIcon;

  final Widget? suffixIcon;

  final bool showClearButton;

  final List<TextInputFormatter>? inputFormatters;

  final AutovalidateMode? autovalidateMode;

  final EdgeInsetsGeometry? contentPadding;

  final TextStyle? style;

  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.showClearButton = false,
    this.inputFormatters,
    this.autovalidateMode,
    this.contentPadding,
    this.style,
    this.onTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _hasText;

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller?.text.isNotEmpty ?? false;
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      _hasText = widget.controller?.text.isNotEmpty ?? false;
      widget.controller?.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    final hasText = widget.controller?.text.isNotEmpty ?? false;
    if (_hasText != hasText) {
      if (mounted) {
        setState(() {
          _hasText = hasText;
        });
      }
    }
  }

  void _handleClear() {
    widget.controller?.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Menentukan suffixIcon: jika ada suffix kustom gunakan itu,
    // atau jika showClearButton aktif dan teks terisi, tampilkan tombol clear.
    Widget? effectiveSuffixIcon = widget.suffixIcon;
    if (effectiveSuffixIcon == null &&
        widget.showClearButton &&
        _hasText &&
        widget.enabled &&
        !widget.readOnly) {
      effectiveSuffixIcon = IconButton(
        icon: const Icon(Icons.clear_rounded, size: 18),
        tooltip: 'Hapus teks',
        onPressed: _handleClear,
        color: colorScheme.onSurfaceVariant,
        splashRadius: 20,
      );
    }

    final inputWidget = TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      onEditingComplete: widget.onEditingComplete,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      autovalidateMode: widget.autovalidateMode,
      onTap: widget.onTap,
      style: widget.style ??
          TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurface,
          ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        helperText: widget.helperText,
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon != null
            ? IconTheme(
                data: IconThemeData(
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                child: widget.prefixIcon!,
              )
            : null,
        suffixIcon: effectiveSuffixIcon,
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );

    if (widget.label == null) {
      return inputWidget;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label!,
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        inputWidget,
      ],
    );
  }
}
