// ignore_for_file: use_build_context_synchronously, avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/ChatComponents/DetailChat.dart';

import 'package:project/ChatComponents/doctorChatPage.dart';
import 'package:project/ChatComponents/userTile.dart';
import 'package:project/ChatComponents/chatService.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final TextEditingController messageController = TextEditingController();
  final chatService cs = chatService();

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(fontFamily: 'Outfit', fontSize: 25),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<Widget>(
        future: userOrDoctor(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return snapshot.data ?? Container();
        },
      ),
    );
  }

  Future<Widget> userOrDoctor(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? userId = user?.uid;
    String? currentUserEmail = user?.email;

    if (userId != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      String? userRole = userSnapshot['role'];

      if (userRole == 'docter') {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('docter')
            .where('email', isEqualTo: currentUserEmail)
            .get();

        String docId = querySnapshot.docs[0].id;

        CollectionReference chatRoomsCollection = FirebaseFirestore.instance.collection('chat_rooms');
        DocumentSnapshot chatRoomDoc = await chatRoomsCollection.doc('R1JQaf7PWVqjc2ByonJf_UY2VuO3XehakiTC8WacnJG2BS1x2').get();
        CollectionReference messagesCollection = chatRoomDoc.reference.collection('messages');
        DocumentSnapshot messageDoc = await messagesCollection.doc('mAl8F7liahP1z4W1zvxg').get();
        String senderEmail = messageDoc['senderEmail'];

        if (querySnapshot.docs.isNotEmpty) {
          return DoctorChatPage(
            receiverId: docId,
            receiverEmail: senderEmail,
          );
        }
        return Container();
      } else {
        return buildUserList();
      }
    } else {
      return const Center(child: Text('User not authenticated'));
    }
  }

  Widget buildUserList() {
    return StreamBuilder(
      stream: cs.getBookedDoctorsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (doctorData) => buildUserListItem(doctorData, context))
                .toList(),
          );
        } else {
          return const Center(child: Text('No booked doctors available'));
        }
      },
    );
  }

  Widget buildUserListItem(
      Map<String, dynamic> doctorData, BuildContext context) {
    // Print doctorData to debug its structure
    print('Doctor Data: $doctorData');

    final doctorName = doctorData['name'] ?? 'Unknown Doctor';
    final doctorId = doctorData['uid'] ?? 'Unknown ID';

    return UserTile(
      text: doctorName,
      onTap: () async {
        try {
          final canChat = await canUserChatWithDoctor(doctorId);
          if (canChat) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailChatPage(
                  receiverEmail: doctorName,
                  receiverID: doctorId,
                ),
              ),
            );
          } else {
            showSchedulePopup(context);
          }
        } catch (e) {
          print('Error checking chat availability: $e');
          showErrorPopup(context, e.toString());
        }
      },
    );
  }

  Future<bool> canUserChatWithDoctor(String doctorId) async {
    try {
      final userId = getCurrentUser()!.uid;
      final appointmentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (appointmentSnapshot.docs.isNotEmpty) {
        final appointment = appointmentSnapshot.docs.first.data();
        final appointmentDate = appointment['date'];
        final appointmentTime = appointment['time'];

        final appointmentDateTime = DateFormat('EEE, dd MMM yyyy hh:mm')
            .parse('$appointmentDate $appointmentTime');

        print('Current time: ${DateTime.now()}');
        print('Appointment time: $appointmentDateTime');

        // Compare the current time and date with the appointment time and date
        if (DateTime.now().isAfter(appointmentDateTime)) {
          print('User can chat');
          return true;
        } else {
          print('User cannot chat');
          return false;
        }
      } else {
        print('No appointment found');
        return false;
      }
    } catch (e) {
      print('Error in canUserChatWithDoctor: $e');
      rethrow;
    }
  }

  void showSchedulePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chat Unavailable'),
          content: const Text(
              'You can only chat with the doctor according to the selected schedule.'),
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

  void showErrorPopup(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
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
}