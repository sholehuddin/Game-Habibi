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
                "Game ini dibuat untuk membantu para siswa sekolah dasar yang kesulitan dalam belajar membaca permulaan. Cara memainkan game ini mudah cukup klik MAIN pada menu utama. Kemudian klik mulai untuk memunculkan pertanyaan. Setelah menekan tombol mulai maka waktu akan mulai berjalan. Waktu yang diberikan untuk menjawab pertanyaan adalah 10 detik. Jawablah pertanyaan dengan menggunakan suara yang jelas dan lantang. Pertanyaan dalam satu sesi berjumlah 10 pertanyaan. Lalu lihat hasil kemampuan membaca dan melafalkan pada skor akhir.",
              )
            ],
          ))
        ],
      ),
    );
  }
}
