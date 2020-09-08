import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:jobforyoutamizha/model/JFTUser.dart';
import 'package:jobforyoutamizha/service/user_info_service.dart';
import 'package:jobforyoutamizha/service_locator.dart';
import 'package:jobforyoutamizha/tabs/chat_room/chat_room.dart';

class Help extends StatefulWidget {
  static const String PATH = '/help';
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  ChatUser user = ChatUser();
  UserInfoService _userInfoService = locator<UserInfoService>();
  String _chatRoom;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with us')),
      body: FutureBuilder<JFTUser>(
          future: _getUserInfo(), //_userInfoService.getCurrentSignedInUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)));
            } else {
              var signedInUser = snapshot.data;
              
              if(signedInUser.displayName== JFTUser.ANONYMOUS_USER.displayName){
                  return Center(child: Text('Please sign in'));
              } else if(signedInUser.displayName== JFTUser.ADMIN_USER.displayName){
                    return Center(child: Text('This page is not for admin. 😉'));
              }else{
                user = ChatUser(
                  avatar: signedInUser.photoUrl,
                  name: signedInUser.displayName,
                  uid: signedInUser.uid);
                  return ChatRoom(user: user,chatRoomId: _chatRoom, deliverTo: 'admin',);
              
              }
              
            }
          }),
    );
  }
  
  Future<JFTUser> _getUserInfo() async {
    JFTUser user = await _userInfoService.getCurrentSignedInUser();

    if(user==null){
      return JFTUser.ANONYMOUS_USER;
    }
    List adminUsers = await _userInfoService.getAdminUser();
    if(adminUsers.contains(user.emailId)){
        return JFTUser.ADMIN_USER;
    }
    _chatRoom = 'messages_' + user.uid;
    _userInfoService.addChatRoom(user);
    return user;
  }
}
