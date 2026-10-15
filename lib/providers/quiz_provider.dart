import 'package:flutter/material.dart';
import 'package:project_uas/data/dummy_questions.dart';
import 'package:project_uas/models/question.dart';

/// Provider untuk mengelola state kuis secara terpusat dan reaktif.
///
/// Mengelola informasi peserta, daftar pertanyaan kuis, indeks soal aktif,
/// jawaban yang dipilih, kalkulasi nilai (skor benar, skor salah, persentase),
/// navigasi antar soal, dan fungsi reset/restart kuis.
class QuizProvider extends ChangeNotifier {
  /// Daftar pertanyaan kuis (default menggunakan [dummyQuestions]).
  final List<Question> _questions;

  /// Nama peserta kuis.
  String _userName = '';

  /// Indeks soal aktif saat ini (0-indexed).
  int _currentQuestionIndex = 0;

  /// Map yang memetakan indeks soal ke indeks opsi jawaban yang dipilih (0..3).
  final Map<int, int> _selectedAnswers = {};

  /// Status apakah kuis telah diselesaikan/disubmit oleh peserta.
  bool _isCompleted = false;

  /// Konstruktor QuizProvider, memungkinkan injeksi [questions] untuk testing atau kustomisasi.
  QuizProvider({List<Question>? questions})
      : _questions = questions ?? dummyQuestions;

  // ================= GETTERS =================

  /// Mendapatkan nama peserta kuis.
  String get userName => _userName;

  /// Mendapatkan daftar seluruh pertanyaan dalam kuis (unmodifiable).
  List<Question> get questions => List.unmodifiable(_questions);

  /// Jumlah total pertanyaan.
  int get totalQuestions => _questions.length;

  /// Indeks soal aktif saat ini.
  int get currentQuestionIndex => _currentQuestionIndex;

  /// Nomor soal aktif saat ini untuk tampilan UI (1-indexed).
  int get currentQuestionNumber => _currentQuestionIndex + 1;

  /// Pertanyaan aktif saat ini.
  Question get currentQuestion => _questions[_currentQuestionIndex];

  /// Mendapatkan map seluruh jawaban yang dipilih (unmodifiable).
  Map<int, int> get selectedAnswers => Map.unmodifiable(_selectedAnswers);

  /// Mendapatkan indeks jawaban yang dipilih untuk soal aktif saat ini (bisa null jika belum dijawab).
  int? get currentSelectedAnswer => _selectedAnswers[_currentQuestionIndex];

  /// Mendapatkan indeks jawaban yang dipilih untuk soal pada [questionIndex].
  int? getSelectedAnswer(int questionIndex) => _selectedAnswers[questionIndex];

  /// Memeriksa apakah soal pada [questionIndex] sudah dijawab.
  bool isQuestionAnswered(int questionIndex) =>
      _selectedAnswers.containsKey(questionIndex);

  /// Memeriksa apakah soal aktif saat ini sudah dijawab.
  bool get hasAnsweredCurrent => isQuestionAnswered(_currentQuestionIndex);

  /// Jumlah soal yang sudah dijawab oleh peserta.
  int get answeredQuestionsCount => _selectedAnswers.length;

  /// Memeriksa apakah semua soal sudah dijawab.
  bool get isAllAnswered =>
      _questions.isNotEmpty && _selectedAnswers.length == _questions.length;

  /// Memeriksa apakah sedang berada di soal pertama (indeks 0).
  bool get isFirstQuestion => _currentQuestionIndex == 0;

  /// Memeriksa apakah sedang berada di soal terakhir.
  bool get isLastQuestion =>
      _questions.isNotEmpty && _currentQuestionIndex == _questions.length - 1;

  /// Memeriksa apakah navigasi ke soal sebelumnya memungkinkan.
  bool get canGoPrevious => _currentQuestionIndex > 0;

  /// Memeriksa apakah navigasi ke soal berikutnya memungkinkan.
  bool get canGoNext =>
      _questions.isNotEmpty && _currentQuestionIndex < _questions.length - 1;

  /// Progres pengerjaan kuis dalam rentang 0.0 sampai 1.0 berdasarkan nomor soal aktif.
  double get progress =>
      _questions.isEmpty ? 0.0 : (_currentQuestionIndex + 1) / _questions.length;

  /// Status apakah kuis sudah selesai.
  bool get isCompleted => _isCompleted;

  // ================= SKOR & EVALUASI =================

  /// Jumlah jawaban yang benar.
  int get score {
    int correctCount = 0;
    for (var i = 0; i < _questions.length; i++) {
      final selected = _selectedAnswers[i];
      if (selected != null && _questions[i].isCorrect(selected)) {
        correctCount++;
      }
    }
    return correctCount;
  }

