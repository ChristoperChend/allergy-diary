// ignore_for_file: avoid_print, await_only_futures, file_names

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/page/HomePage.dart';
import 'package:project/page/SignUpPage.dart';

class NumberVerifPage extends StatefulWidget {
  final String verificationId;
  const NumberVerifPage({super.key, required this.verificationId});

  @override
  State<NumberVerifPage> createState() => _NumberVerifPageState();
}

class _NumberVerifPageState extends State<NumberVerifPage> {
  final otpController = TextEditingController();
  int sec = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (sec == 0) {
        timer.cancel();
      } else {
        setState(() {
          sec--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> signUp() async {
    String email = AuthController().email;
    String password = AuthController().pass;

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      showErrorDialog(e.toString());
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Center(
          child: Text(message,
              style: const TextStyle(
                  fontFamily: 'Kadwa',
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int minutes = (sec / 60).floor();
    int remainingSec = sec % 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify Your Account',
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 50),

              //! Enter verification code
              const Text(
                'Enter your verification code',
                style: TextStyle(fontFamily: 'Outfit', fontSize: 20),
              ),

              const SizedBox(height: 10),

              //! OTP TextBox
              TextField(
                controller: otpController,
                obscureText: false,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  fillColor: Color.fromRGBO(243, 246, 250, 1),
                  filled: true,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),

              const SizedBox(height: 10),

              //! Warning text
              Text(
                'Please enter the One Time Passcode we have sent to your number',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),

              const SizedBox(height: 5),

              //! Timer countdown
              Text(
                  '${minutes.toString().padLeft(2, '0')}:${remainingSec.toString().padLeft(2, '0')}'),

              const SizedBox(height: 10),

              //! Verify OTP
              GestureDetector(
                onTap: () async {
                  try {
                    PhoneAuthCredential credential =
                        await PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: otpController.text.toString());
                    FirebaseAuth.instance
                        .signInWithCredential(credential)
                        .then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    });
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 100),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(143, 173, 222, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //! Resend OTP code
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t get the code?',
                    style:
                        TextStyle(color: Colors.grey[700], fontFamily: 'Kadwa'),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      // SignUpPage.globalKey.currentState?.numberOTP();
                    },
                    child: const Text(
                      'Resend the code',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                        fontFamily: 'Kadwa',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              //! Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or',
                        style: TextStyle(
                            color: Colors.grey[700], fontFamily: 'Kadwa'),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              //! Verif lewat Email
              GestureDetector(
                onTap: () => signUp(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 100),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                    child: Text(
                      'Send to Email',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
