import 'package:jobforyoutamizha/model/JFTUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfoService {
  Firestore _firestore;
  FirebaseAuth _firebaseAuth;
  JFTUser _currentSignedInUser;

  Future<void> addNewUser(String uid, String emailId, String displayName, String photoUrl) {
      JFTUser jftUser = JFTUser(uid, displayName, emailId, photoUrl);
      return getFirestore().collection('users').document(uid).setData(jftUser.toMap());

  }

  Future<JFTUser> getCurrentSignedInUser() async {
    if (_currentSignedInUser == null) {
      print('>>> signingn in>>>>>>>>> ');
      var firebaseAuth = getFirebaseAuth();
      var fireStore = getFirestore();
      FirebaseUser firebaseUser = await firebaseAuth.currentUser();
      if (firebaseUser == null) {
        return null;
      }

      var result = await fireStore.collection('users').document(firebaseUser.uid).get();

      _currentSignedInUser = JFTUser.fromMap(result.data);
      return _currentSignedInUser;
    } else {
      return _currentSignedInUser;
    }
  }

   Future<void> signout() {
    _currentSignedInUser = null;
    return getFirebaseAuth().signOut();
  }

  FirebaseAuth getFirebaseAuth() {
    if (_firebaseAuth == null) {
      _firebaseAuth = FirebaseAuth.instance;
    }
    return _firebaseAuth;
  }

  Firestore getFirestore() {
    if (_firestore == null) _firestore = Firestore.instance;
    return _firestore;
  }
}
