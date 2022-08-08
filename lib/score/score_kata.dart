import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:game_alphabet/constants.dart';
import 'package:flutter_svg/svg.dart';
import '../Welcome/welcome_screen.dart';
import '../quiz/play_screen_kata.dart';

class ScoreScreen_kata extends StatefulWidget {
  final String trueAnswerKata;
  ScoreScreen_kata({required this.trueAnswerKata});

  @override
  _ScoreScreenStateKata createState() => _ScoreScreenStateKata();
}

class _ScoreScreenStateKata extends State<ScoreScreen_kata> {
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
                "${widget.trueAnswerKata}",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(color: kSecondaryColor),
              ),
              Spacer(),
              InkWell(
                onTap: () => Get.to(PlayScreen_kata()),
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
