import 'package:flutter/material.dart';
import 'package:project_uas/data/dummy_questions.dart';
import 'package:project_uas/models/question.dart';

/// Provider untuk mengelola informasi kuis seperti pertanyaan, 
/// jawaban yang dipilih dan perhitungan nilai dan navigasi antar soal

class QuizProvider extends ChangeNotifier {
  /// Daftar pertanyaan kuis 
  final List<Question> _questions;

  String _userName = '';

  int _currentQuestionIndex = 0;

  final Map<int, int> _selectedAnswers = {};

  bool _isCompleted = false;

  QuizProvider({List<Question>? questions})
      : _questions = questions ?? dummyQuestions;

  // ====== GETTER ======

  String get userName => _userName;

  List<Question> get questions => List.unmodifiable(_questions);

  int get totalQuestions => _questions.length;

  int get currentQuestionIndex => _currentQuestionIndex;

  int get currentQuestionNumber => _currentQuestionIndex + 1;

  Question get currentQuestion => _questions[_currentQuestionIndex];

  Map<int, int> get selectedAnswers => Map.unmodifiable(_selectedAnswers);

  int? get currentSelectedAnswer => _selectedAnswers[_currentQuestionIndex];

  int? getSelectedAnswer(int questionIndex) => _selectedAnswers[questionIndex];

  bool isQuestionAnswered(int questionIndex) =>
      _selectedAnswers.containsKey(questionIndex);

  bool get hasAnsweredCurrent => isQuestionAnswered(_currentQuestionIndex);

  int get answeredQuestionsCount => _selectedAnswers.length;

  bool get isAllAnswered =>
      _questions.isNotEmpty && _selectedAnswers.length == _questions.length;

  bool get isFirstQuestion => _currentQuestionIndex == 0;

  bool get isLastQuestion =>
      _questions.isNotEmpty && _currentQuestionIndex == _questions.length - 1;

  bool get canGoPrevious => _currentQuestionIndex > 0;

  bool get canGoNext =>
      _questions.isNotEmpty && _currentQuestionIndex < _questions.length - 1;

  double get progress =>
      _questions.isEmpty ? 0.0 : _selectedAnswers.length / _questions.length;

  bool get isCompleted => _isCompleted;

  // ===== SKOR & EVALUASI ======

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

  int get correctAnswersCount => score;

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

  int get unansweredCount => _questions.length - _selectedAnswers.length;

  double get scorePercentage =>
      _questions.isEmpty ? 0.0 : (score / _questions.length) * 100;

  String get scorePercentageFormatted => '${scorePercentage.round()}%';

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

  String get resultImagePath {
    final percentage = scorePercentage;
    if (percentage >= 80) {
      return 'assets/images/perfect.png';
    } else if (percentage >= 60) {
      return 'assets/images/almost.png';
    } else {
      return 'assets/images/fail.png';
    }
  }

  // ========= METODE & AKSI =========

  void setUserName(String name) {
    _userName = name.trim();
    notifyListeners();
  }

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


  bool nextQuestion() {
    if (canGoNext) {
      _currentQuestionIndex++;
      notifyListeners();
      return true;
    }
    return false;
  }


  bool previousQuestion() {
    if (canGoPrevious) {
      _currentQuestionIndex--;
      notifyListeners();
      return true;
    }
    return false;
  }

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

  void completeQuiz() {
    _isCompleted = true;
    notifyListeners();
  }

  void restartQuiz() {
    _currentQuestionIndex = 0;
    _selectedAnswers.clear();
    _isCompleted = false;
    notifyListeners();
  }

  void resetQuiz() {
    _userName = '';
    _currentQuestionIndex = 0;
    _selectedAnswers.clear();
    _isCompleted = false;
    notifyListeners();
  }
}
