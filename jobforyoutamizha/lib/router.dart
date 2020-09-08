import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/landing_page.dart';
import 'package:jobforyoutamizha/model/JobPost.dart';
import 'package:jobforyoutamizha/model/category.dart';
import 'package:jobforyoutamizha/splash_screen.dart';
import 'package:jobforyoutamizha/tabs/categories/category_result.dart';
import 'package:jobforyoutamizha/tabs/chat_room/user_chat.dart';
import 'package:jobforyoutamizha/tabs/help/help.dart';
import 'package:jobforyoutamizha/tabs/home/job_detail.dart';
import 'package:jobforyoutamizha/tabs/profile/admin_chat_list.dart';
import 'package:jobforyoutamizha/tabs/profile/membership.dart';
import 'package:jobforyoutamizha/tabs/profile/privacy_policy.dart';
import 'package:jobforyoutamizha/tabs/profile/signin.dart';
import 'package:jobforyoutamizha/tabs/search_result/search_result.dart';
import 'package:jobforyoutamizha/tabs/study_materials/open_file.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LandingPage.PATH:
      return MaterialPageRoute(builder: (context) => LandingPage());
    case CategoryResult.PATH:
      Category category = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => CategoryResult(category: category));
    case JobDetail.PATH:
      JobPost jobPost = settings.arguments;
      return MaterialPageRoute(builder: (context) => JobDetail(jobPost));
    case OpenFile.PATH:
      Attachment attachment = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => OpenFile(attachment: attachment));
    case SplashScreen.PATH:
      return MaterialPageRoute(builder: (context) => SplashScreen());
    case SearchResult.PATH:
      String searchString = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => SearchResult(searchString: searchString));
    case PrivacyPolicy.PATH:
      return MaterialPageRoute(builder: (context) => PrivacyPolicy());
    case Signin.PATH:
      return MaterialPageRoute(builder: (context) => Signin());
    case MemberShip.PATH:
      return MaterialPageRoute(builder: (context) => MemberShip());
    case Help.PATH:
      return MaterialPageRoute(builder: (context) => Help());
    case AdminChatList.PATH:
      return MaterialPageRoute(builder: (context) => AdminChatList());    
    case UserChat.PATH:
       Map args = settings.arguments;
      return MaterialPageRoute(builder: (context) => 
          UserChat(userName: args['userName'], roomId: args['roomId'], chatUser: args['chatUser']));
    default:
      return MaterialPageRoute(builder: (context) => LandingPage());
  }
}
