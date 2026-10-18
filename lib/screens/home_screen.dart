import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_uas/providers/quiz_provider.dart';
import 'package:project_uas/providers/theme_provider.dart';
import 'package:project_uas/screens/quiz_screen.dart';
import 'package:project_uas/widgets/custom_text_field.dart';
import 'package:project_uas/widgets/primary_button.dart';

/// Layar utama (HomeScreen) aplikasi Quiz Umum.

class HomeScreen extends StatefulWidget {
  final void Function(String name)? onQuizStarted;

  const HomeScreen({
    super.key,
    this.onQuizStarted,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final existingName = context.read<QuizProvider>().userName;
    _nameController = TextEditingController(text: existingName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _startQuiz() {
    if (_formKey.currentState?.validate() ?? false) {
      final trimmedName = _nameController.text.trim();
      final quizProvider = context.read<QuizProvider>();

      quizProvider.setUserName(trimmedName);
      quizProvider.restartQuiz();

      if (widget.onQuizStarted != null) {
        widget.onQuizStarted!(trimmedName);
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const QuizScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Umum'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: isDark ? 'Ganti ke Mode Terang' : 'Ganti ke Mode Gelap',
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Image.asset(
                        'assets/images/logo.png',
                        height: 120.0,
                        width: 120.0,
                        fit: BoxFit.contain,
                    )
                  ),
                  const SizedBox(height: 20),
                  // Judul & Deskripsi Kuis
                  Text(
                    'Quiz Pengetahuan Umum',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Uji ketangkasan wawasanmu dengan 10 pertanyaan pilihan ganda seputar sains, sejarah, dan kebudayaan.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Kartu Form Input Nama & Tombol Mulai
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTextField(
                              controller: _nameController,
                              label: 'Nama Peserta',
                              
                              hintText: 'Contoh: Ripki Al Soki',
                              prefixIcon: const Icon(Icons.person_outline_rounded),
                              showClearButton: true,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _startQuiz(),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Nama peserta tidak boleh kosong';
                                }
                                if (value.trim().length < 2) {
                                  return 'Nama minimal terdiri dari 2 karakter';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            PrimaryButton(
                              text: 'Mulai Kuis',
                              icon: Icons.play_arrow_rounded,
                              onPressed: _startQuiz,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
