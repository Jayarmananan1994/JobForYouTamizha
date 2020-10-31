import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/adManager.dart';
import 'package:jobforyoutamizha/common/constant.dart';
import 'package:jobforyoutamizha/service_locator.dart';
import 'package:jobforyoutamizha/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'router.dart' as router;
import 'package:admob_flutter/admob_flutter.dart';


bool signinAttempted = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize(ADMOB_APPID);
  await Firebase.initializeApp();
  setupLocator();
  runApp(JobForYouTamizha());
}

class JobForYouTamizha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage(LOGO_IMAGE_PATH), context);
    return MaterialApp(
      title: 'Job for you tamizha',
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
