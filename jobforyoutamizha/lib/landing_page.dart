import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/service/user_info_service.dart';
import 'package:jobforyoutamizha/service_locator.dart';
import 'package:jobforyoutamizha/tabs/categories/categories.dart';
import 'package:jobforyoutamizha/tabs/closing_jobs/closing_jobs.dart';
import 'package:jobforyoutamizha/tabs/help/help.dart';
import 'package:jobforyoutamizha/tabs/home/home.dart';
import 'package:jobforyoutamizha/tabs/profile/profile.dart';
import 'package:jobforyoutamizha/tabs/study_materials/study_materials.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jobforyoutamizha/main.dart';

class LandingPage extends StatefulWidget {
  static const String PATH = '/landing-tab';
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedTab = 0;
  List<Widget> _tabList;
  static List<TabMenu> _tabMenus = [
    TabMenu(0, 'Home', Icons.home),
    TabMenu(1, 'Jobs expiring Soon', Icons.business_center),
    TabMenu(2, 'Category', Icons.list),
    TabMenu(3, 'Study material', Icons.library_books),
    TabMenu(4, 'Profile', Icons.account_circle)
  ];
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['email']);

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final UserInfoService _userInfoService = locator<UserInfoService>();

  @override
  void initState() {
    initializeTabViews();
    if (!signinAttempted) {
      signinAttempted = true;
      _googleSignIn
          .signInSilently(suppressErrors: false)
          .then((value) => _userInfoService.updateAdminPhoneToken(value.email));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: getTitle()),
      body: _tabList[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onItemTapped,
        currentIndex: _selectedTab,
        items: _tabMenus
            .map((e) => BottomNavigationBarItem(
                  icon: Icon(e.icon),
                  backgroundColor: Colors.blue,
                  label: e.menuName,
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.chat_bubble), onPressed: _gotoHelp),
    );
  }

  appTitle() {}
  void onItemTapped(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  void initializeTabViews() {
    _tabList = [
      Home(),
      ClosingJobs(),
      Categories(),
      StudyMaterials(),
      Profile()
    ];
  }

  getTitle() {
    return Text(_tabMenus[_selectedTab].menuName);
  }

  void _gotoHelp() async {
    Navigator.of(context).pushNamed(Help.PATH);
  }
}

class TabMenu {
  int position;
  String menuName;
  IconData icon;
  TabMenu(this.position, this.menuName, this.icon);
}
