import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppScreenPrivacy with WidgetsBindingObserver {
  static const MethodChannel _channel = MethodChannel('app_screen_privacy');
  static final AppScreenPrivacy _instance = AppScreenPrivacy._internal();
  AppScreenPrivacy._internal();
  static String? _logo;
  static String? _backgroundColor;
  static bool? _shouldPreventScreenShot;

  static void init({
    String? logo,
    String? backgroundColor,
    bool shouldPreventScreenShot = true,
  }) {
    _logo = logo;
    _backgroundColor = backgroundColor;
    _shouldPreventScreenShot = shouldPreventScreenShot;
    if (shouldPreventScreenShot) {
      _channel.invokeMethod('enableScreenShotProtection');
    } else {
      _channel.invokeMethod('disableScreenShotProtection');
    }
    WidgetsBinding.instance.addObserver(_instance);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        _channel.invokeMethod('hidePrivacyScreen', {
          'shouldPreventScreenShot': _shouldPreventScreenShot,
        });
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _channel.invokeMethod('showPrivacyScreen', {
          'logo': _logo,
          'backgroundColor': _backgroundColor,
          'shouldPreventScreenShot': _shouldPreventScreenShot,
        });
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }
}
