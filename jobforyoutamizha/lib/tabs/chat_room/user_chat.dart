import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/tabs/chat_room/chat_room.dart';
import 'package:dash_chat/dash_chat.dart';

class UserChat extends StatelessWidget {
   static const String PATH = '/user-chat';
  final String userName;
  final String roomId;
  final ChatUser chatUser;
  final String deliverTo;

  const UserChat({Key key, this.userName, this.roomId, this.chatUser, this.deliverTo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(userName)),
      body: Container(
        child: ChatRoom(user: chatUser, chatRoomId: roomId, deliverTo: deliverTo ),
      ),
    );
  }
}