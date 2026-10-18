class Question {
  final String text;

  final List<String> options;

  final int correctAnswerIndex;

  const Question({
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
  }) : assert(
          correctAnswerIndex >= 0 && correctAnswerIndex <= 3,
          'correctAnswerIndex harus berada di rentang 0 sampai 3',
        );

  String get question => text;

  String get correctAnswer => options[correctAnswerIndex];

  bool isCorrect(int selectedIndex) => selectedIndex == correctAnswerIndex;
}
