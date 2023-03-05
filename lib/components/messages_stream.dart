import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/message_bubble.dart';
import 'package:flutter/material.dart';

class MessagesStream extends StatelessWidget {
  const MessagesStream({
    super.key,
    required this.firestore,
    required this.loggedInUser,
  });

  final FirebaseFirestore firestore;
  final User loggedInUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('messages').orderBy("timestamp").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 3,
            ),
            child: const CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        // A list of all document snapshots
        final chatMessages = snapshot.data!.docs.reversed;

        // An empty list of our MessageBubble Class
        List<MessageBubble> messageBubbles = [];

        for (var message in chatMessages) {
          final messageText = message["text"];
          final messageSender = message["sender"];

          // Current User
          final currentUser = loggedInUser.email;

          // Create a new MessageBubble Widget for every new chatMessage snapshot
          final messageWidget = MessageBubble(
            text: messageText,
            sender: messageSender,
            thisUser: currentUser == messageSender,
          );

          // Add the created MessageBubble to the list of messages
          messageBubbles.add(messageWidget);
        }

        // Return our messageBubbles in a ListView as a child of an Expanded Widget which takes up only the available space making it scrollable in case of overflow
        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}
