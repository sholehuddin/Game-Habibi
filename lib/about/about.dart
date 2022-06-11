import 'package:flutter/material.dart';

class about extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TENTANG'),
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
                "Game ini dibuat untuk membantu para siswa sekolah dasar yang kesulitan dalam belajar membaca permulaan",
              )
            ],
          ))
        ],
      ),
    );
  }
}
