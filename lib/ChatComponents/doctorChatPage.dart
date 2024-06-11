// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/ChatComponents/chatBubble.dart';
import 'package:project/ChatComponents/chatService.dart';

class DoctorChatPage extends StatefulWidget {
  final String receiverId;
  final String receiverEmail;
  const DoctorChatPage(
      {super.key, required this.receiverId, required this.receiverEmail});

  @override
  State<DoctorChatPage> createState() => _DoctorChatPageState();
}

class _DoctorChatPageState extends State<DoctorChatPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> getChatRooms() {
      return FirebaseFirestore.instance
          .collection('chat_rooms')
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: 'docId_')
          .where(FieldPath.documentId, isLessThan: 'docId_\uf8ff')
          .snapshots();
    }

    final TextEditingController messageController = TextEditingController();
    final chatService cs = chatService();
    final FocusNode myFocusNode = FocusNode();
    final ScrollController scrollController = ScrollController();

    User? getCurrentUser() {
      return FirebaseAuth.instance.currentUser;
    }

    void scrollDown() {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    }

    @override
    void initState() {
      super.initState();
      myFocusNode.addListener(() {
        if (myFocusNode.hasFocus) {
          Future.delayed(const Duration(milliseconds: 100), scrollDown);
        }
      });
      Future.delayed(const Duration(milliseconds: 100), scrollDown);
    }

    @override
    void dispose() {
      myFocusNode.dispose();
      messageController.dispose();
      super.dispose();
    }

    void sendMessage() async {
      if (messageController.text.isNotEmpty) {
        await cs.sendMessage(widget.receiverId, messageController.text);
        messageController.clear();
      }
      scrollDown();
    }

    Widget showChat() {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc('R1JQaf7PWVqjc2ByonJf_UY2VuO3XehakiTC8WacnJG2BS1x2');

      CollectionReference subCollectionRef = docRef.collection('messages');

      return StreamBuilder<QuerySnapshot>(
        stream: subCollectionRef
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching chat data'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No messages'));
          }

          final messages = snapshot.data!.docs;

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final messageData =
                  messages[index].data() as Map<String, dynamic>;
              final message = messageData['message'] as String? ?? '';
              final senderId = messageData['senderID'] as String? ?? '';
              final isCurrentUser = senderId == widget.receiverId;

              return ListTile(
                  title: ChatBubble(
                      message: message, isCurrentUser: isCurrentUser));
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: showChat(),
    );
  }
}
