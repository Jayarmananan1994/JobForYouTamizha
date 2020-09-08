import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/common/constant.dart';
import 'package:jobforyoutamizha/landing_page.dart';
import 'package:jobforyoutamizha/service/job_info_service.dart';
import 'package:jobforyoutamizha/service/user_info_service.dart';
import 'package:jobforyoutamizha/service_locator.dart';

class SplashScreen extends StatelessWidget {
  final JobInfoService _jobInfoService = locator<JobInfoService>();
  static const String PATH = '/splash-screen';
   final UserInfoService _userInfoService = locator<UserInfoService>();

  @override
  Widget build(BuildContext context) {
    _navigateToHomePage(context);
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: _width,
        color: Colors.black, //Color(0xff565656),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage(LOGO_IMAGE_PATH), fit: BoxFit.fill))),
            SizedBox(height: 30),
            Text('Welcome',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.w800)),
                    SizedBox(height: 20),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }

  void _navigateToHomePage(context) {
     _userInfoService.getCurrentSignedInUser();
     _userInfoService.getAdminUser();
    _jobInfoService.getJobsByCategories('Government Job').then((value) => Navigator.pushNamedAndRemoveUntil(context, LandingPage.PATH, (route) => false));
  }
}
