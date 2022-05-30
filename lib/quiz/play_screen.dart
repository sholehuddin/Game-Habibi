import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Mendengarkan...';
  String _randomText = randomAlpha(1).toUpperCase();
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
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
                    Consumer<TimeState>(
                        builder: (context, timeState, _) => CustomProgressBar(
                              width: 200,
                              value: timeState.time,
                              totalvalue: 10,
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
                  ],
                ),
              ))),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords.toUpperCase();
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
              if (_text == _randomText) {
                _text = _text + " Jawaban Benar";
              } else {
                _text = _text + " Jawaban Salah";
              }
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      _text = " ";
      _randomText = randomAlpha(1).toUpperCase();
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
  int _time = 10;

  int get time => _time;
  set time(int newTime) {
    _time = newTime;
    notifyListeners();
  }
}
