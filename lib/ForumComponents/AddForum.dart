// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddForumPage extends StatefulWidget {
  const AddForumPage({super.key});

  @override
  State<AddForumPage> createState() => _AddForumPageState();
}

class _AddForumPageState extends State<AddForumPage> {
  final TextEditingController _contentController = TextEditingController();

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Empty Content', style: TextStyle(fontFamily: 'Outfit'),),
          content: const Text('Please fill in the content before submitting.', style: TextStyle(fontFamily: 'Outfit'),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);
    String? username;
    userDocRef.get().then((DocumentSnapshot document) {
      if (document.exists) {
        setState(() {
          username = (document.data() as Map<String, dynamic>)['name'];
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Unggah Forum',
          style: TextStyle(fontFamily: 'Outfit', fontSize: 25),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.chevron_left)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color.fromRGBO(143, 174, 222, 1)),
            ),
            child: GestureDetector(
              onTap: () {
                if (_contentController.text.isEmpty) {
                  _showAlertDialog();
                } else {
                  FirebaseFirestore.instance.collection('forums').add({
                    'content': _contentController.text,
                    'name': username,
                    'likes': 0,
                    'comments': 0,
                    'repliesCount': 0,
                    'timestamp': FieldValue.serverTimestamp(),
                  }).then((_) {
                    Navigator.pop(context);
                  });
                }
              },
              child: const Text(
                'Kirim',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            children: [
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: 'Tulis ceritamu disini',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.image, size: 30),
                  Icon(Icons.camera_alt, size: 30),
                  Icon(Icons.insert_emoticon, size: 30),
                  Icon(Icons.more_horiz, size: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
