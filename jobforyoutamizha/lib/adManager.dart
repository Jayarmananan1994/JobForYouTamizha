import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';

String adMobAppId = 'ca-app-pub-1698473155677356~6155661924';
String interatilAdUnit = 'ca-app-pub-1698473155677356/1450130155';
String bannerAdUnit = 'ca-app-pub-1698473155677356/9520191861';

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(keywords: ["job","vacancy"]);


 InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: interatilAdUnit,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    ); 
  }


 AdmobBanner createBannerAd(AdmobBannerSize adSize){
    AdmobBanner bannerAd;
  bannerAd = AdmobBanner(
      adUnitId: bannerAdUnit,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
         print("Banner $event");
      },
      adSize: AdmobBannerSize.BANNER,
    );
  return bannerAd;
  }