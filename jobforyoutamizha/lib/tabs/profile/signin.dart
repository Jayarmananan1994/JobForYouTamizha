import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jobforyoutamizha/landing_page.dart';
import 'package:jobforyoutamizha/model/JFTUser.dart';
import 'package:jobforyoutamizha/service/user_info_service.dart';
import 'package:jobforyoutamizha/service_locator.dart';
import 'package:jobforyoutamizha/tabs/home/home.dart';

class Signin extends StatefulWidget {
  static const String PATH = '/signin';

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final UserInfoService _userInfoService = locator<UserInfoService>();

  @override
  Widget build(BuildContext context) {
    var userFuture = _userInfoService.getCurrentSignedInUser();

    return Scaffold(
      appBar: AppBar(title: Text('Sign in')),
      body: FutureBuilder<JFTUser>(
          future: userFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _profileScreen(snapshot.data, context);
            } else {
              return _signinScreen();
            }
          }),
    );
  }

  _signinScreen() {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _signInButton(),
              //Container(
              // padding: EdgeInsets.symmetric(vertical: 10),
              // child: Text('---------- or ------------')),
              // _signOutButton(),
            ]));
  }

  Widget _signInButton() {
    return Container(
      width: 300,
      //color: Colors.red,
      child: OutlineButton(
        color: Colors.red,
        splashColor: Colors.grey,
        onPressed: _googleSignin,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        //borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage("assets/images/google_logo.png"),
                  height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xffdd4c39),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _signOutButton() {
    return Container(
      width: 300,
      child: OutlineButton(
        splashColor: Colors.grey,
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage("assets/images/google_logo.png"),
                  height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Signup with Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _profileScreen(JFTUser user, context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              width: 180,
              height: 200,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(user.photoUrl), fit: BoxFit.fill))),
          SizedBox(height: 50),
          Text(user.displayName,
              style: TextStyle(color: Colors.black, fontSize: 30)),
          RaisedButton(
              color: Colors.blue,
              onPressed: () => _logout(context),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }

  _googleSignin() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try {
      GoogleSignInAccount _googleAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await _googleAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      AuthResult authResult = await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;
      _userInfoService
          .addNewUser(user.uid, user.email, _googleAccount.displayName,
              _googleAccount.photoUrl)
          .then((r) {
        print("Creating done");
        setState(() {
          
        });
      });
    } catch (error) {
      print('>>>>>>>>');
      print(error);
    }
  }

  _logout(context) {
    _userInfoService
        .signout()
        .then((value) => Navigator.of(context).pushNamed(LandingPage.PATH));
  }
}
