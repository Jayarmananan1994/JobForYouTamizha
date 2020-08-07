import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/service/user_info_service.dart';
import 'package:jobforyoutamizha/service_locator.dart';
import 'package:jobforyoutamizha/tabs/profile/membership.dart';
import 'package:jobforyoutamizha/tabs/profile/privacy_policy.dart';
import 'package:jobforyoutamizha/tabs/profile/signin.dart';

class Profile extends StatelessWidget {
  final UserInfoService _userInfoService = locator<UserInfoService>();

  Future<List<ProfileMenuItem>> buildMenu(context) async {
    var userFuture = await _userInfoService.getCurrentSignedInUser();
    var menu1title =
        (userFuture != null) ? 'Welcome ' + userFuture.displayName : 'Welcome';
    var menu1Subtitle =
        (userFuture != null) ? 'View Profile' : 'Not Registered? Register now';
    var menuItems = [
      ProfileMenuItem(menu1title, menu1Subtitle, Icons.account_circle,
          () => navigationAction(Signin.PATH, context)),
      ProfileMenuItem(
          'Become a member',
          'Click to know more about benefits!',
          Icons.monetization_on,
          () => navigationAction(MemberShip.PATH, context)),
      ProfileMenuItem('Privacy policy', 'App terms & policies', Icons.lock,
          () => navigationAction(PrivacyPolicy.PATH, context)),
      ProfileMenuItem('Rate us', 'Give us your Feedback', Icons.star, () {}),
    ];
    return menuItems;
  }

  navigationAction(String path, context) {
    Navigator.of(context).pushNamed(path);
  }

  @override
  Widget build(BuildContext context) {
    var menuItemsFuture = buildMenu(context);
    return Container(
        child: FutureBuilder<List<ProfileMenuItem>>(
      future: menuItemsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var menuItems = snapshot.data;
          return ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                var menu = menuItems[index];
                return ListTile(
                    leading: Icon(menu.icon, size: 30),
                    title: Text(menu.menuName),
                    subtitle: Text(menu.description),
                    onTap: menu.action);
              });
        }else{
          return Center(child: CircularProgressIndicator(),);
        }
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
