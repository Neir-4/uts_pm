/// Model representasi satu butir soal pilihan ganda pada kuis.
class Question {
  /// Teks pertanyaan kuis.
  final String text;

  /// Daftar pilihan jawaban (berisi 4 pilihan jawaban).
  final List<String> options;

  /// Indeks jawaban yang benar di dalam daftar [options] (rentang 0 sampai 3).
  final int correctAnswerIndex;

  const Question({
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
  }) : assert(
          correctAnswerIndex >= 0 && correctAnswerIndex <= 3,
          'correctAnswerIndex harus berada di rentang 0 sampai 3',
        );

  /// Getter alias untuk kompatibilitas jika diakses dengan nama properti [question].
  String get question => text;

  /// Mendapatkan teks string jawaban yang benar berdasarkan [correctAnswerIndex].
  String get correctAnswer => options[correctAnswerIndex];

  /// Memeriksa apakah indeks jawaban yang dipilih pengguna adalah jawaban yang benar.
  bool isCorrect(int selectedIndex) => selectedIndex == correctAnswerIndex;
}
