import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/tabs/categories/categories.dart';
import 'package:jobforyoutamizha/tabs/closing_jobs/closing_jobs.dart';
import 'package:jobforyoutamizha/tabs/home/home.dart';
import 'package:jobforyoutamizha/tabs/profile/profile.dart';
import 'package:jobforyoutamizha/tabs/study_materials/study_materials.dart';

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
  @override
  void initState() {
    initializeTabViews();
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
                  title: new Text(e.menuName),
                ))
            .toList(),
      ),
      floatingActionButton: Container(
      width: 65.0,
      height: 65.0,
      child: new RawMaterialButton(
        shape: new CircleBorder(),
        elevation: 0.0,
        fillColor: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Text('TNEB', style: TextStyle(color: Colors.white,),),
          Text('data', style: TextStyle(color: Colors.white,))
        ],),
      onPressed: (){},
      ),
      ),
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
}

class TabMenu {
  int position;
  String menuName;
  IconData icon;
  TabMenu(this.position, this.menuName, this.icon);
}
