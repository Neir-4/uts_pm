import 'package:flutter_test/flutter_test.dart';
import 'package:project_uas/data/dummy_questions.dart';
import 'package:project_uas/models/question.dart';
import 'package:project_uas/providers/quiz_provider.dart';

void main() {
  group('QuizProvider - Initial State & User Info', () {
    test('Initial properties have expected default values', () {
      final provider = QuizProvider();

      expect(provider.userName, isEmpty);
      expect(provider.totalQuestions, 10);
      expect(provider.currentQuestionIndex, 0);
      expect(provider.currentQuestionNumber, 1);
      expect(provider.currentQuestion.text, dummyQuestions[0].text);
      expect(provider.selectedAnswers, isEmpty);
      expect(provider.currentSelectedAnswer, isNull);
      expect(provider.hasAnsweredCurrent, isFalse);
      expect(provider.answeredQuestionsCount, 0);
      expect(provider.isAllAnswered, isFalse);
      expect(provider.isFirstQuestion, isTrue);
      expect(provider.isLastQuestion, isFalse);
      expect(provider.canGoPrevious, isFalse);
      expect(provider.canGoNext, isTrue);
      expect(provider.progress, 0.0);
      expect(provider.isCompleted, isFalse);
      expect(provider.score, 0);
      expect(provider.correctAnswersCount, 0);
      expect(provider.wrongAnswersCount, 0);
      expect(provider.unansweredCount, 10);
      expect(provider.scorePercentage, 0.0);
      expect(provider.scorePercentageFormatted, '0%');
    });

    test('setUserName trims input and notifies listeners', () {
      final provider = QuizProvider();
      var notificationCount = 0;
      provider.addListener(() => notificationCount++);

      provider.setUserName('   Budi Santoso   ');

      expect(provider.userName, 'Budi Santoso');
      expect(notificationCount, 1);
    });
  });

  group('QuizProvider - Navigation', () {
    test('nextQuestion and previousQuestion navigate correctly with boundary checks', () {
      final provider = QuizProvider();

      // Di awal, tidak bisa previous
      expect(provider.previousQuestion(), isFalse);
      expect(provider.currentQuestionIndex, 0);

      // Pindah ke soal berikutnya
      expect(provider.nextQuestion(), isTrue);
      expect(provider.currentQuestionIndex, 1);
      expect(provider.currentQuestionNumber, 2);
      expect(provider.canGoPrevious, isTrue);

      // Pindah ke soal sebelumnya
      expect(provider.previousQuestion(), isTrue);
      expect(provider.currentQuestionIndex, 0);
      expect(provider.canGoPrevious, isFalse);

      // Navigasi hingga soal terakhir
      for (var i = 0; i < 9; i++) {
        expect(provider.nextQuestion(), isTrue);
      }
      expect(provider.currentQuestionIndex, 9);
      expect(provider.isLastQuestion, isTrue);
      expect(provider.canGoNext, isFalse);

      // Tidak bisa lanjut melebihi batas soal terakhir
      expect(provider.nextQuestion(), isFalse);
      expect(provider.currentQuestionIndex, 9);
    });

    test('goToQuestion navigates directly to valid question index', () {
      final provider = QuizProvider();

      expect(provider.goToQuestion(5), isTrue);
      expect(provider.currentQuestionIndex, 5);

      // Ke index yang sama mengembalikan false (tidak ada perubahan)
      expect(provider.goToQuestion(5), isFalse);

      // Ke index di luar jangkauan mengembalikan false
      expect(provider.goToQuestion(-1), isFalse);
      expect(provider.goToQuestion(10), isFalse);
      expect(provider.currentQuestionIndex, 5);
    });
  });

  group('QuizProvider - Answer Selection', () {
    test('selectAnswer records and updates answer for current question', () {
      final provider = QuizProvider();
      var notifyCount = 0;
      provider.addListener(() => notifyCount++);

      // Pilih jawaban opsi 1 untuk soal nomor 0
      provider.selectAnswer(1);
      expect(provider.currentSelectedAnswer, 1);
      expect(provider.getSelectedAnswer(0), 1);
      expect(provider.isQuestionAnswered(0), isTrue);
      expect(provider.hasAnsweredCurrent, isTrue);
      expect(provider.answeredQuestionsCount, 1);
      expect(provider.progress, closeTo(0.1, 0.001));
      expect(notifyCount, 1);

      // Berpindah soal tanpa menjawab soal kedua tidak menambah progress
      provider.nextQuestion();
      expect(provider.currentQuestionIndex, 1);
      expect(provider.progress, closeTo(0.1, 0.001));
      provider.previousQuestion();

      // Ganti jawaban untuk soal nomor 0 (tetap 1 terjawab)
      provider.selectAnswer(3);
      expect(provider.currentSelectedAnswer, 3);
      expect(provider.getSelectedAnswer(0), 3);
      expect(provider.answeredQuestionsCount, 1);
      expect(provider.progress, closeTo(0.1, 0.001));
      expect(notifyCount, 4);
    });

    test('selectAnswerFor allows setting answer for specific question index', () {
      final provider = QuizProvider();

      provider.selectAnswerFor(4, 2);
      expect(provider.getSelectedAnswer(4), 2);
      expect(provider.isQuestionAnswered(4), isTrue);
      expect(provider.answeredQuestionsCount, 1);

      // Memilih nomor di luar batas diabaikan tanpa error
      provider.selectAnswerFor(-1, 0);
      provider.selectAnswerFor(20, 0);
      expect(provider.answeredQuestionsCount, 1);
    });
  });

  group('QuizProvider - Scoring and Evaluation', () {
    test('Calculates score and percentage accurately with dummy questions', () {
      final provider = QuizProvider();

      // Jawab semua soal dummy dengan kunci jawaban yang benar
      for (var i = 0; i < dummyQuestions.length; i++) {
        provider.goToQuestion(i);
        provider.selectAnswer(dummyQuestions[i].correctAnswerIndex);
      }

      expect(provider.isAllAnswered, isTrue);
      expect(provider.score, 10);
      expect(provider.correctAnswersCount, 10);
      expect(provider.wrongAnswersCount, 0);
      expect(provider.unansweredCount, 0);
      expect(provider.scorePercentage, 100.0);
      expect(provider.scorePercentageFormatted, '100%');
      expect(provider.resultMessage, contains('Sempurna'));
      expect(provider.resultImagePath, 'assets/images/trophy.png');
    });

    test('Calculates wrong answers and mixed scores correctly', () {
      // Injeksi kuis khusus dengan 4 soal
      final customQuestions = [
        const Question(text: 'Q1', options: ['A', 'B', 'C', 'D'], correctAnswerIndex: 0),
        const Question(text: 'Q2', options: ['A', 'B', 'C', 'D'], correctAnswerIndex: 1),
        const Question(text: 'Q3', options: ['A', 'B', 'C', 'D'], correctAnswerIndex: 2),
        const Question(text: 'Q4', options: ['A', 'B', 'C', 'D'], correctAnswerIndex: 3),
      ];

      final provider = QuizProvider(questions: customQuestions);

      // Q0 benar (pilih 0)
      provider.selectAnswerFor(0, 0);
      // Q1 salah (pilih 2, seharusnya 1)
      provider.selectAnswerFor(1, 2);
      // Q2 benar (pilih 2)
      provider.selectAnswerFor(2, 2);
      // Q3 belum dijawab

      expect(provider.score, 2);
      expect(provider.wrongAnswersCount, 1);
      expect(provider.unansweredCount, 1);
      expect(provider.scorePercentage, 50.0);
      expect(provider.scorePercentageFormatted, '50%');
      expect(provider.resultMessage, contains('Cukup baik'));
      expect(provider.resultImagePath, 'assets/images/try_again.png');
    });

    test('Evaluates medal tier when score is between 60% and 79%', () {
      final customQuestions = [
        const Question(text: 'Q1', options: ['A', 'B', 'C', 'D'], correctAnswerIndex: 0),
        const Question(text: 'Q2', options: ['A', 'B', 'C', 'D'], correctAnswerIndex: 0),
        const Question(text: 'Q3', options: ['A', 'B', 'C', 'D'], correctAnswerIndex: 0),
        const Question(text: 'Q4', options: ['A', 'B', 'C', 'D'], correctAnswerIndex: 0),
        const Question(text: 'Q5', options: ['A', 'B', 'C', 'D'], correctAnswerIndex: 0),
      ];

      final provider = QuizProvider(questions: customQuestions);
      // 3 benar dari 5 = 60%
      provider.selectAnswerFor(0, 0);
      provider.selectAnswerFor(1, 0);
      provider.selectAnswerFor(2, 0);
      provider.selectAnswerFor(3, 1); // salah
      provider.selectAnswerFor(4, 1); // salah

      expect(provider.score, 3);
      expect(provider.scorePercentage, 60.0);
      expect(provider.resultMessage, contains('Bagus'));
      expect(provider.resultImagePath, 'assets/images/medal.png');
    });
  });

  group('QuizProvider - Completion and Resetting', () {
    test('completeQuiz sets isCompleted flag', () {
      final provider = QuizProvider();
      expect(provider.isCompleted, isFalse);

      provider.completeQuiz();
      expect(provider.isCompleted, isTrue);
    });

    test('restartQuiz resets question index, answers, and completion, but keeps userName', () {
      final provider = QuizProvider();
      provider.setUserName('Dewi Lestari');
      provider.goToQuestion(5);
      provider.selectAnswer(2);
      provider.completeQuiz();

      expect(provider.userName, 'Dewi Lestari');
      expect(provider.currentQuestionIndex, 5);
      expect(provider.isCompleted, isTrue);

      provider.restartQuiz();

      expect(provider.userName, 'Dewi Lestari'); // Nama dipertahankan
      expect(provider.currentQuestionIndex, 0); // Kembali ke nomor 1
      expect(provider.selectedAnswers, isEmpty); // Jawaban dikosongkan
      expect(provider.isCompleted, isFalse);
    });

    test('resetQuiz resets all state including userName', () {
      final provider = QuizProvider();
      provider.setUserName('Dewi Lestari');
      provider.goToQuestion(7);
      provider.selectAnswer(1);
      provider.completeQuiz();

      provider.resetQuiz();

      expect(provider.userName, isEmpty); // Nama dikosongkan
      expect(provider.currentQuestionIndex, 0);
      expect(provider.selectedAnswers, isEmpty);
      expect(provider.isCompleted, isFalse);
    });
  });
}