  /// Alias getter untuk kompatibilitas kejelasan deskripsi hasil.
  int get correctAnswersCount => score;

  /// Jumlah jawaban yang salah (yang telah dijawab namun tidak tepat).
  int get wrongAnswersCount {
    int wrongCount = 0;
    for (var i = 0; i < _questions.length; i++) {
      final selected = _selectedAnswers[i];
      if (selected != null && !_questions[i].isCorrect(selected)) {
        wrongCount++;
      }
    }
    return wrongCount;
  }

  /// Jumlah soal yang belum dijawab.
  int get unansweredCount => _questions.length - _selectedAnswers.length;

  /// Nilai persentase skor kuis (rentang 0 s.d. 100).
  double get scorePercentage =>
      _questions.isEmpty ? 0.0 : (score / _questions.length) * 100;

  /// Teks format persentase bilangan bulat (misal: "80%").
  String get scorePercentageFormatted => '${scorePercentage.round()}%';

  /// Pesan evaluasi motivasional berdasarkan persentase skor akhir.
  String get resultMessage {
    final percentage = scorePercentage;
    if (percentage == 100) {
      return 'Sempurna! Semua jawabanmu benar!';
    } else if (percentage >= 80) {
      return 'Luar biasa! Pengetahuanmu sangat luas!';
    } else if (percentage >= 60) {
      return 'Bagus! Kamu sudah memahami banyak hal.';
    } else if (percentage >= 40) {
      return 'Cukup baik! Tingkatkan lagi belajarmu.';
    } else {
      return 'Jangan menyerah! Coba lagi dan raih skor terbaikmu!';
    }
  }

  /// Path aset gambar evaluasi berdasarkan persentase skor.
  String get resultImagePath {
    final percentage = scorePercentage;
    if (percentage >= 80) {
      return 'assets/images/trophy.png';
    } else if (percentage >= 60) {
      return 'assets/images/medal.png';
    } else {
      return 'assets/images/try_again.png';
    }
  }

  // ================= METODE & AKSI =================

  /// Menyimpan nama peserta kuis.
  void setUserName(String name) {
    _userName = name.trim();
    notifyListeners();
  }

  /// Memilih atau mengubah jawaban untuk soal saat ini.
  void selectAnswer(int optionIndex) {
    if (_questions.isEmpty) return;
    assert(
      optionIndex >= 0 &&
          optionIndex < _questions[_currentQuestionIndex].options.length,
      'Index opsi jawaban di luar jangkauan',
    );
    _selectedAnswers[_currentQuestionIndex] = optionIndex;
    notifyListeners();
  }

  /// Memilih atau mengubah jawaban untuk nomor soal tertentu secara eksplisit.
  void selectAnswerFor(int questionIndex, int optionIndex) {
    if (questionIndex < 0 || questionIndex >= _questions.length) return;
    assert(
      optionIndex >= 0 &&
          optionIndex < _questions[questionIndex].options.length,
      'Index opsi jawaban di luar jangkauan',
    );
    _selectedAnswers[questionIndex] = optionIndex;
    notifyListeners();
  }

  /// Berpindah ke soal berikutnya jika belum di akhir daftar soal.
  /// Mengembalikan true jika berhasil berpindah, false jika sudah di soal terakhir.
  bool nextQuestion() {
    if (canGoNext) {
      _currentQuestionIndex++;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Berpindah ke soal sebelumnya jika bukan di soal pertama.
  /// Mengembalikan true jika berhasil berpindah, false jika sudah di soal pertama.
  bool previousQuestion() {
    if (canGoPrevious) {
      _currentQuestionIndex--;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Berpindah langsung ke indeks soal tertentu.
  bool goToQuestion(int index) {
    if (index >= 0 &&
        index < _questions.length &&
        index != _currentQuestionIndex) {
      _currentQuestionIndex = index;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Menandai kuis selesai dan siap menampilkan hasil.
  void completeQuiz() {
    _isCompleted = true;
    notifyListeners();
  }

  /// Mengulang kuis kembali ke nomor awal dengan nama peserta yang sama (reset jawaban dan progres).
  void restartQuiz() {
    _currentQuestionIndex = 0;
    _selectedAnswers.clear();
    _isCompleted = false;
    notifyListeners();
  }

  /// Mereset seluruh state kuis ke kondisi awal (termasuk mengosongkan nama peserta).
  void resetQuiz() {
    _userName = '';
    _currentQuestionIndex = 0;
    _selectedAnswers.clear();
    _isCompleted = false;
    notifyListeners();
  }
}
