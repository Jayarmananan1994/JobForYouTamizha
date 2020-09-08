class JFTUser {
  String uid;
  String displayName;
  String emailId;
  String photoUrl;
  static JFTUser ANONYMOUS_USER = JFTUser("", "", "", "");
  static JFTUser ADMIN_USER = JFTUser("","admin","","");

  JFTUser(this.uid, this.displayName, this.emailId, this.photoUrl);

  toMap() {
    Map<String, String> data = {};
    data['uid'] = uid;
    data['displayName'] = displayName;
    data['emailId'] = emailId;
    data['photoUrl'] = photoUrl;
    return data;
  }

  static fromMap(data) {
    return JFTUser(
        data['uid'], data['displayName'], data['emailId'], data['photoUrl']);
  }
}
