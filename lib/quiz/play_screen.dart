import 'dart:async';
import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../score/score.dart';

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late stt.SpeechToText _speech;
  late Timer _timer;
  bool _isListening = false;
  String _text = '';
  String _randomText = '';
  double _confidence = 1.0;
  int _countQuestion = 0;
  int _trueAnswer = 0;
  String _startButton = 'Mulai';
  int durasi = 15;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Akurasi : ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: AvatarGlow(
      //   animate: _isListening,
      //   glowColor: Theme.of(context).primaryColor,
      //   endRadius: 75.0,
      //   duration: const Duration(milliseconds: 2000),
      //   repeatPauseDuration: const Duration(milliseconds: 100),
      //   repeat: true,
      //   child: FloatingActionButton(
      //     onPressed: _listen,
      //     child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      //   ),
      // ),
      body: SingleChildScrollView(
          reverse: true,
          child: Container(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
              child: ChangeNotifierProvider<TimeState>(
                create: (context) => TimeState(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text("Soal : " + _countQuestion.toString()),
                    // Text("Jawaban Benar : " + _trueAnswer.toString()),
                    Consumer<TimeState>(
                        builder: (context, timeState, _) => CustomProgressBar(
                              width: 250,
                              value: timeState.time,
                              totalvalue: durasi,
                            )),
                    Text(
                      _randomText,
                      style: TextStyle(fontSize: 250),
                    ),
                    Text(
                      _text,
                      style: const TextStyle(
                        fontSize: 32.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Consumer<TimeState>(
                        builder: (context, timeState, _) =>
                            FloatingActionButton(
                                onPressed: !_isListening
                                    ? () {
                                        if (_startButton == "Mulai" ||
                                            _startButton == "Lanjut")
                                          timeState.time = durasi;
                                        _soal(timeState);
                                      }
                                    : null,
                                child: Text(_startButton)))
                    //child: Icon(_isListening ? Icons.mic : Icons.mic_none)))
                  ],
                ),
              ))),
    );
  }

  void _soal(TimeState timeState) async {
    if (_startButton == "Skor") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ScoreScreen(trueAnswer: (_trueAnswer * 10).toString())));
    } else if (_startButton == "Jawab") {
      _listen(timeState);
    } else if (_startButton == "Mulai" || _startButton == "Lanjut") {
      _text = ' ';
      _countQuestion++;
      _startButton = "Jawab";
      setState(() => _randomText = randomAlpha(1).toUpperCase());
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (timeState.time == 0) {
          timer.cancel();
          setState(() {
            _text = 'Waktu Habis';
            _startButton = (_countQuestion >= 10) ? "Skor" : "Lanjut";
            setState(() => _isListening = false);
            _speech.stop();
          });
        } else {
          timeState.time -= 1;
        }
      });
    }
  }

  void _listen(TimeState timeState) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
        finalTimeout: const Duration(seconds: 100),
      );
      if (available) {
        setState(() => _isListening = true);
        _text = 'Mendengarkan...';
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords.toUpperCase();
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
              Similarity(words: _text).similarity().then((value) => {
                    if (value == _randomText)
                      {
                        _timer.cancel(),
                        _text = value + " Jawaban Benar",
                        _trueAnswer++,
                        setState(() => _isListening = false),
                        _startButton =
                            (_countQuestion >= 10) ? "Skor" : "Lanjut",
                        _speech.stop()
                      }
                    else
                      {
                        _text = value + " Jawaban Salah",
                        _timer.cancel(),
                        setState(() => _isListening = false),
                        _startButton =
                            (_countQuestion >= 10) ? "Skor" : "Lanjut",
                        _speech.stop()
                      }
                  });
            } else {
              _text = "Memeriksa Jawaban";
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      _text = " ";
      //_randomText = randomAlpha(1).toUpperCase();
    }
  }
}

class CustomProgressBar extends StatelessWidget {
  final double width;
  final int value;
  final int totalvalue;

  const CustomProgressBar(
      {required this.width, required this.value, required this.totalvalue});

  @override
  Widget build(BuildContext context) {
    double ratio = value / totalvalue;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.timer,
          color: Colors.grey[700],
        ),
        SizedBox(
          width: 5,
        ),
        Stack(
          children: <Widget>[
            Container(
              width: width,
              height: 10,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5)),
            ),
            Material(
              borderRadius: BorderRadius.circular(5),
              elevation: 3,
              child: AnimatedContainer(
                height: 10,
                width: width * ratio,
                duration: Duration(milliseconds: 500),
                decoration: BoxDecoration(
                    color: (ratio < 0.3)
                        ? Colors.red
                        : (ratio < 0.6)
                            ? Colors.amber[400]
                            : Colors.lightGreen,
                    borderRadius: BorderRadius.circular(5)),
              ),
            )
          ],
        )
      ],
    );
  }
}

class TimeState with ChangeNotifier {
  int _time = 15;

  int get time => _time;
  set time(int newTime) {
    _time = newTime;
    notifyListeners();
  }
}

class Similarity {
  Similarity({required this.words});
  final String words;

  Future<String> similarity() async {
    String wordsSims = "";
    switch (words) {
      case "ES":
        wordsSims = "S";
        break;
      case "KAK":
        wordsSims = "K";
        break;
      case "HAK":
        wordsSims = "H";
        break;
      case "HAH":
        wordsSims = "H";
        break;
      case "KI":
        wordsSims = "Q";
        break;
      case "DEK":
        wordsSims = "D";
        break;
      case "IH":
        wordsSims = "I";
        break;
      case "OH":
        wordsSims = "O";
        break;
      case "UH":
        wordsSims = "U";
        break;
      case "WEI":
        wordsSims = "W";
        break;
      case "WOI":
        wordsSims = "W";
        break;
      default:
        wordsSims = words;
        break;
    }
    return wordsSims;
  }
}
