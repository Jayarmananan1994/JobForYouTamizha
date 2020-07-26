import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/common/constant.dart';
import 'package:jobforyoutamizha/service_locator.dart';
import 'package:jobforyoutamizha/splash_screen.dart';

import 'router.dart' as router;

void main() {
  setupLocator();
  runApp(JobForYouTamizha());
}

class JobForYouTamizha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage(LOGO_IMAGE_PATH), context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: SplashScreen.PATH,
      onGenerateRoute: router.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
