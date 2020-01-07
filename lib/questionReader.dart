import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quizzler/questionCore.dart';

Future<QuestionCore> readQuestions() async {
  QuestionCore questionCore;
  final response =
      await http.get('https://adrianmuntean.pythonanywhere.com/flutter-quiz');
  if (response.statusCode == 200) {
    questionCore = QuestionCore().fromJson(json.decode(response.body));
  }

  return questionCore;
}
