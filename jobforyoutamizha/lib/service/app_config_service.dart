import 'package:cloud_firestore/cloud_firestore.dart';

class AppInfoService {
  FirebaseFirestore _firestore;
  Map _appConfig;
  int _currentAdInterval = 0;

  void preLoadAppConfig() {
    fetchAppConfig().then((value) {
      _appConfig = value.docs[0].data();
    });
  }

  Future<QuerySnapshot> fetchAppConfig() =>
      getFirestore().collection('config').get();

  FirebaseFirestore getFirestore() {
    if (_firestore == null) _firestore = FirebaseFirestore.instance;
    return _firestore;
  }

  Map getAppConfig() {
    if (_appConfig == null) {
      preLoadAppConfig();
    }
    return _appConfig;
  }

  bool canShowInterratialAd() {
    Map appconfig = getAppConfig();
    int adInterval = appconfig['interasialAdInterval'];
    bool isCycleBeginning = _currentAdInterval == 0;
    bool isEndOfInterval = _currentAdInterval == adInterval;
    if (isCycleBeginning) {
      _currentAdInterval = 1;
      return true;
    } else {
      (isEndOfInterval) ? _currentAdInterval = 0 : _currentAdInterval += 1;
      return false;
    }
  }

  String getNativeAdId() {
    Map adUnitIds = getCurrentAdUnits();
    return adUnitIds['nativeAd'];
  }

  String getBannerAdId() {
    Map adUnitIds = getCurrentAdUnits();
    return adUnitIds['bannerAd'];
  }

  String getInterstitialAd() {
    Map adUnitIds = getCurrentAdUnits();
    return adUnitIds['interstitialAd'];
  }

  Map getCurrentAdUnits() {
    Map appconfig = getAppConfig();
    String schema = appconfig['currentAdScheme'];
    Map adUnitIds = appconfig[schema];
    return adUnitIds;
  }

  int nativeAdInterval() {
    Map appconfig = getAppConfig();
    return appconfig['nativeAdInterval'];
  }

  List<String> getTargetInfo() {
    Map appconfig = getAppConfig();
    return List<String>.from(appconfig['adTarget']);
  }
}
