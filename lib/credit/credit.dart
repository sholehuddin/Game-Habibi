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
              Text(
                "Ahmad Aulia Rahman Habibi                                        " +
                    "181021400179                                                                              " +
                    "Program Studi Teknik Informatika Universitas Pamulang",
              ),
            ],
          ))
        ],
      ),
    );
  }
}
