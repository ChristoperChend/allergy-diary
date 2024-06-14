// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String text;
  const ResultScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Komposisi',
          style: TextStyle(fontFamily: 'Outfit', fontSize: 25),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, 
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.chevron_left)),
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
            child: Column(
          children: [
            const Text(
              'Komposisi Makanan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(text, style: const TextStyle(fontSize: 15),),
          ],
        )),
      ),
    );
  }
}
