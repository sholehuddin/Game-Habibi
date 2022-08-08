import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../score/score_kata.dart';

class PlayScreen_kata extends StatefulWidget {
  @override
  _PlayScreenStateKata createState() => _PlayScreenStateKata();
}

class _PlayScreenStateKata extends State<PlayScreen_kata> {
  late stt.SpeechToText _speech;
  late Timer _timer;
  bool _isListening = false;
  String _text = '';
  String _randomText = '';
  double _confidence = 1.0;
  int _countQuestionKata = 0;
  int _trueAnswerKata = 0;
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
                              width: 250,
                              value: timeState.time,
                              totalvalue: durasi,
                            )),
                    const SizedBox(
                      height: 100,
                    ),
                    Text(
                      _randomText,
                      style: TextStyle(fontSize: 80),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Text(
                      _text,
                      style: const TextStyle(
                        fontSize: 28.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 70,
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
              builder: (context) => ScoreScreen_kata(
                  trueAnswerKata: (_trueAnswerKata).toString())));
    } else if (_startButton == "Jawab") {
      _listen(timeState);
    } else if (_startButton == "Mulai" || _startButton == "Lanjut") {
      _text = ' ';
      _countQuestionKata++;
      _startButton = "Jawab";
      List soal = [
        'BUNGA',
        'TOPI',
        'SAPI',
        'AYAH',
        'BAJU',
        'HIDUNG',
        'IBU',
        'MATA',
        'PERAHU',
        'TAS'
      ];
      final random = Random();
      setState(() => _randomText = soal[random.nextInt(soal.length)]);
      final player = AudioPlayer();
      if (_randomText == 'BUNGA') {
        player.play(AssetSource('Bunga.mp3'), volume: 1);
        player.stop();
      } else if (_randomText == 'TOPI') {
        player.play(AssetSource('Topi.mp3'), volume: 1);
        player.stop();
      } else if (_randomText == 'SAPI') {
        player.play(AssetSource('Sapi.mp3'), volume: 1);
        player.stop();
      } else if (_randomText == 'AYAH') {
        player.play(AssetSource('Ayah.mp3'), volume: 1);
        player.stop();
      } else if (_randomText == 'BAJU') {
        player.play(AssetSource('Baju.mp3'), volume: 1);
        player.stop();
      } else if (_randomText == 'HIDUNG') {
        player.play(AssetSource('Hidung.mp3'), volume: 1);
        player.stop();
      } else if (_randomText == 'IBU') {
        player.play(AssetSource('Ibu.mp3'), volume: 1);
        player.stop();
      } else if (_randomText == 'MATA') {
        player.play(AssetSource('Mata.mp3'), volume: 1);
        player.stop();
      } else if (_randomText == 'PERAHU') {
        player.play(AssetSource('Perahu.mp3'), volume: 1);
        player.stop();
      } else if (_randomText == 'TAS') {
        player.play(AssetSource('Tas.mp3'), volume: 1);
        player.stop();
      }
      // setState(() => _randomText = randomAlpha(1).toUpperCase());
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (timeState.time == 0) {
          timer.cancel();
          setState(() {
            _text = 'Waktu Habis';
            _startButton = (_countQuestionKata >= 5) ? "Skor" : "Lanjut";
            setState(() => _isListening = false);
            _speech.stop();
          });
        } else {
          timeState.time -= 1;
        }
      });
    }
  }

  // void _suara() {
  // final player = AudioPlayer();
  // player.play(AssetSource('Jawabannya.mp3'));
  // }

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
            // if (val.hasConfidenceRating && val.confidence < 0) {
            //   _confidence = val.confidence;
            // Similarity(words: _text).similarity().then((value) => {
            if (_text == _randomText) {
              _timer.cancel();
              _text = _text + " Jawaban Benar";
              _trueAnswerKata++;
              setState(() => _isListening = false);
              _startButton = (_countQuestionKata >= 5) ? "Skor" : "Lanjut";
              //_speech.stop();
            } else {
              _timer.cancel();
              _text = _text + " Jawaban Salah";
              setState(() => _isListening = false);
              _startButton = (_countQuestionKata >= 5) ? "Skor" : "Lanjut";
              //_speech.stop();
            }
            // });
            // } else {
            //   _text = "Memeriksa Jawaban";
            // }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      _text = " ";
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
