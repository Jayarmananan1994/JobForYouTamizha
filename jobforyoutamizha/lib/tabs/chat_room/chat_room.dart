import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom extends StatelessWidget {
  final ChatUser user;
  final String chatRoomId;
  final String deliverTo;

  const ChatRoom({Key key, this.user, this.chatRoomId, this.deliverTo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('chats/'+chatRoomId+'/messages').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)),
                    );
                  } else {
                    List<DocumentSnapshot> items = snapshot.data.documents;
                    var messages =
                        items.map((i) => ChatMessage.fromJson(i.data())).toList();
                    return DashChat(
                      user: user,
                      messages: messages,
                      inputDecoration: InputDecoration(
                        hintText: "Message here...",
                        border: InputBorder.none,
                      ),
                      onSend: onSend,
                    );
                  }
                },
              );
  }

   void onSend(ChatMessage message) {
     message.customProperties = {
       'deliverTo': deliverTo,
       'chatRoomId': chatRoomId
     };
    var documentReference = FirebaseFirestore.instance
        .collection('chats/'+chatRoomId+'/messages')
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    });
  }

}
