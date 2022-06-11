import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:game_alphabet/constants.dart';
import 'package:flutter_svg/svg.dart';
import '../Welcome/welcome_screen.dart';
import '../quiz/play_screen.dart';

class ScoreScreen extends StatefulWidget {
  final String trueAnswer;
  ScoreScreen({required this.trueAnswer});

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset("assets/bg.svg", fit: BoxFit.fill),
          Column(
            children: [
              Spacer(flex: 3),
              Text(
                "SKOR",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(color: kSecondaryColor),
              ),
              Spacer(),
              Text(
                "${widget.trueAnswer}",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(color: kSecondaryColor),
              ),
              Spacer(),
              InkWell(
                onTap: () => Get.to(PlayScreen()),
                child: Container(
                  width: 200,
                  // width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(kDefaultPadding * 0.75), // 15
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradient,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Text(
                    "Mulai Ulang",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () => Get.to(WelcomeScreen()),
                child: Container(
                  width: 200,
                  // width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(kDefaultPadding * 0.75), // 15
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradient,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Text(
                    "Kembali",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: Colors.black),
                  ),
                ),
              ),
              Spacer(flex: 3),
            ],
          )
        ],
      ),
    );
  }
}
