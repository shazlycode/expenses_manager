import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<BannerAd?> loadBannerAd(BuildContext context, String adUnitId) async {
  // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
  final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.truncate());

  BannerAd? bannerAd = BannerAd(
    adUnitId: adUnitId,
    request: const AdRequest(),
    size: size!,
    listener: BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (ad) {
        debugPrint('$ad loaded.');
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (ad, err) {
        debugPrint('BannerAd failed to load: $err');
        // Dispose the ad here to free resources.
        ad.dispose();
      },
    ),
  )..load();

  return bannerAd;
}

// TODO: replace this test ad unit with your own ad unit.

/// Loads an interstitial ad.

Future<InterstitialAd?> loadInterStiial(
    {required String adUnitInterstatialId}) async {
  InterstitialAd? interstitialAd;

  InterstitialAd.load(
      adUnitId: adUnitInterstatialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          interstitialAd = ad;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ));
  return interstitialAd!;
}

// Future<InterstitialAd?> loadInterstitialAd(String adUnitId) async {
//   InterstitialAd? interstitialAd;

//   await InterstitialAd.load(
//     adUnitId: adUnitId,
//     request: const AdRequest(),
//     adLoadCallback: InterstitialAdLoadCallback(
//       // Called when an ad is successfully received.
//       onAdLoaded: (ad) {
//         debugPrint('$ad loaded.');
//         interstitialAd = ad;
//       },
//       // Called when an ad request failed.
//       onAdFailedToLoad: (LoadAdError error) {
//         debugPrint('InterstitialAd failed to load: $error');
//       },
//     ),
//   );

//   return interstitialAd;
// }
