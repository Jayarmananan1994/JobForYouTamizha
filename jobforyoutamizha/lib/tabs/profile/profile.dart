import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/tabs/profile/membership.dart';
import 'package:jobforyoutamizha/tabs/profile/privacy_policy.dart';
import 'package:jobforyoutamizha/tabs/profile/signin.dart';

class Profile extends StatelessWidget {

  buildMenu(context) {
    var menuItems = [
      ProfileMenuItem('Welcome', 'Not Registered? Register now',
          Icons.account_circle, () => navigationAction(Signin.PATH, context)),
      ProfileMenuItem('Become a member', 'Click to know more about benefits!',
          Icons.monetization_on,  () => navigationAction(MemberShip.PATH, context)),
      ProfileMenuItem(
          'Privacy policy', 'App terms & policies', Icons.lock,  () => navigationAction(PrivacyPolicy.PATH, context)),
      ProfileMenuItem('Rate us', 'Give us your Feedback', Icons.star, () {}),
    ];
    return menuItems;
  }
  navigationAction(String path, context) {
    Navigator.of(context).pushNamed(path);
  }

  @override
  Widget build(BuildContext context) {
    var menuItems = buildMenu(context);
    return Container(
        child: ListView.builder(
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        var menu = menuItems[index];
        return ListTile(
            leading: Icon(menu.icon, size: 30),
            title: Text(menu.menuName),
            subtitle: Text(menu.description),
            onTap: menu.action);
      },
    ));
  }
}

class ProfileMenuItem {
  String menuName;
  String description;
  IconData icon;
  Function action;

  ProfileMenuItem(this.menuName, this.description, this.icon, this.action);
}
