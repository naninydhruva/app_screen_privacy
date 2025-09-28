import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppScreenPrivacy with WidgetsBindingObserver {
  static const MethodChannel _channel = MethodChannel('app_screen_privacy');
  static final AppScreenPrivacy _instance = AppScreenPrivacy._internal();
  AppScreenPrivacy._internal();
  static String? _logo;
  static String? _backgroundColor;

  static void init({String? logo, String? backgroundColor}) {
    _logo = logo;
    _backgroundColor = backgroundColor;
    WidgetsBinding.instance.addObserver(_instance);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await _channel.invokeMethod('hidePrivacyScreen');
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _channel.invokeMethod('showPrivacyScreen', {
          'logo': _logo,
          'backgroundColor': _backgroundColor,
        });
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }
}
