import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/messages_stream.dart';
import 'package:flash_chat/components/show_dialog.dart';
import 'package:flash_chat/shared/constants.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const String id = "chatScreen";

  const ChatScreen({Key? key}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  String? messageText;
  final messageTextController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  User? loggedInUser;

  // Logout Method
  logout() {
    auth.signOut();
    Navigator.pop(context);
  }

  // Get current user
  void getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // Create a CollectionReference called messages that references the firestore collection
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  // Send User Message and Email to Cloud Firestore
  Future<DocumentReference> sendMessage() async {
    return messages.add({
      'text': messageText!,
      'sender': loggedInUser!.email,
      'timestamp': FieldValue.serverTimestamp(),
    }).catchError(
      // ignore: invalid_return_type_for_catch_error
      (error) => showAlertDialog(
        context,
        "Error",
        error.toString(),
      ),
    );
  }

  // Get a QuerySnapchot of our messages
  // void getMessagesStream() async {
  //   firestore.collection("messages").snapshots().listen((snapshot) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   });
  // }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                logout();
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(
              firestore: firestore,
              loggedInUser: loggedInUser!,
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      sendMessage();
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

