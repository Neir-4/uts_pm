import 'package:flutter_test/flutter_test.dart';
import 'package:project_uas/data/dummy_questions.dart';
import 'package:project_uas/models/question.dart';

void main() {
  group('Question Model Tests', () {
    test('Question instance stores values correctly', () {
      const question = Question(
        text: 'Berapa hasil dari 2 + 2?',
        options: ['1', '2', '3', '4'],
        correctAnswerIndex: 3,
      );

      expect(question.text, 'Berapa hasil dari 2 + 2?');
      expect(question.question, 'Berapa hasil dari 2 + 2?');
      expect(question.options.length, 4);
      expect(question.correctAnswerIndex, 3);
      expect(question.correctAnswer, '4');
      expect(question.isCorrect(3), isTrue);
      expect(question.isCorrect(0), isFalse);
    });

    test('Throws assertion error if correctAnswerIndex is out of range', () {
      expect(
        () => Question(
          text: 'Pertanyaan',
          options: ['A', 'B', 'C', 'D'],
          correctAnswerIndex: 4,
        ),
        throwsAssertionError,
      );

      expect(
        () => Question(
          text: 'Pertanyaan',
          options: ['A', 'B', 'C', 'D'],
          correctAnswerIndex: -1,
        ),
        throwsAssertionError,
      );
    });
  });

  group('Dummy Questions Tests', () {
    test('dummyQuestions contains exactly 10 questions', () {
      expect(dummyQuestions.length, 10);
    });

    test('Every question in dummyQuestions has valid format', () {
      for (var i = 0; i < dummyQuestions.length; i++) {
        final q = dummyQuestions[i];

        // Teks soal tidak boleh kosong
        expect(q.text.trim().isNotEmpty, isTrue, reason: 'Soal #$i teks kosong');

        // Harus memiliki tepat 4 opsi
        expect(q.options.length, 4, reason: 'Soal #$i opsi bukan 4');

        // Setiap opsi tidak boleh kosong
        for (final opt in q.options) {
          expect(opt.trim().isNotEmpty, isTrue, reason: 'Soal #$i ada opsi kosong');
        }

        // Semua opsi dalam satu soal harus unik
        expect(q.options.toSet().length, 4, reason: 'Soal #$i ada opsi duplikat');

        // Index jawaban benar harus valid (0 s.d. 3)
        expect(q.correctAnswerIndex >= 0 && q.correctAnswerIndex < 4, isTrue,
            reason: 'Soal #$i index tidak valid');

        // Jawaban benar harus sesuai
        expect(q.isCorrect(q.correctAnswerIndex), isTrue);
      }
    });
  });
}
