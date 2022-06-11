import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';

class credit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CREDIT'),
      ),
      body: Stack(
        children: [
          SafeArea(
              child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  "Nama : Ahmad Aulia Rahman Habibi",
                  textAlign: TextAlign.left,
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
