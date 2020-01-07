import 'package:flutter/material.dart';

import 'questionCore.dart';
import 'questionReader.dart';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  QuestionCore questionCore;
  List<Icon> scoreKeeper = [];
  int score = 0;
  bool progressVisible = true;

  void checkAnswer(bool selection) {
    if (questionCore == null) {
      return;
    }

    Icon icon = questionCore.getAnswer() == selection
        ? Icon(Icons.check, color: Colors.green)
        : Icon(Icons.close, color: Colors.red);

    setState(() {
      if (questionCore.currentQuestionIsAvailable()) {
        scoreKeeper.add(icon);
        if (icon.color == Colors.green) {
          score++;
        }
      }
      if (!questionCore.nextQuestion()) {
        showEndDialog();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    readQuestions().then((core) {
      setState(() {
        questionCore = core;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: questionCore != null
                  ? Text(
                      questionCore.getQuestion(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    )
                  : CircularProgressIndicator(),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: questionCore != null
                  ? () {
                      checkAnswer(true);
                    }
                  : null,
              disabledColor: Colors.blueGrey,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: questionCore != null
                  ? () {
                      checkAnswer(false);
                    }
                  : null,
              disabledColor: Colors.blueGrey,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() {
            progressVisible = !progressVisible;
          }),
          child: progressVisible
              ? Row(
                  children: <Widget>[
                    Text(
                      'Progress:',
                      style: TextStyle(color: Colors.white),
                    ),
                    ...scoreKeeper,
                  ],
                )
              : Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => setState(() {
                        progressVisible = !progressVisible;
                      }),
                      child: Text(
                        'Switch to score',
                        style: TextStyle(
                            color: Colors.white,
                            backgroundColor: Colors.blueGrey),
                      ),
                    ),
                    Text(
                      ' or ',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: resetAll,
                      child: Text(
                        'Reset',
                        style: TextStyle(
                            color: Colors.white,
                            backgroundColor: Colors.blueGrey),
                      ),
                    )
                  ],
                ),
        )
      ],
    );
  }

  void resetAll() {
    setState(() {
      progressVisible = true;
      questionCore.reset();
      scoreKeeper.clear();
      score = 0;
    });
  }

  void showEndDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('End'),
          content: Text('Congrats, you achieved a score of $score'),
          actions: <Widget>[
            FlatButton(
              child: Text('Reset'),
              onPressed: () {
                resetAll();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
