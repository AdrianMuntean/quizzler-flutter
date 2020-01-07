import 'question.dart';

class QuestionCore {
  List<Question> _questions = [];
  int _currentQuestion = 0;

  fromJson(List<dynamic> list) {
    for (final item in list) {
      bool answer = item['a'].toLowerCase() == 'true';
      _questions.add(Question(item['q'], answer));
    }
    return this;
  }

  String getQuestion() {
    return _questions[_currentQuestion].questionText;
  }

  bool getAnswer() {
    return _questions[_currentQuestion].questionAnswer;
  }

  bool nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      _currentQuestion++;
      return true;
    }

    return false;
  }

  bool currentQuestionIsAvailable() => _currentQuestion < _questions.length;

  void reset() {
    _currentQuestion = 0;
  }
}
