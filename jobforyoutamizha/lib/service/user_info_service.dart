import 'package:jobforyoutamizha/model/JFTUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info/device_info.dart';

class UserInfoService {
  FirebaseFirestore _firestore;
  FirebaseAuth _firebaseAuth;
  JFTUser _currentSignedInUser;
  List<String> _adminUsers;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      //'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Future<void> addNewUser(
      String uid, String emailId, String displayName, String photoUrl) {
    JFTUser jftUser = JFTUser(uid, displayName, emailId, photoUrl);
    return getFirestore().collection('users').doc(uid).set(jftUser.toMap());
  }

  Future<List<String>> getAdminUser() async {
    if (_adminUsers == null) {
      var docRef = await getFirestore()
          .collection('adminusers')
          .doc('K8ZVkgtuS9MuEhGeKN86')
          .get();
      var data = docRef.data();
      List emailsdyn = data['emails'];
      _adminUsers = emailsdyn.map((e) => e.toString()).toList();
    }
    return _adminUsers;
  }

  Future<JFTUser> getCurrentSignedInUser() async {
    if (_currentSignedInUser == null) {
      print('>>> signingn in>>>>>>>>> ');
      var firebaseAuth = getFirebaseAuth();
      var fireStore = getFirestore();
      User firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) {
        return null;
      }

      var result =
          await fireStore.collection('users').doc(firebaseUser.uid).get();

      _currentSignedInUser = JFTUser.fromMap(result.data());
      return _currentSignedInUser;
    } else {
      return _currentSignedInUser;
    }
  }

  Future<void> addChatRoom(JFTUser user) async{
   var deviceToken =  await getDeviceToken();
    var chatRoomInfo = {
      "id": "messages_" + user.uid,
      "name": user.displayName,
      "updatedOn": DateTime.now(),
      "customerDeviceToken": deviceToken
    };
    return getFirestore()
        .collection('chatroom')
        .doc("messages_" + user.uid)
        .set(chatRoomInfo);
  }

  Future<List<QueryDocumentSnapshot>> getAdminChatList() async {
    var snapshot = await getFirestore().collection('chatroom').get();
    return snapshot.docs;
  }

  Future<void> signout() async {
    _currentSignedInUser = null;
    await _googleSignIn.disconnect();
    return getFirebaseAuth().signOut();
  }

  FirebaseAuth getFirebaseAuth() {
    if (_firebaseAuth == null) {
      _firebaseAuth = FirebaseAuth.instance;
    }
    return _firebaseAuth;
  }

  FirebaseFirestore getFirestore() {
    if (_firestore == null) _firestore = FirebaseFirestore.instance;
    return _firestore;
  }

  Future<String> getDeviceToken() {
    return firebaseMessaging.getToken();
  }

  Future<void> updateAdminPhoneToken(email) async {
    List<String> adminEmails = await getAdminUser();
    if (adminEmails.contains(email)) {
      var deviceToken = await getDeviceToken();
      var deviceData = await deviceInfoPlugin.androidInfo;
      var data = {
        "phonetoken": deviceToken,
        "model": deviceData.model,
        "manufacturer": deviceData.manufacturer,
        "isPhysicalDevice": deviceData.isPhysicalDevice
      };
      getFirestore()
          .collection('adminphones')
          .doc(email)
          .set(data);
    }
  }
}
