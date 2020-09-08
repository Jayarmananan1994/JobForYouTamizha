import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/model/JFTUser.dart';
import 'package:jobforyoutamizha/service/user_info_service.dart';
import 'package:jobforyoutamizha/service_locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobforyoutamizha/tabs/chat_room/user_chat.dart';
import 'package:dash_chat/dash_chat.dart';


class AdminChatList extends StatelessWidget {
  static const String PATH = '/admin-chat-list';
  final UserInfoService _userInfoService = locator<UserInfoService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Chat list')),
      body: Container(
        child: FutureBuilder<List<QueryDocumentSnapshot>>(
            future: _userInfoService.getAdminChatList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var item = data[index].data();
                      return ListTile(
                        title: Text(item['name']),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () => _gotoUserChat(context, item['id'], item['customerDeviceToken']),
                      );
                    });
              } else if (snapshot.hasError) {
                return Center(child: Text('No chat information'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  void _gotoUserChat(context, chatId, customerDeviceToken) async{
    JFTUser jftUser =  await _userInfoService.getCurrentSignedInUser();
    ChatUser chatUser = ChatUser(name: jftUser.displayName, avatar: jftUser.photoUrl,uid: jftUser.uid);
    var args = {
      "userName": jftUser.displayName,
      "roomId": chatId,
      "chatUser": chatUser,
      "deliverTo": customerDeviceToken
    };
    Navigator.of(context).pushNamed(UserChat.PATH, arguments: args);
  }
}
