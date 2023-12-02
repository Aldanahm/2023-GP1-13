import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  var _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid; // Retrieve the user ID from Firebase Auth

      // Reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the user's document
      DocumentReference userDoc = firestore.collection('chats').doc(userId);

      // Get the existing data of the user's document
      final userDocSnapshot = await userDoc.get();
      final Map<String, dynamic>? userData =
          userDocSnapshot.data() as Map<String, dynamic>?;

      Map<String, dynamic> data = {
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 1),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _messageController,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      enableSuggestions: true,
                      decoration:
                          const InputDecoration(labelText: "Send a message..."),
                    ),
                  ),
                  IconButton(
                    color: Theme.of(context).colorScheme.primary,
                    icon: const Icon(Icons.send),
                    onPressed: _submitMessage,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
