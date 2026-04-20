import 'package:flutter/material.dart';
import 'package:trackpe/const.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  bool _wasInBackground = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _wasInBackground = true;
    }
    if (state == AppLifecycleState.resumed && _wasInBackground) {
      _wasInBackground = false;
      if (!isInterShowed) {
        gAds.openAdsInstance.showAdIfAvailableOpenAds();
      }
      isInterShowed = false;
    }
  }

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
