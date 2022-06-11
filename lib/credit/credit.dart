import 'package:flutter/material.dart';

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
              const SizedBox(
                height: 15,
              ),
              Text(
                  "Ahmad Aulia Rahman Habibi (181021400179) Mahasiswa Program Studi Teknik Informatika UNPAM")
            ],
          ))
        ],
      ),
    );
  }
}
