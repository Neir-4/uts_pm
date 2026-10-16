import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_uas/theme/app_theme.dart';

/// Widget input teks kustom yang dapat digunakan kembali (reusable) di seluruh aplikasi.
///
/// Menyediakan label di atas field, validasi form, dukungan tombol bersihkan teks (clear button),
/// ikon awalan/akhiran, serta integrasi tema Light/Dark yang rapi.
class CustomTextField extends StatefulWidget {
  /// Label deskriptif yang tampil di atas kolom isian.
  final String? label;

  /// Teks petunjuk (placeholder) di dalam kolom isian.
  final String? hintText;

  /// Teks bantuan di bawah kolom isian.
  final String? helperText;

  /// Pesan error eksplisit jika tidak menggunakan form validator.
  final String? errorText;

  /// Pengontrol teks untuk membaca atau memodifikasi teks secara terprogram.
  final TextEditingController? controller;

  /// Fungsi validasi nilai input untuk form Flutter.
  final FormFieldValidator<String>? validator;

  /// Callback yang dipanggil saat isi teks berubah.
  final ValueChanged<String>? onChanged;

  /// Callback yang dipanggil saat tombol submit/selesai pada keyboard ditekan.
  final ValueChanged<String>? onFieldSubmitted;

  /// Callback yang dipanggil saat proses pengeditan teks selesai.
  final VoidCallback? onEditingComplete;

  /// Node fokus untuk mengontrol status fokus keyboard.
  final FocusNode? focusNode;

  /// Jenis keyboard virtual yang dimunculkan (teks, angka, email, dsb).
  final TextInputType? keyboardType;

  /// Aksi tombol enter pada keyboard (next, done, go, dsb).
  final TextInputAction? textInputAction;

  /// Konfigurasi kapitalisasi otomatis huruf.
  final TextCapitalization textCapitalization;

  /// Menandakan apakah teks disembunyikan (misalnya untuk kata sandi).
  final bool obscureText;

  /// Menandakan apakah input aktif untuk menerima interaksi.
  final bool enabled;

  /// Menandakan apakah input hanya bisa dibaca (tidak dapat diketik).
  final bool readOnly;

  /// Menandakan apakah input langsung mendapatkan fokus saat layar pertama kali dibuka.
  final bool autofocus;

  /// Jumlah baris maksimum teks. Nilai default adalah 1.
  final int? maxLines;

  /// Jumlah baris minimum teks.
  final int? minLines;

  /// Batas maksimum karakter input.
  final int? maxLength;

  /// Widget ikon yang ditampilkan di awal kolom isian.
  final Widget? prefixIcon;

  /// Widget ikon yang ditampilkan di akhir kolom isian.
  final Widget? suffixIcon;

  /// Jika bernilai `true` dan `controller` disediakan, menampilkan tombol silang untuk menghapus teks saat kolom terisi.
  final bool showClearButton;

  /// Daftar formatter untuk membatasi atau mengubah format teks yang diketik.
  final List<TextInputFormatter>? inputFormatters;

  /// Mode autovalidasi untuk form.
  final AutovalidateMode? autovalidateMode;

  /// Padding konten di dalam kolom input.
  final EdgeInsetsGeometry? contentPadding;

  /// Gaya teks untuk konten yang sedang diketik.
  final TextStyle? style;

  /// Callback saat kolom input diklik/disentuh.
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
