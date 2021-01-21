import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/service/app_config_service.dart';
import 'package:jobforyoutamizha/service_locator.dart';
import 'package:native_flutter_admob/native_flutter_admob.dart';

//Real adIds
// String adMobAppId = 'ca-app-pub-1698473155677356~6155661924';
// String interatilAdUnit = 'ca-app-pub-1698473155677356/1450130155';
// String bannerAdUnit = 'ca-app-pub-1698473155677356/9520191861';
// String nativeAdUnit = 'ca-app-pub-1698473155677356/4812086205';

//Mock ad Ids
// String adMobAppId = 'ca-app-pub-3940256099942544~4354546703';
// String interatilAdUnit = 'ca-app-pub-3940256099942544/7049598008';
// String bannerAdUnit = 'ca-app-pub-3940256099942544/8865242552';
// String nativeAdUnit = 'ca-app-pub-1698473155677356/4812086205';



AppInfoService _appInfoService = locator<AppInfoService>();

MobileAdTargetingInfo getTargetingInfo() {
  List<String> targetInfo = _appInfoService.getTargetInfo();
  var val = (targetInfo ==null || targetInfo.isEmpty) ? null:  MobileAdTargetingInfo(keywords: targetInfo);
  return val;
}

InterstitialAd createInterstitialAd() {
  return InterstitialAd(
    adUnitId: _appInfoService.getInterstitialAd(),
    targetingInfo: getTargetingInfo(),
    listener: (MobileAdEvent event) {
      print(">>>>>>>>>>>>>>>>InterstitialAd event $event");
    },
  );
}


AdmobBanner createBannerAd(AdmobBannerSize adSize) {
  AdmobBanner bannerAd;
  bannerAd = AdmobBanner(
    adUnitId: _appInfoService.getBannerAdId(),
    listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      print("Banner $event");
    },
    adSize: AdmobBannerSize.BANNER,
  );
  return bannerAd;
}

createNativeAd() {
  return Container(
    padding: EdgeInsets.all(5),
    child: NativeAdmobBannerView(
      adUnitID: _appInfoService.getNativeAdId(),
      style: BannerStyle.dark, // enum dark or light
      showMedia: true, // whether to show media view or not
      contentPadding:
          EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0), // content padding
    ),
  );
}
// createNativeAd(NativeAdmobController controller) {
//   return NativeAdmob(
//     adUnitID: bannerAdUnit,
//     controller: controller,
//     type: NativeAdmobType.banner,
//   );
// }
